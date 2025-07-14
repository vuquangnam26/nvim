return {
	{
		"nvim-neotest/neotest", -- Plugin chính: framework test cho Neovim
		dependencies = {
			"nvim-neotest/nvim-nio", -- Cung cấp async event loop cần thiết cho Neotest
			"nvim-lua/plenary.nvim", -- Thư viện tiện ích Lua cho nhiều plugin Neovim
			"antoinemadec/FixCursorHold.nvim", -- Sửa lỗi chờ trong Vim (dùng cho popup/log test)
			"nvim-treesitter/nvim-treesitter", -- Hỗ trợ phân tích cấu trúc code để xác định test

			-- Go test adapter
			{
				"fredrikaverpil/neotest-golang",
				version = "*",
				dependencies = { "leoluz/nvim-dap-go" }, -- DAP cho Go nếu cần debug
			},

			-- Dart/Flutter adapter
			"sidlatau/neotest-dart",

			-- Zig adapter
			"lawrence-laz/neotest-zig",

			-- Java adapter
			{
				"rcasia/neotest-java",
				ft = "java", -- chỉ load khi mở file .java
				dependencies = {
					"mfussenegger/nvim-jdtls", -- JDT Language Server cho Java
					"mfussenegger/nvim-dap", -- Debug Adapter Protocol
					"rcarriga/nvim-dap-ui", -- Giao diện hiển thị debug UI
					"theHamsta/nvim-dap-virtual-text", -- Hiển thị giá trị biến ngay trong code
				},
			},
		},

		config = function()
			-- Thiết lập neotest với các adapter tương ứng cho từng ngôn ngữ
			require("neotest").setup({
				adapters = {
					require("neotest-golang")({ recursive_run = true }), -- Hỗ trợ chạy toàn bộ test trong thư mục
					["neotest-java"] = {}, -- Java adapter
					require("neotest-dart")({
						command = "flutter", -- hoặc "fvm flutter" nếu dùng FVM
						use_lsp = true, -- dùng LSP để đọc cấu trúc test
						custom_test_method_names = {}, -- tùy chỉnh tên hàm test (nếu dùng @isTest)
					}),
					require("neotest-zig")({
						dap = {
							adapter = "lldb", -- debugger cho Zig
						},
					}),
				},
			})

			-- 🧪 Keymap hỗ trợ thao tác với test
			vim.keymap.set("n", "<Leader>tr", ':lua require("neotest").run.run()<CR>', {}) -- chạy test tại vị trí con trỏ
			vim.keymap.set("n", "<Leader>tb", ':lua require("neotest").run.run({strategy = "dap"})<CR>', {}) -- debug test
			vim.keymap.set("n", "<Leader>ts", ':lua require("neotest").run.stop()<CR>', {}) -- dừng test đang chạy
			vim.keymap.set("n", "<Leader>to", ':lua require("neotest").output.open()<CR>', {}) -- mở output của test
			vim.keymap.set("n", "<Leader>tO", ':lua require("neotest").output.open({ enter = true })<CR>', {}) -- mở và nhảy tới output
			vim.keymap.set("n", "<Leader>tv", ':lua require("neotest").summary.toggle()<CR>', {}) -- toggle bảng tổng quan test
			vim.keymap.set("n", "<Leader>tp", ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', {}) -- chạy toàn bộ test trong file

			-- ⚠️ Hàm thủ công chỉ dùng cho Go Suite (theo kiểu suite/method), không thuộc neotest
			-- Bạn có thể xóa sau nếu không dùng Go kiểu này

			-- Lấy tên Suite trong file test Go (ví dụ: `type MySuite struct`)
			local function get_suite_name(file_path)
				local file_content = vim.fn.readfile(file_path)
				for _, line in ipairs(file_content) do
					local suite_match = line:match("^type%s+([%w_]+)Suite%s+struct")
					if suite_match then
						return suite_match
					end
				end
				return nil
			end

			-- ⚙️ Keymap tự tạo để chạy test Go theo cú pháp `go test -run Suite/TestFunc`
			vim.keymap.set("n", "<Leader>tt", function()
				local file_path = vim.fn.expand("%:p")
				local package = vim.fn.fnamemodify(file_path, ":h"):gsub("^%./", "")
				local test_name = vim.fn.input("Enter test method name (e.g., TestXYZ): ")

				if not test_name or test_name == "" then
					vim.notify("Test name cannot be empty.", vim.log.levels.ERROR)
					return
				end

				local suite_name = get_suite_name(file_path)
				if not suite_name then
					vim.notify("Cannot detect suite name in file.", vim.log.levels.ERROR)
					return
				end

				-- chạy test theo dạng: go test -run SuiteNameSuite/TestName
				local test_pattern = suite_name .. "Suite/" .. test_name
				vim.cmd("!go test -run " .. test_pattern .. " -v " .. package)
			end, { desc = "Run specific test at cursor" })
		end,
	},
}
