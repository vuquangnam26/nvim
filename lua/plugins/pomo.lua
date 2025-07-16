return {
  "epwalsh/pomo.nvim",
  version = "*",
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  dependencies = {
    "rcarriga/nvim-notify",
  },
  opts = {
    notifiers = {
      {
        name = "Default",
        opts = {
          sticky = true,
          title_icon = "⏰",
          text_icon = "✔",
        },
      },
    },
    timers = {
      Work = { duration = 25, break_duration = 5 }, -- Timer làm việc
      LongBreak = { duration = 25, break_duration = 15 }, -- Timer nghỉ dài
    },
  },
}
