return {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function ()
        require("obsidian").setup(
            {
                workspaces = {
                    {
                        name = "bag",
                        path = "~/Developer/bag_of_holding",
                    },
                },
                log_level = vim.log.levels.INFO,

                daily_notes = {
                    folder = "Logs",
                    template = "daily_template"
                },

                completion = {
                    nvim_cmp = true,
                    min_chars = 2,
                },

                mappings = {
                    ["gd"] = {
                        action = function()
                            return require("obsidian").util.gf_passthrough()
                        end,
                        opts = { noremap = false, expr = true, buffer = true },
                    },
                    ["<leader>ch"] = {
                        action = function()
                            return require("obsidian").util.toggle_checkbox()
                        end,
                        opts = { buffer = true },
                    },
                },

                -- Where to put new notes. Valid options are
                --  * "current_dir" - put new notes in same directory as the current buffer.
                --  * "notes_subdir" - put new notes in the default notes subdirectory.
                new_notes_location = "current_dir",

                ---@param opts {path: string, label: string, id: string|?}
                ---@return string
                wiki_link_func = function(opts)
                    if opts.id == nil then
                        return string.format("[[%s]]", opts.label)
                    elseif opts.label ~= opts.id then
                        return string.format("[[%s|%s]]", opts.id, opts.label)
                    else
                        return string.format("[[%s]]", opts.id)
                    end
                end,

                note_id_func = function(title)
                    -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
                    -- In this case a note with the title 'My new note' will be given an ID that looks
                    -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
                    local suffix = ""
                    if title ~= nil then
                        -- If title is given, transform it into valid file name.
                        suffix = title:gsub(" ", "_"):gsub("[^A-Za-z0-9_]", ""):lower()
                    else
                        -- If title is nil, just add 4 random uppercase letters to the suffix.
                        for _ = 1, 4 do
                            suffix = suffix .. string.char(math.random(65, 90))
                        end
                    end
                    return tostring(suffix)
                end,

                -- Optional, customize how markdown links are formatted.
                ---@param opts {path: string, label: string, id: string|?}
                ---@return string
                markdown_link_func = function(opts)
                    return string.format("[%s](%s)", opts.label, opts.path)
                end,

                preferred_link_style = "wiki",

                ---@return string
                image_name_func = function()
                    return string.format("%s-", os.time())
                end,

                disable_frontmatter = false,

                -- Optional, alternatively you can customize the frontmatter data.
                ---@return table
                note_frontmatter_func = function(note)
                    -- Add the title of the note as an alias.
                    if note.title then
                        note:add_alias(note.title)
                    end

                    local out = { id = note.id, aliases = note.aliases, tags = note.tags }

                    -- `note.metadata` contains any manually added fields in the frontmatter.
                    -- So here we just make sure those fields are kept in the frontmatter.
                    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                        for k, v in pairs(note.metadata) do
                            out[k] = v
                        end
                    end

                    return out
                end,

                templates = {
                    subdir = "Templates",
                    date_format = "%Y-%m-%d",
                    time_format = "%H:%M",
                    substitutions = {},
                },

                follow_url_func = function(url)
                    vim.fn.jobstart({"open", url})
                end,

                use_advanced_uri = false,

                picker = {
                    -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
                    name = "telescope.nvim",
                    -- Optional, configure key mappings for the picker. These are the defaults.
                    -- Not all pickers support all mappings.
                    mappings = {
                        new = "<C-x>",
                        -- Insert a link to the selected note.
                        insert_link = "<C-l>",
                    },
                },

                -- Optional, sort search results by "path", "modified", "accessed", or "created".
                -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
                -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
                sort_by = "modified",
                sort_reversed = true,

                -- Optional, determines how certain commands open notes. The valid options are:
                -- 1. "current" (the default) - to always open in the current window
                -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
                -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
                open_notes_in = "vsplit",

                ui = {
                    enable = true,  -- set to false to disable all additional syntax features
                    update_debounce = 200,  -- update delay after a text change (in milliseconds)
                    checkboxes = {
                        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
                        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                        ["x"] = { char = "", hl_group = "ObsidianDone" },
                        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                    },
                    -- Use bullet marks for non-checkbox lists.
                    bullets = { char = "•", hl_group = "ObsidianBullet" },
                    external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                    -- Replace the above with this if you don't have a patched font:
                    -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                    reference_text = { hl_group = "ObsidianRefText" },
                    highlight_text = { hl_group = "ObsidianHighlightText" },
                    tags = { hl_group = "ObsidianTag" },
                    hl_groups = {
                        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
                        ObsidianTodo = { bold = true, fg = "#f78c6c" },
                        ObsidianDone = { bold = true, fg = "#89ddff" },
                        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
                        ObsidianTilde = { bold = true, fg = "#ff5370" },
                        ObsidianBullet = { bold = true, fg = "#89ddff" },
                        ObsidianRefText = { underline = true, fg = "#c792ea" },
                        ObsidianExtLinkIcon = { fg = "#c792ea" },
                        ObsidianTag = { italic = true, fg = "#89ddff" },
                        ObsidianHighlightText = { bg = "#75662e" },
                    },
                },
                attachments = {
                    img_folder = "Attachments",  -- This is the default
                    ---@param client obsidian.Client
                    ---@param path obsidian.Path the absolute path to the image file
                    ---@return string
                    img_text_func = function(client, path)
                        local link_path
                        local vault_relative_path = client:vault_relative_path(path)
                        if vault_relative_path ~= nil then
                            -- Use relative path if the image is saved in the vault dir.
                            link_path = vault_relative_path
                        else
                            -- Otherwise use the absolute path.
                            link_path = tostring(path)
                        end
                        local display_name = vim.fs.basename(link_path)
                        return string.format("![%s](%s)", display_name, link_path)
                    end,
                },
            }
        )
    end
}
