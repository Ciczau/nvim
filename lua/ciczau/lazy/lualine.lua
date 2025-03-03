local function iterlines(s)
    if s:sub(-1) ~= "\n" then s = s .. "\n" end
    return s:gmatch("(.-)\n")
end


local function find_dir(d)
    if d == '/' then
        return d
    end
    if vim.b.git_state == nil then
        vim.b.git_state = { '', '', '', '' }
    end
    if d:find("term://") ~= nil then
        return "/tmp"
    end
    if d:find("/tmp/.*FZF") ~= nil then
        return "/tmp"
    end
    if d:find("^[%w-]+://") ~= nil then
        vim.b.git_state[1] = ' ' .. d:gsub("^([%w-]+)://.*", "%1") .. ' '
        d = d:gsub("^[%w-]+://", "")
    end
    local ok, _, code = os.rename(d, d)
    if not ok then
        if code ~= 2 then
            return d
        end
        local newd = d:gsub("(.*/)[%w._-]+/?$", "%1")
        return find_dir(newd)
    end
    return d
end

local function git_status()
    vim.b.git_state = { '', '', '' }
    local file_dir = find_dir(vim.fn.expand("%:p:h"))
    if vim.b.git_state[1] ~= "" then
        return 'd'
    end
    local cmd = "git -C " .. file_dir .. " status --porcelain -b 2> /dev/null"
    local handle = assert(io.popen(cmd, 'r'), '')
    local output = assert(handle:read('*a'))
    handle:close()

    local git_state = { '', '', '', '' }
    local branch_col = 'o'

    if output == '' then
        vim.b.git_state = git_state
        return branch_col
    end

    local line_iter = iterlines(output)

    local first_line = line_iter()
    if first_line:find("%(no branch%)") ~= nil then
        branch_col = 'd'
    else
        local ahead = first_line:gsub(".*ahead (%d+).*", "%1")
        local behind = first_line:gsub(".*behind (%d+).*", "%1")
        ahead = tonumber(ahead)
        behind = tonumber(behind)
        if behind ~= nil then
            git_state[1] = '↓ ' .. tostring(behind) .. ' '
        end
        if ahead ~= nil then
            git_state[1] = git_state[1] .. '↑ ' .. tostring(ahead) .. ' '
        end
    end

    local git_num = { 0, 0, 0 }
    for line in line_iter do
        branch_col = 'm'
        local first = line:gsub("^(.).*", "%1")
        if first == '?' then
            git_num[3] = git_num[3] + 1
        elseif first ~= ' ' then
            git_num[1] = git_num[1] + 1
        end
        local second = line:gsub("^.(.).*", "%1")
        if second == 'M' or second == 'D' then
            git_num[2] = git_num[2] + 1
        end
    end

    if git_num[1] ~= 0 then
        git_state[2] = '● ' .. git_num[1]
    end
    if git_num[2] ~= 0 then
        git_state[3] = '+ ' .. git_num[2]
    end
    if git_num[3] ~= 0 then
        git_state[4] = '… ' .. git_num[3]
    end

    vim.b.git_state = git_state

    return branch_col
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'tokyonight-night',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                }
            },
            sections = {
                lualine_a = { { 'mode', separator = { right = '' } } },
                lualine_b = {
                    {
                        'branch',
                        color =
                            function()
                                local gs = git_status()
                                if gs == 'd' then
                                    return { fg = '#916BDD' }
                                elseif gs ~= 'm' then
                                    return { fg = '#769945' }
                                end
                            end,
                        separator = { right = '' }
                    },
                    {
                        "vim.b.git_state[1]",
                        color = function()
                            if vim.b.git_state[1]:find("^ %w+ $") ~= nil then
                                return { fg = '#F49B55' }
                            end
                        end,
                        padding = { left = 0, right = 0 },
                        separator = { right = '' },
                    },
                    {
                        "vim.b.git_state[2]",
                        color = { fg = '#769945' },
                        padding = { left = 0, right = 1 },
                        separator = { right = '' }
                    },
                    {
                        "vim.b.git_state[3]",
                        color = { fg = '#D75F00' },
                        padding = { left = 0, right = 1 },
                        separator = { right = '' }
                    },
                    {
                        "vim.b.git_state[4]",
                        color = { fg = '#D99809' },
                        separator = { right = '' },
                        padding = { left = 0, right = 1 }
                    },
                },
                lualine_c = { 'filename' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { { 'progress', separator = { left = '' } } },
                lualine_z = { { 'location', separator = { left = '' } } }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = { { 'branch', 'diff', 'diagnostics', 'status' } },
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        }
    end,
}
