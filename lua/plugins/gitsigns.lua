return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup{
            signcolumn = true,   -- Показывать значки изменений в колонке
            numhl      = true,   -- Подсвечивать номера строк с изменениями
            linehl     = false,  -- Подсветка изменённых строк (можно включить)
            word_diff  = false,  -- Подсветка изменённых слов (можно включить)
        }
        vim.keymap.set("n", "<leader>ga", function()
          require("gitsigns").stage_hunk()
        end, { desc = "Применить текущее изменение" })

        vim.keymap.set("n", "<leader>gA", function()
          require("gitsigns").stage_buffer()
        end, { desc = "Применить все изменения в файле" })

        vim.keymap.set("n", "<leader>gu", function()
          require("gitsigns").undo_stage_hunk()
        end, { desc = "Отменить `git add` для текущего изменения" })

        vim.keymap.set("n", "<leader>gr", function()
          require("gitsigns").reset_hunk()
        end, { desc = "Откатить текущее изменение" })

        vim.keymap.set("n", "<leader>gR", function()
          require("gitsigns").reset_buffer()
        end, { desc = "Откатить все изменения в файле" })

        vim.api.nvim_create_autocmd("InsertLeave", {
          callback = function()
            require("gitsigns").stage_hunk()
          end
        })
    end
}
