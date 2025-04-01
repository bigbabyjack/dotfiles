return {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {},
    config = function()
        require('copilot').setup {
            panel = {
                enabled = false,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = false,
                keymap = {
                    accept = '<C-l>',
                    accept_word = '<C-\\>',
                },
            },
            copilot_model = 'gpt-4o-copilot',
            workspace_folders = {},
        }

        local copilot = require 'copilot'
        local suggestion = require 'copilot.suggestion'
        local keymaps = {
            {
                'i',
                '<C-\\>',
                function()
                    suggestion.accept_word()
                end,
                { desc = 'Accept next Copilot suggestion word' },
            },
            {
                'n',
                '<leader>cpt',
                function()
                    suggestion.toggle_auto_trigger()
                end,
                { desc = '[c]o-[p]ilot [t]oggle' },
            },
            {
                'n',
                '<leader>cpd',
                function()
                    copilot.setup(opts)
                end,
                { desc = '[c]o-[p]ilot [d]isable' },
            },
            {
                'n',
                '<leader>cpe',
                function()
                    copilot.enable()
                end,
                { desc = '[c]o-[p]ilot [e]nable' },
            },
        }

        for _, keymap in ipairs(keymaps) do
            vim.keymap.set(unpack(keymap))
        end
    end,
}
