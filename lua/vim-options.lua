-- Sử dụng khoảng trắng thay vì ký tự tab thực
vim.cmd("set expandtab")

-- Thiết lập chiều rộng của một tab là 4 khoảng trắng
vim.cmd("set tabstop=4")

-- Khi nhấn Tab trong chế độ insert, chèn 4 khoảng trắng
vim.cmd("set softtabstop=4")

-- Dùng 4 khoảng trắng để auto-indent (ví dụ khi dùng >> hay <<)
vim.cmd("set shiftwidth=4")

-- Đặt phím leader là khoảng trắng (dùng cho keymap như <leader>p)
vim.g.mapleader = " "

-- Hiển thị số dòng
vim.cmd("set number")

-- Hiển thị số dòng tương đối (hữu ích khi di chuyển bằng j/k)
vim.cmd("set relativenumber")

-- Tô sáng dòng hiện tại
vim.cmd("set cursorline")

-- Tô màu cho số dòng phía trên dòng hiện tại (dòng tương đối)
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "white" })

-- Tô màu cho số dòng phía dưới dòng hiện tại (dòng tương đối)
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#ead84e" })

-- Dùng clipboard hệ thống (copy/paste giữa Neovim và các app khác)
vim.api.nvim_set_option("clipboard", "unnamed")

-- Tìm kiếm có highlight kết quả
vim.opt.hlsearch = true

-- Hiển thị kết quả tìm kiếm ngay khi đang gõ
vim.opt.incsearch = true

-- Di chuyển dòng đã chọn xuống 1 dòng trong chế độ visual (v)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Di chuyển dòng đã chọn lên 2 dòng trong chế độ visual (v)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Dán đè lên đoạn được chọn mà không ghi đè vào clipboard
vim.keymap.set("x", "<leader>p", '"_dP')

-- Vẽ cột dọc ở ký tự thứ 94 để giúp canh độ dài dòng code
vim.opt.colorcolumn = "94"

-- Tắt một số cảnh báo phiền phức từ LLM Language Server
local notify_original = vim.notify
vim.notify = function(msg, ...)
	if
		msg
		and (
			msg:match("position_encoding param is required")
			or msg:match("Defaulting to position encoding of the first client")
			or msg:match("multiple different client offset_encodings")
		)
	then
		-- Nếu nội dung cảnh báo nằm trong danh sách trên thì bỏ qua
		return
	end
	-- Ngược lại, gọi lại hàm gốc để hiện thông báo
	return notify_original(msg, ...)
end

-- Tắt việc tạo file swap (file tạm thời có đuôi .swp)
vim.opt.swapfile = false
