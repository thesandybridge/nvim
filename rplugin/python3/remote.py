import json
import threading
from pynvim import attach, plugin, command, autocmd
import websocket
try:
    from queue import Queue
except ImportError:
    from Queue import Queue  # Python 2 compatibility

@plugin
class NeovimWSPlugin(object):
    def __init__(self, nvim):
        self.nvim = nvim
        self.client_id = None
        self.ws_thread = None
        self.ws_queue = Queue()
        self.should_run = True

    def ws_thread_func(self, ws_url):
        def on_message(ws, message):
            # Check if the client_id is not set, indicating this is the first message
            if self.client_id is None:
                # The first message is expected to be the client ID
                self.client_id = message
                self.nvim.async_call(lambda: self.nvim.out_write(f"Connected with Client ID: {self.client_id}\n"))
            else:
                # All subsequent messages are JSON updates from other clients
                try:
                    message_data = json.loads(message)
                    # Log or process the received update
                    self.nvim.async_call(lambda: self.nvim.out_write(f"Received update: {json.dumps(message_data, indent=2)}\n"))
                    # Here you can add logic to handle the updates, such as applying changes to the buffer
                except json.JSONDecodeError:
                    # Log the error if the message cannot be parsed as JSON
                    self.nvim.async_call(lambda: self.nvim.err_write("Received malformed JSON update.\n"))

        def on_error(ws, error):
            self.nvim.async_call(lambda: self.nvim.err_write(f"WebSocket error: {error}\n"))

        def on_close(ws):
            self.should_run = False
            self.nvim.async_call(lambda: self.nvim.out_write("WebSocket connection closed\n"))

        ws = websocket.WebSocketApp(ws_url, on_message=on_message, on_error=on_error, on_close=on_close)
        while self.should_run:
            ws.run_forever()
            while not self.ws_queue.empty():
                data = self.ws_queue.get()
                ws.send(data)

    @command('WSConnect', nargs='1', sync=True)
    def connect_to_websocket(self, args):
        if self.ws_thread is not None and self.should_run:
            self.nvim.out_write("WebSocket connection is already established. Use :WSClose first if you want to reconnect.\n")
            return

        ws_url = args[0]
        self.should_run = True
        self.ws_thread = threading.Thread(target=self.ws_thread_func, args=(ws_url,))
        self.ws_thread.daemon = True
        self.ws_thread.start()
        self.nvim.out_write(f"Connecting to {ws_url}...\n")

    def prepare_data(self):
        buffer = self.nvim.current.buffer
        lines = "\n".join(buffer[:])
        data = {
            "file_name": buffer.name,
            "client_id": self.client_id,
            "text": lines
        }
        return json.dumps(data)

    @autocmd('TextChanged,TextChangedI', pattern='*', sync=False)
    def on_text_changed(self):
        if self.client_id and not self.ws_queue.empty():
            data = self.prepare_data()
            self.ws_queue.put(data)

    @command('WSSend', nargs='*', sync=True)
    def send_message(self, args):
        if self.client_id:  # Check if we have a client_id before sending
            data = self.prepare_data()
            self.ws_queue.put(data)
            self.nvim.out_write("Message queued for sending\n")
        else:
            self.nvim.out_write("Cannot send message, no client_id established.\n")

    @command('WSClose', nargs='0', sync=True)
    def close_connection(self, args):
        self.should_run = False
        if self.ws_thread and self.ws_thread.is_alive():
            self.ws_thread.join()
        self.ws_thread = None
        self.client_id = None  # Reset client_id on connection close
        self.nvim.out_write("WebSocket connection has been closed.\n")

