return {
	-- Plugin chính để debug: nvim-dap
	"mfussenegger/nvim-dap",

	-- Các plugin phụ thuộc hỗ trợ UI và Go
	dependencies = {
		"rcarriga/nvim-dap-ui",        -- Giao diện trực quan (UI) cho debug
		"nvim-neotest/nvim-nio",       -- Bắt buộc để dap-ui hoạt động (async IO)
		"leoluz/nvim-dap-go",          -- Hỗ trợ cấu hình debug cho Go (dùng delve)
	},

	-- Cấu hình khi plugin được load
	config = function()
		local dap = require("dap")     -- Module debug chính
		local dapui = require("dapui") -- Giao diện UI debug

		require("dap-go").setup()      -- Cài đặt debugger cho Go (dùng delve)
		dapui.setup()                  -- Cài đặt UI debug

		-- Khi bắt đầu attach vào process → mở UI
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end

		-- Khi bắt đầu launch debugger mới → mở UI
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end

		-- Khi kết thúc debug (bị kill, fail, etc) → đóng UI
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end

		-- Khi debugger thoát thành công → đóng UI
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- 🔁 Phím tắt tiện lợi:
		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {}) -- toggle breakpoint
		vim.keymap.set("n", "<Leader>dc", dap.continue, {})          -- tiếp tục chạy debug
	end,
}

-- 🔧 Ghi chú:
-- Bạn cần cài đặt trình debug (debug adapter) tương ứng với ngôn ngữ
-- Ví dụ Go: cài delve bằng lệnh sau (macOS):
-- brew install delve

-- Xem thêm cách cài adapter: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
