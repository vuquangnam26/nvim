return {
    "nvimtools/none-ls.nvim", -- Plugin cho phép dùng các formatter/diagnostic/code action tool như là LSP
    config = function()
        local null_ls = require("null-ls") -- Load thư viện none-ls

        null_ls.setup({
            sources = {
                -- Lua formatter
                null_ls.builtins.formatting.stylua,

                -- Prettier cho JS/TS/HTML/CSS/JSON v.v.
                null_ls.builtins.formatting.prettier,

                -- Python formatter: black
                null_ls.builtins.formatting.black,

                -- Python import sorter: isort
                null_ls.builtins.formatting.isort,

                -- Go formatter: gofumpt (nâng cấp từ gofmt, dùng trong Go project)
                null_ls.builtins.formatting.gofumpt,

                -- Gợi ý code cho Go (thêm method implement còn thiếu)
                null_ls.builtins.code_actions.impl,

                -- Các dòng dưới đây là để check lỗi Python (comment vì chưa dùng):
                -- null_ls.builtins.diagnostics.mypy, -- type checking cho Python
                -- null_ls.builtins.diagnostics.ruff, -- lint nhanh thay flake8 + pycodestyle + isort
            },
        })

        -- Map phím <leader>gf để format file đang mở bằng formatter phù hợp
        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
}
