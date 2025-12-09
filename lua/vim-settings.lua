---@diagnostic disable: unused-function, unused-local
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set ruler")
vim.cmd("set cindent")
vim.cmd("set mouse=")

vim.g.mapleader = " "

--Better writing/quitting--
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>al", ":wqa<CR>")
vim.keymap.set("n","<leader>as",":qa!<CR>")
--vim.keymap.set("n", "<leader>", ":wqa<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("v", "<leader>y", '\"+y', {desc = "Copying to the clipboard"})

vim.wo.number = true

--Terminal
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.wrap = false

--Visual--
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.showmatch = true
vim.opt.winborder = "rounded"

--Better indenting--
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

--Search--
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

--Files---
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.swapfile = false

--Misc--
vim.opt.encoding = "UTF-8"

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

--Delete--
vim.keymap.set({ "n", "v" }, "<leader>da", '"_d<CR>', { desc = "Delete without yanking" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
-- Splitting & Resizing
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +4<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -4<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -4<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +4<CR>", { desc = "Increase window width" })

--Tabs--
vim.keymap.set("n", "<leader>tn",":tabnew<CR>")
vim.keymap.set("n", "<leader>tx",":tabclose<CR>")


--Autocommands--
local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

local terminal_state = {
  buf = nil,
  win = nil,
  is_open = false
}

local function FloatingTerminal()
    if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
        return
    end


    if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then

        terminal_state.buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(terminal_state.buf, 'bufhidden', 'hide')
    end

    local width = math.floor(vim.o.columns * 0.95) --0.8
    local height = math.floor(vim.o.lines * 0.95) --0.8
    local row = math.floor((vim.o.lines - height) / 3) --0.2
    local col = math.floor((vim.o.columns - width) / 2)

    terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  local has_terminal = false
    local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
    for _, line in ipairs(lines) do
        if line ~= "" then
            has_terminal = true
            break
        end
    end

    if not has_terminal then
        vim.fn.termopen(os.getenv("SHELL"))
    end

    terminal_state.is_open = true
    vim.cmd("startinsert")
    -- Set up auto-close on buffer leave 
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = terminal_state.buf,
        callback = function()
            if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
                vim.api.nvim_win_close(terminal_state.win, false)
                terminal_state.is_open = false
            end
        end,
        once = true
    })
end

local function CloseFloatingTerminal()
    if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
    end
end

-- Key mappings
vim.keymap.set("n", "<leader>te", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", function()
    if terminal_state.is_open then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
    end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })

