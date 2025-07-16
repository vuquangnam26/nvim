return {
	"stevearc/oil.nvim", -- Plugin quản lý file như Netrw nhưng hiện đại hơn

	dependencies = {
		-- Dùng để hiển thị biểu tượng (icon) trong giao diện Oil
		{
			"echasnovski/mini.icons",
			opts = {
				style = "glyphs", -- Dùng biểu tượng dạng glyph (như nerd font)
			},
		},
	},

	lazy = false, -- Không lazy-load để đảm bảo FileType autocmd hoạt động chính xác

	config = function()
		require("oil").setup({
			-- Cấu hình cửa sổ popup (float)
			float = {
				padding = 2, -- Khoảng cách đệm xung quanh popup
				max_width = 90,
				max_height = 0, -- 0 = không giới hạn
				-- border = "rounded", -- Có thể dùng để bo góc popup
				win_options = {
					winblend = 0, -- Không làm mờ nền
				},
			},

			-- Tự động gán phím khi mở oil buffer
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "oil",
				callback = function()
					local oil_actions = require("oil.actions")

					local map = function(lhs, rhs, opts)
						opts = vim.tbl_extend("force", { buffer = true, noremap = true, silent = true }, opts or {})
						vim.keymap.set("n", lhs, rhs, opts)
					end

					-- Các phím tắt trong giao diện Oil
					map("g?", oil_actions.show_help.callback) -- Hiện trợ giúp
					map("<CR>", oil_actions.select.callback) -- Mở file hoặc folder
					map("<C-t>", function() oil_actions.select.callback({ tab = true }) end) -- Mở trong tab mới
					map("<C-p>", function() oil_actions.preview.callback({ vertical = true, split = "rightbelow" }) end) -- Xem trước file
					map("<C-c>", oil_actions.close.callback) -- Đóng oil
					map("R", oil_actions.refresh.callback) -- Làm mới lại oil
					map("-", oil_actions.parent.callback) -- Đi lên thư mục cha
					map("_", oil_actions.open_cwd.callback) -- Mở thư mục làm working dir
					map("`", oil_actions.cd.callback) -- Đặt current dir
					map("~", function() oil_actions.cd.callback({ scope = "tab" }) end) -- Đặt current dir cho tab
					map("gs", oil_actions.change_sort.callback) -- Đổi kiểu sắp xếp
					map("gx", oil_actions.open_external.callback) -- Mở file bằng app hệ thống
					map("H", oil_actions.toggle_hidden.callback) -- Hiện/ẩn file ẩn
					map("g\\", oil_actions.toggle_trash.callback) -- Toggle trash
				end,
			}),

			use_default_keymaps = false, -- Không dùng phím tắt mặc định
		})

		-- Phím tắt toàn cục ngoài giao diện Oil
		vim.keymap.set("n", "<leader>vv", require("oil").open, { desc = "Open parent directory" }) -- Mở thư mục hiện tại
		vim.keymap.set("n", "<leader>vf", require("oil").open_float, { desc = "Oil float" }) -- Mở oil dạng popup

		-- Hiện thông tin chi tiết file đang chọn
		vim.keymap.set("n", "<leader>vi", function()
			local oil = require("oil")
			local entry = oil.get_cursor_entry() -- Lấy dòng đang chọn trong oil
			local dir = oil.get_current_dir() -- Lấy thư mục hiện tại

			if entry and dir then
				local full_path = vim.fn.fnamemodify(dir .. entry.name, ":p")
				local stat = vim.loop.fs_stat(full_path) -- Lấy thông tin file

				if stat then
					-- Hiện thông tin file qua notify
					vim.notify(
						vim.inspect({
							name = entry.name,
							type = entry.type,
							full_path = full_path,
							size = stat.size,
							mode = stat.mode,
							mtime = os.date("%c", stat.mtime.sec),
						}),
						vim.log.levels.INFO,
						{ title = "Oil Entry Info" }
					)
				else
					vim.notify("Failed to stat file: " .. full_path, vim.log.levels.WARN)
				end
			else
				vim.notify("No entry under cursor", vim.log.levels.WARN)
			end
		end, { desc = "Show full file info from Oil" })
	end,
}
