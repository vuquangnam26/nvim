return {
	"xiyaowong/transparent.nvim", -- Plugin giúp giao diện Neovim trong suốt (transparent)
	config = function()
		require("transparent").setup({
			enable = true, -- Bật chế độ trong suốt

			-- Các nhóm highlight bổ sung cần được làm trong suốt
			extra_groups = {
				"Normal",             -- Giao diện chính
				"NormalNC",           -- Cửa sổ không được focus
				"TelescopeBorder",    -- Viền khung tìm kiếm của Telescope
				-- "NvimTreeNormal",  -- (Tùy chọn) giao diện NvimTree
				"LualineNormal",      -- Thanh trạng thái Lualine
				"FzfLuaBorder",       -- Viền FZF
				"FzfLuaNormal",       -- Nền khung FZF
				"FzfLuaTitle",        -- Tiêu đề của khung FZF
				"FzfLuaPreviewBorder",-- Viền preview FZF
				"FzfLuaPreviewNormal",-- Nền preview FZF
				"FzfLuaPreviewTitle", -- Tiêu đề preview FZF
			},
		})

		-- Xóa prefix liên quan đến 'lualine' để làm trong suốt hoàn toàn các thành phần lualine
		require("transparent").clear_prefix("lualine")

		-- Một số thiết lập highlight thủ công cho các thành phần quan trọng (do máy mỗi người khác nhau)
		vim.cmd("highlight Normal guibg=NONE")         -- Giao diện chính
		vim.cmd("highlight Lualine guibg=NONE")        -- Lualine nền
		vim.cmd("highlight Lualine guifg=NONE")        -- Lualine chữ
		vim.cmd("highlight NormalNC guibg=NONE")       -- Cửa sổ không active
		vim.cmd("highlight CursorLine guibg=NONE")     -- Dòng hiện tại
	end,
}
