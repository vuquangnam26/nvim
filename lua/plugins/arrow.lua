-- Trả về một bảng (table) mô tả plugin cho Lazy.nvim
return {
	-- Tên plugin theo định dạng GitHub: "tác_giả/tên_plugin"
	"otavioschwanck/arrow.nvim",

	-- Tuỳ chọn cấu hình cho plugin
	opts = {
		-- Hiển thị icon bên cạnh file/buffer trong danh sách của arrow
		show_icons = true,

		-- Phím leader chính để thao tác với arrow (plugin sẽ map <leader_key> + phím khác)
		-- Ở đây là <Tab>, tức là bạn có thể dùng: <Tab> a, <Tab> b, v.v.
		leader_key = "\t",  -- Lưu ý: nên dùng 1 ký tự (Tab, Space, v.v.)

		-- Phím leader phụ dành cho các lệnh chỉ ảnh hưởng tới **buffer hiện tại**
		buffer_leader_key = "m",  -- Ví dụ: m a => bookmark file hiện tại
	},
}
