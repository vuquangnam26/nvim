return {
	"karb94/neoscroll.nvim", -- Plugin giúp cuộn mượt trong Neovim
	opts = {},

	config = function()
		local neoscroll = require("neoscroll")

		-- Thiết lập cấu hình chính cho neoscroll
		neoscroll.setup({
			hide_cursor = false, -- Không ẩn con trỏ khi đang cuộn
			stop_eof = true, -- Dừng cuộn khi đến cuối file (EOF)
			respect_scrolloff = false, -- Không dừng ở lề scrolloff
			cursor_scrolls_alone = true, -- Con trỏ vẫn cuộn dù cửa sổ không thể cuộn nữa
			duration_multiplier = 0.8, -- Hệ số tốc độ cuộn toàn cục
			easing = "linear", -- Hàm easing mặc định (mượt linearly)
			pre_hook = nil, -- Hàm gọi trước khi cuộn bắt đầu
			post_hook = nil, -- Hàm gọi sau khi cuộn kết thúc
			performance_mode = false, -- Bật/tắt chế độ hiệu năng cao
			ignored_events = { -- Bỏ qua các sự kiện này khi đang cuộn
				"WinScrolled",
				"CursorMoved",
			},
		})

		-- Thiết lập các phím tắt tùy chỉnh cho hành vi cuộn mượt
		local keymap = {
			-- Cuộn lên nửa trang
			["<C-e>"] = function()
				neoscroll.ctrl_u({ duration = 300 })
			end,

			-- Cuộn xuống nửa trang
			["<C-d>"] = function()
				neoscroll.ctrl_d({ duration = 300 })
			end,

			-- Cuộn lên một trang
			["<C-b>"] = function()
				neoscroll.ctrl_b({ duration = 450 })
			end,

			-- Cuộn xuống một trang
			["<C-f>"] = function()
				neoscroll.ctrl_f({ duration = 450 })
			end,

			-- Cuộn lên 1 dòng (nhẹ)
			["<C-y>"] = function()
				neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 })
			end,

			-- Cuộn xuống 1 dòng (nhẹ)
			["<C-u>"] = function()
				neoscroll.scroll(0.1, { move_cursor = false, duration = 100 })
			end,

			-- Đưa dòng hiện tại lên đỉnh cửa sổ
			["zt"] = function()
				neoscroll.zt({ half_win_duration = 300 })
			end,

			-- Đưa dòng hiện tại vào giữa cửa sổ
			["zz"] = function()
				neoscroll.zz({ half_win_duration = 300 })
			end,

			-- Đưa dòng hiện tại xuống cuối cửa sổ
			["zb"] = function()
				neoscroll.zb({ half_win_duration = 300 })
			end,
		}

		-- Áp dụng các keymap ở nhiều chế độ (normal, visual, select)
		local modes = { "n", "v", "x" }
		for key, func in pairs(keymap) do
			vim.keymap.set(modes, key, func)
		end
	end,
}
