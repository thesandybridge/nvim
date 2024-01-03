require("obsidian").setup({
    workspaces = {
        {
            name = "personal",
            path = "~/Dev/Seabridge",
        },
        {
            name = "work",
            path = "~/vaults/work",
        },
    },
    daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "daily_notes",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%m-%d-%Y",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "daily.md"
    },
    templates = {
        subdir = "templates",
        date_format = "%m-%d-%Y",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
    },
    completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,

        -- Trigger completion at 2 chars.
        min_chars = 2,

        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "current_dir",

        -- Control how wiki links are completed with these (mutually exclusive) options:
        --
        -- 1. Whether to add the note ID during completion.
        -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        -- Mutually exclusive with 'prepend_note_path' and 'use_path_only'.
        prepend_note_id = true,
        -- 2. Whether to add the note path during completion.
        -- E.g. "[[Foo" completes to "[[notes/foo|Foo]]" assuming "notes/foo.md" is the path of the note.
        -- Mutually exclusive with 'prepend_note_id' and 'use_path_only'.
        prepend_note_path = false,
        -- 3. Whether to only use paths during completion.
        -- E.g. "[[Foo" completes to "[[notes/foo]]" assuming "notes/foo.md" is the path of the note.
        -- Mutually exclusive with 'prepend_note_id' and 'prepend_note_path'.
        use_path_only = false,
    },
})
