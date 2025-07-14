-- === Các hàm tiện ích cho Vim/Neovim === --

-- Copy thông báo lỗi hiện tại vào clipboard (dùng <leader>ce)
vim.keymap.set("n", "<leader>ce", function()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics > 0 then
		local message = diagnostics[1].message
		vim.fn.setreg("+", message)
		print("Copied diagnostic: " .. message)
	else
		print("No diagnostic at cursor")
	end
end, { noremap = true, silent = true })

-- Di chuyển đến lỗi tiếp theo/trước đó hoặc xem lỗi nổi bật ở vị trí con trỏ
vim.keymap.set("n", "<leader>ne", vim.diagnostic.goto_next)      -- đi tới lỗi tiếp theo
vim.keymap.set("n", "<leader>pe", vim.diagnostic.goto_prev)      -- đi tới lỗi trước đó
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)      -- hiện lỗi dưới dạng popup

-- Copy đường dẫn tuyệt đối của file hiện tại vào clipboard
vim.keymap.set("n", "<leader>cp", function()
	local filepath = vim.fn.expand("%:p")
	vim.fn.setreg("+", filepath) -- Lưu vào clipboard Neovim
	vim.fn.system("echo '" .. filepath .. "' | pbcopy") -- Lưu vào clipboard macOS
	print("Copied: " .. filepath)
end, { desc = "Copy absolute path to clipboard" })

-- Mở file hiện tại trong trình duyệt (tùy OS sẽ chọn Chrome hoặc Firefox)
vim.keymap.set("n", "<leader>ob", function()
	local file_path = vim.fn.expand("%:p")
	if file_path ~= "" then
		local cmd
		if vim.fn.has("mac") == 1 then
			local firefox_installed = vim.fn.system("which /Applications/Firefox.app/Contents/MacOS/firefox")
			if firefox_installed == "" then
				cmd = "open -a 'Google Chrome' " .. file_path
			else
				cmd = "open -a 'Firefox' " .. file_path
			end
		else
			-- Nếu không phải macOS thì dùng Firefox hoặc Chrome
			local firefox_path = vim.fn.system("which firefox"):gsub("\n", "")
			local has_firefox = firefox_path ~= ""
			if has_firefox then
				cmd = "firefox " .. file_path
			else
				cmd = "google-chrome " .. file_path
			end
		end
		os.execute(cmd .. " &")
	else
		print("No file to open")
	end
end, { desc = "Open current file in browser" })

-- === Tự động chuyển layout bàn phím khi chuyển mode (chỉ dùng cho macOS) === --
-- Yêu cầu cài im-select: https://github.com/daipeihust/im-select (cài bằng brew)
local is_mac = vim.loop.os_uname().sysname == "Darwin"
if is_mac then
	local function get_current_layout()
		local f = io.popen("im-select")
		local layout = nil
		if f ~= nil then
			layout = f:read("*all"):gsub("\n", "")
			f:close()
		end
		return layout
	end

	local last_insert_layout = get_current_layout()
	local english_layout = "com.apple.keylayout.ABC" -- layout tiếng Anh

	-- Khi thoát insert mode -> lưu lại layout hiện tại và chuyển sang tiếng Anh
	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			local current = get_current_layout()
			last_insert_layout = current
			os.execute("im-select " .. english_layout)
		end,
	})

	-- Khi vào command-line mode (:) -> chuyển sang tiếng Anh
	vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
		pattern = "*:*n",
		callback = function()
			os.execute("im-select " .. english_layout)
		end,
	})

	-- Khi quay lại insert mode -> khôi phục layout cũ
	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function()
			os.execute("im-select " .. last_insert_layout)
		end,
	})

	-- Khi quay lại cửa sổ Neovim -> khôi phục layout cũ
	vim.api.nvim_create_autocmd({ "FocusGained" }, {
		callback = function()
			os.execute("im-select " .. last_insert_layout)
		end,
	})
end

-- === Hiển thị cây thư mục (giống `tree -L 4`) trong floating window của Neovim ===
vim.api.nvim_create_user_command("ShowTree", function()
	local buf = vim.api.nvim_create_buf(false, true)

	local editor_width = vim.o.columns
	local editor_height = vim.o.lines
	local width = math.floor(editor_width * 0.6)
	local height = math.floor(editor_height * 0.9)

	local row = math.floor((editor_height - height) / 2)
	local col = math.floor((editor_width - width) / 2)

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
		style = "minimal",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Gọi lệnh `tree -L 4` và hiển thị kết quả trong buffer nổi
	local job_id = vim.fn.jobstart("tree -L 4", {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					vim.api.nvim_buf_set_lines(buf, -1, -1, true, { line })
				end
			end
		end,
		on_exit = function()
			-- Không đóng cửa sổ sau khi hiển thị xong
		end,
	})
	print("Job ID: " .. job_id)
end, {})

-- Gán phím <leader>vt để gọi hàm ShowTree
vim.keymap.set("n", "<leader>vt", ":ShowTree<CR>", { desc = "Show directory tree in floating window" })
