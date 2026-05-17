-- Pi coding agent in a floating terminal
-- <leader>pg  — toggle pi agent
-- <leader>pa  — send file:range reference to pi (prompts for question)
-- <C-q>       — close pi (from terminal mode)
-- q           — close pi (from normal mode on terminal buffer)

--- Find any running pi terminal (matches cmd[1] == "pi")
local function get_pi_terminal()
  for _, term in ipairs(Snacks.terminal.list()) do
    local info = vim.b[term.buf].snacks_terminal
    if info and info.cmd and info.cmd[1] == "pi" then
      return term
    end
  end
  return nil
end

local pi_term_opts = {
  win = {
    style = "pi_agent",
    position = "float",
    width = math.floor(vim.o.columns * 0.9),
    height = math.floor(vim.o.lines * 0.85),
    border = "rounded",
    title = " pi agent ",
    title_pos = "center",
  },
  cwd = vim.fn.getcwd(),
  interactive = true,
}

--- Get file path relative to cwd (forward slashes, pi-friendly).
--- Returns nil for unnamed buffers.
local function get_relpath()
  local full = vim.api.nvim_buf_get_name(0)
  if full == "" then
    return nil
  end
  local cwd = vim.fn.getcwd()
  local rel = full
  -- Strip cwd prefix (handles both / and \)
  if full:sub(1, #cwd + 1):find(cwd .. "[/\\]") then
    rel = full:sub(#cwd + 2)
  end
  return rel:gsub("\\", "/")
end

--- Save lines to a temp file (fallback for unnamed buffers).
local function save_temp_file(lines)
  local ext = vim.fn.expand("%:e")
  local tmp = vim.fn.tempname()
  if ext ~= "" then
    tmp = tmp .. "." .. ext
  end
  vim.fn.writefile(lines, tmp)
  return tmp
end

--- Launch pi with @file reference and a question.
--- Uses -c to continue session when pi was already running.
local function launch_pi(file_ref, question, was_running)
  local cmd
  if was_running then
    cmd = { "pi", "-c", "@" .. file_ref }
  else
    cmd = { "pi", "@" .. file_ref }
  end
  if question and question ~= "" then
    table.insert(cmd, question)
  end

  vim.schedule(function()
    Snacks.terminal.toggle(cmd, pi_term_opts)
  end)
end

local function send_to_pi(start_line, end_line)
  local relpath = get_relpath()

  -- Unnamed buffer: fall back to temp file with raw code
  if not relpath then
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    if #lines == 0 then
      vim.notify("pi-agent: nothing to send", vim.log.levels.WARN)
      return
    end
    local tmp = save_temp_file(lines)

    vim.ui.input({ prompt = "pi> " }, function(input)
      if input == nil then return end
      local existing = get_pi_terminal()
      local was_running = existing ~= nil
      if existing then existing:close() end
      launch_pi(tmp, input ~= "" and input or nil, was_running)
    end)
    return
  end

  -- Named buffer: auto-save so pi reads latest content
  if vim.bo.modified then
    vim.cmd("silent! update")
  end

  -- Build range reference like "lua/plugins/pi-agent.lua:45-67"
  local range_ref = relpath .. ":" .. start_line .. "-" .. end_line

  vim.ui.input({ prompt = "pi> " }, function(input)
    if input == nil then return end -- Esc cancelled

    local question
    if input == "" then
      question = "Look at " .. range_ref
    else
      question = range_ref .. ": " .. input
    end

    local existing = get_pi_terminal()
    local was_running = existing ~= nil
    if existing then existing:close() end

    launch_pi(relpath, question, was_running)
  end)
end

return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      Snacks.config.style("pi_agent", {
        bo = {
          filetype = "pi_agent",
        },
        keys = {
          q = "hide",
        },
      })
    end,
    keys = {
      -- Toggle pi agent
      {
        "<leader>pg",
        function()
          local term = get_pi_terminal()
          if term then
            term:toggle()
          else
            Snacks.terminal.toggle({ "pi" }, pi_term_opts)
          end
        end,
        desc = "Pi Agent (float)",
        mode = { "n", "t" },
      },

      -- Send file:range reference to pi
      {
        "<leader>pa",
        function()
          local mode = vim.fn.mode()
          local start_line, end_line

          if mode:match("[vV\22]") then
            local _, ls = unpack(vim.fn.getpos("v"))
            local _, le = unpack(vim.fn.getpos("."))
            start_line = math.min(ls, le)
            end_line = math.max(ls, le)
          else
            start_line = vim.fn.line(".")
            end_line = vim.fn.line(".")
          end

          if start_line == end_line then
            vim.notify("pi-agent: select lines first (V / vip / etc.)", vim.log.levels.WARN)
            return
          end

          send_to_pi(start_line, end_line)
        end,
        desc = "Pi Agent: send selection",
        mode = { "v", "x", "n" },
      },

      -- Quick close from terminal mode
      {
        "<C-q>",
        function()
          local term = get_pi_terminal()
          if term then term:hide() end
        end,
        desc = "Close Pi Agent",
        mode = "t",
      },
    },
  },
}
