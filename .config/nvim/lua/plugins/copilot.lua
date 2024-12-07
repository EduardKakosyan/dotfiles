return {
  "zbirenbaum/copilot.lua",
  keys = {
    {
      "<leader>at",
      function()
        if require("copilot.client").is_disabled() then
          require("copilot.command").enable()
        else
          require("copilot.command").disable()
        end
      end,
      desc = "Toggle (Copilot)",
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    opts = function()
      local copilot_toggle = require("lazyvim.util.toggle").wrap({
        name = "Copilot Completion",
        get = function()
          return not require("copilot.client").is_disabled()
        end,
        set = function(state)
          if state then
            require("copilot.command").enable()
          else
            require("copilot.command").disable()
          end
        end,
      })

      LazyVim.toggle.map("<leader>al", copilot_toggle)
    end,
  },
}
