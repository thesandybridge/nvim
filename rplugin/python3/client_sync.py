import json
import time
import threading
from pynvim import attach, plugin, command, autocmd
import websocket
from queue import Queue, Empty

@plugin
class NeovimWSPlugin(object):
    def __init__(self, nvim):
        self.nvim = nvim
        self.client_id = None
        self.object_type = None
        self.ws = None
        self.ws_thread = None
        self.ws_queue = Queue()
        self.queue_event = threading.Event()
        self.should_run = threading.Event()
        self.should_run.set()
        self.is_connected = False
        self.client_state = {}

    def ws_thread_func(self, ws_url):
        def on_open(ws):
            self.is_connected = True
            self.nvim.async_call(lambda: self.nvim.out_write("WebSocket connection opened\n"))

        def on_message(ws, message):
            if self.client_id is None:
                self.client_id = message
                self.nvim.async_call(lambda: self.nvim.out_write(f"Connected with Client ID: {self.client_id}\n"))
            else:
                try:
                    message_data = json.loads(message)
                    self.nvim.async_call(lambda: self.nvim.out_write(f"Received update: {json.dumps(message_data, indent=2)}\n"))
                except json.JSONDecodeError:
                    self.nvim.async_call(lambda: self.nvim.err_write("Received malformed JSON update.\n"))

        def on_error(ws, error):
            self.nvim.async_call(lambda: self.nvim.err_write(f"WebSocket error: {error}\n"))

        def on_close(ws, close_status_code, close_msg):
            self.is_connected = False
            self.should_run.clear()
            self.nvim.async_call(lambda: self.nvim.out_write("WebSocket connection closed\n"))

        self.ws = websocket.WebSocketApp(ws_url,
                                     on_message=on_message,
                                     on_error=on_error,
                                     on_close=on_close,
                                     on_open=on_open)

        threading.Thread(target=lambda: self.ws.run_forever(), daemon=True).start()
        self.nvim.async_call(lambda: self.nvim.out_write(f"Attempting to connect to WebSocket at {ws_url}\n"))

    def process_queue(self):
        """Process the queue in 10-second intervals."""
        while self.should_run.is_set():
            start_time = time.time()
            messages = []

            while time.time() - start_time < 10:
                try:
                    message = self.ws_queue.get(timeout=10 - (time.time() - start_time))
                    messages.append(message)
                    self.ws_queue.task_done()
                except Empty:
                    break

            if messages:
                self.send_data(messages)

    def send_data(self, messages):
        self.nvim.async_call(lambda: self.nvim.out_write(f"Sending data to server. {messages}\n"))
        """
        Sends messages over the WebSocket connection. Each message in the list is
        prepared and sent individually.

        Parameters:
        - messages (list): A list of messages to be sent. Each message should be
                           a dictionary that `prepare_data` can process.
        """
        for message in messages:
            if messages and self.ws and self.ws.sock and self.ws.sock.connected:
                try:
                    self.ws.send(message)
                    self.nvim.async_call(lambda: self.nvim.out_write("Successfully sent data to the server.\n"))
                except Exception as e:
                    error_message = f"Failed to send data to the server: {e}"
                    self.nvim.async_call(lambda: self.nvim.err_write(error_message + "\n"))

    @command('WSConnect', nargs='1', sync=True)
    def connect_to_websocket(self, args):
        if self.ws_thread is not None and self.ws_thread.is_alive():
            self.nvim.out_write("WebSocket connection is already established. Use :WSClose first if you want to reconnect.\n")
            return

        ws_url = args[0]
        self.should_run.set()
        try:
            self.ws_thread = threading.Thread(target=self.ws_thread_func, args=(ws_url,))
            self.ws_thread.daemon = True
            self.ws_thread.start()

            if not hasattr(self, 'process_thread') or not self.process_thread.is_alive():
                self.process_thread = threading.Thread(target=self.process_queue, daemon=True)
                self.process_thread.start()

            self.nvim.out_write(f"Connecting to {ws_url}...\n")
        except Exception as e:
            self.nvim.err_write(f"Error starting WebSocket connection thread: {e}\n")

    def prepare_data(self, text, cursor_pos, message_type):
        if not self.client_id:
            self.nvim.async_call(lambda: self.nvim.err_write("Client ID not set. Cannot prepare message.\n"))
            return None

        if message_type == "CursorPosition":
            data = {
                "type": "CursorPosition",
                "client_id": self.client_id,
                "position": {
                    "line": cursor_pos[0],
                    "column": cursor_pos[1]
                }
            }
        elif message_type == "FileEdit":
            data = {
                "type": "FileEdit",
                "file_name": self.nvim.current.buffer.name,
                "client_id": self.client_id,
                "position": {
                    "line": cursor_pos[0],
                    "column": cursor_pos[1]
                },
                "text": text,
            }
        else:
            self.nvim.async_call(lambda: self.nvim.err_write(f"Unsupported message type: {message_type}\n"))
            return None

        return json.dumps(data)


    @autocmd('CursorMoved,CursorMovedI', pattern='*', sync=False)
    def on_cursor_moved(self):
        if not self.is_connected:
            return
        if self.client_id:
            cursor_pos = self.nvim.current.window.cursor
            data = self.prepare_data("", cursor_pos, "CursorPosition")
            if data:
                self.ws_queue.put(data)
                self.queue_event.set()


    @autocmd('BufWritePost', pattern='*', sync=False)
    def on_buf_write_post(self):
        if not self.is_connected:
            return
        if self.client_id:
            cursor_pos = self.nvim.current.window.cursor
            buffer = self.nvim.current.buffer
            lines = "\n".join(buffer[:])
            data = self.prepare_data(lines, cursor_pos, "FileEdit")
            if data:
                self.ws_queue.put(data)
                self.queue_event.set()


    @command('WSSend', nargs='*', sync=True)
    def send_message(self, args):
        if not self.is_connected:
            self.nvim.out_write("WebSocket connection is not established. Cannot close.\n")
            return
        if self.client_id:
            cursor_pos = self.nvim.current.window.cursor
            data = self.prepare_data(" ".join(args), cursor_pos, "CustomMessage")
            self.ws_queue.put(data)
            self.queue_event.set()
        else:
            self.nvim.out_write("Cannot send message, no client_id established.\n")

    @command('WSClose', nargs='0', sync=True)
    def close_connection(self, args):
        if not self.is_connected:
            return

        if self.ws:
            try:
                self.ws.close()
                self.nvim.out_write("WebSocket connection has been closed gracefully.\n")
            except Exception as e:
                self.nvim.err_write(f"Error closing WebSocket connection: {e}\n")
        else:
            self.nvim.out_write("No active WebSocket connection to close.\n")

        self.should_run.clear()
        self.queue_event.set()
        if self.ws_thread and self.ws_thread.is_alive():
            self.ws_thread.join()

        self.ws_thread = None
        self.client_id = None

    @autocmd('VimLeave', pattern='*', sync=True)
    def on_vim_leave(self):
        if not self.is_connected:
            return
        self.close_connection(None)


