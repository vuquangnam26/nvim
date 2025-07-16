# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.
# Tổng hợp phím tắt (keymap) đã cấu hình trong Neovim

Dưới đây là danh sách các phím tắt đã được bạn cấu hình trong các plugin bạn đã gửi:

## 1. Plugin: `nvim-neotest/neotest`

Dùng để chạy test cho Go, Dart, Java, Zig...

| Phím tắt     | Chức năng                                                                      |
| ------------ | ------------------------------------------------------------------------------ |
| `<Leader>tr` | Chạy test tại vị trí con trỏ hiện tại                                          |
| `<Leader>tb` | Chạy test với chế độ debug (DAP)                                               |
| `<Leader>ts` | Dừng test đang chạy                                                            |
| `<Leader>to` | Mở output test                                                                 |
| `<Leader>tO` | Mở output test và nhảy vào kết quả                                             |
| `<Leader>tv` | Hiện/tắt bảng tổng hợp test                                                    |
| `<Leader>tp` | Chạy toàn bộ test trong file hiện tại                                          |
| `<Leader>tt` | Nhập tên test cụ thể (dành cho Go test suite) và chạy trực tiếp bằng `go test` |

## 2. Plugin: `mbbill/undotree`

Dùng để mở cây undo trong Neovim

| Phím tắt     | Chức năng                 |
| ------------ | ------------------------- |
| `<Leader>ut` | Toggle mở/tắt Undotree    |
| `<Leader>uf` | Focus vào Undotree window |

## 3. Plugin: `karb94/neoscroll.nvim`

Dùng để cuộn trang mượt với animation

| Phím tắt | Chức năng                                 |
| -------- | ----------------------------------------- |
| `<C-d>`  | Cuộn xuống nửa trang (với animation)      |
| `<C-u>`  | Cuộn lên nửa trang (với animation)        |
| `<C-f>`  | Cuộn xuống 1 trang                        |
| `<C-b>`  | Cuộn lên 1 trang                          |
| `<C-e>`  | Scroll nhỏ lên (0.1 trang)                |
| `<C-y>`  | Scroll nhỏ xuống (0.1 trang)              |
| `zt`     | Cuộn để dòng hiện tại lên đầu màn hình    |
| `zz`     | Cuộn để dòng hiện tại vào giữa màn hình   |
| `zb`     | Cuộn để dòng hiện tại xuống cuối màn hình |

## 4. Plugin: `nvimtools/none-ls.nvim`

Dùng để format code và linter (null-ls)

| Phím tắt     | Chức năng                     |
| ------------ | ----------------------------- |
| `<Leader>gf` | Format file hiện tại bằng LSP |

## 5. Plugin: `epwalsh/pomo.nvim`

Dùng để đếm giờ theo phương pháp Pomodoro (kết hợp với `nvim-notify`)

| Lệnh            | Chức năng                       |
| --------------- | ------------------------------- |
| `:TimerStart`   | Bắt đầu bộ đếm Pomodoro         |
| `:TimerRepeat`  | Bắt đầu bộ đếm lặp lại          |
| `:TimerSession` | Bắt đầu session theo config sẵn |

## Ghi chú

* `<Leader>` mặc định là `\` hoặc `,` tùy config. Nếu bạn dùng LazyVim thì thường là `<Space>`.
* Bạn có thể kiểm tra giá trị của `<Leader>` bằng lệnh `:echo mapleader` trong Neovim.

---

Nếu bạn thêm plugin hoặc keymap mới, mình có thể cập nhật danh sách này tiếp nhé.
