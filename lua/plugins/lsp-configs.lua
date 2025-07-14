return {
	-- 1️⃣ Plugin mason: để quản lý và cài đặt các LSP server
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- 2️⃣ Tích hợp mason với lspconfig, giúp tự động cài các server đã liệt kê
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true, -- Tự động cài khi thiếu
			-- Cần cài thủ công nếu không có trong danh sách này
			ensure_installed = { "lua_ls", "zls", "gopls", "ts_ls" },
		},
	},

	-- 3️⃣ Cấu hình cụ thể các ngôn ngữ sử dụng LSP
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- 🧠 Lua
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" }, -- Tránh cảnh báo về "vim"
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})

			-- 🧠 TypeScript
			lspconfig.ts_ls.setup({ capabilities = capabilities })

			-- 🧠 JavaScript - ESLint
			lspconfig.eslint.setup({ capabilities = capabilities })

			-- 🧠 Zig
			lspconfig.zls.setup({ capabilities = capabilities })

			-- 🧠 YAML
			lspconfig.yamlls.setup({ capabilities = capabilities })

			-- 🧠 TailwindCSS
			lspconfig.tailwindcss.setup({ capabilities = capabilities })

			-- 🧠 Go
			lspconfig.gopls.setup({ capabilities = capabilities })

			-- 🧠 Java (đang bị comment, có thể mở nếu cần)
			-- lspconfig.jdtls.setup({...})

			-- 🧠 Nix
			lspconfig.rnix.setup({ capabilities = capabilities })

			-- 🧠 Protocol Buffer (.proto)
			lspconfig.buf_ls.setup({ capabilities = capabilities })
			-- Hoặc dùng tên khác (buf_language_server) cho filetype "proto"
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "proto",
				callback = function()
					lspconfig.buf_language_server.setup({
						capabilities = capabilities,
					})
				end,
			})

			-- 🧠 Docker Compose
			lspconfig.docker_compose_language_service.setup({ capabilities = capabilities })

			-- 🧠 Svelte
			lspconfig.svelte.setup({ capabilities = capabilities })

			-- 🧠 Python
			lspconfig.pylsp.setup({ capabilities = capabilities })

			-- 🧠 Bash
			lspconfig.bashls.setup({ capabilities = capabilities })

			-- 🎯 Keymap LSP (áp dụng cho mọi ngôn ngữ)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {}) -- Hover doc
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

			-- 📂 Hiển thị danh sách các hàm / method / struct trong file
			vim.keymap.set("n", "<leader>fm", function()
				local filetype = vim.bo.filetype
				local symbols_map = {
					python = "function",
					javascript = "function",
					typescript = "function",
					java = "class",
					lua = "function",
					go = { "method", "struct", "interface" },
				}
				local symbols = symbols_map[filetype] or "function"
				require("fzf-lua").lsp_document_symbols({ symbols = symbols })
			end, {})
		end,
	},
}
