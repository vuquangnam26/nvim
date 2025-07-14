return {
    "ibhagwan/fzf-lua", -- Plugin chính: fzf-lua

    -- Phụ thuộc: để hiển thị icon đẹp (file, folder, v.v.)
    dependencies = { "nvim-tree/nvim-web-devicons" },

    -- Nếu bạn dùng mini.nvim thì có thể dùng: echasnovski/mini.icons
    -- dependencies = { "echasnovski/mini.icons" },

    -- opts có thể để trống nếu bạn config toàn bộ bằng tay
    opts = {},

    config = function()
        local fzf = require("fzf-lua")

        -- Cấu hình chính cho plugin
        fzf.setup({
            -- Cấu hình cửa sổ hiện ra
            winopts = {
                height = 0.85,      -- chiều cao: 85%
                width = 0.90,       -- chiều rộng: 90%
                preview = {
                    layout = "horizontal", -- xem trước theo chiều ngang
                },
            },

            -- Màu sắc tương thích terminal
            fzf_colors = {
                true,               -- dùng màu mặc định
                bg = "-1",          -- nền trong suốt
                gutter = "-1",      -- không có viền bên trái
            },

            -- Gán phím tắt khi đang trong giao diện FZF
            keymap = {
                fzf = {
                    ["ctrl-q"] = "select-all+accept", -- ctrl-q: chọn tất cả + chấp nhận
                },
            },
        })

        -- 🎯 Các keymap tiện lợi để tìm kiếm:
        vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find Files" })            -- Tìm tất cả file
        vim.keymap.set("n", "<leader>pf", fzf.git_files, { desc = "Find Git Files" })    -- Tìm file đã commit (git)
        vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })         -- Tìm kiếm theo nội dung file

        -- Tìm kiếm nội dung trong cả file ẩn (trừ `.git`)
        vim.keymap.set("n", "<leader>fG", function()
            require("fzf-lua").live_grep({
                rg_opts = "--hidden --glob '!.git/*' --column --line-number --no-heading --color=always -e",
            })
        end, { desc = "Live Grep includes hidden files" })

        vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })             -- Chuyển đổi giữa các buffer
        vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help Tags" })         -- Tìm kiếm trong tài liệu `:help`

        -- Tìm chuỗi nhập từ người dùng trong tất cả file
        vim.keymap.set("n", "<leader>fs", function()
            fzf.grep({ search = vim.fn.input("Grep For > ") })
        end, { desc = "FZF grep with input" })
    end,
}
