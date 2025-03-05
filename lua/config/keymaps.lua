local map = vim.api.nvim_set_keymap
local map_del = vim.api.nvim_del_keymap
local opts = { noremap = true, silent = true }

local leader = " "  -- Leader key is space

--Удаляем--
map('n', '<Space>', '', opts)
map('n', '<C-f>', '', opts)
map('n', 'c', '', opts)

map('n', '<C-q>', ':q<CR>', opts) -- Выход из файла по Ctrl+q
map('n', '<C-s>', ':w<CR>', opts) -- Сохранение файла по Ctrl+s

-- Переместиться к первому символу строки (Shift + H)
map('n', '<S-h>', '0', opts)
-- Переместиться к последнему символу строки (Shift + L)
map('n', '<S-l>', '$', opts)
-- Открытие/фокусировка neo-tree
map('n', leader..'e', ':Neotree toggle<CR>', opts)  -- Открыть или закрыть neo-tree

-- Функция для сдвига строк вправо
map('v', '<C-L>', ':\'<,\'>normal! >><CR> V\'<,\'>', opts)
-- Функция для сдвига строк влево
map('v', '<C-H>', ':\'<,\'>normal! <<<CR> V\'<,\'>', opts)
-- Функция для сдвига строк вверх
map('v', '<C-K>', ':\'<,\'>move -2<CR>gv', opts)
-- Функция для сдвига строк вниз
map('v', '<C-J>', ":move '>+1<cr>gv=gv", opts)


-- Переход между окнами по Ctrl+h/j/k/l
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

-- bufferline
map('n', '<Tab>', ':BufferLineCycleNext<CR>', opts)
map('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', opts)

-- Закрыть буфер и перейти на предыдущее окно
map('n', '<C-c>', ':q!<CR>', opts)

local builtin = require('telescope.builtin')
vim.keymap.set('n', leader..'b', builtin.find_files, opts)
vim.keymap.set('n', leader..'f', require('telescope.builtin').live_grep, opts)

-- Перемещение на 8 строк вниз с помощью Shift+jk
map('n', '<S-j>', '8j', opts)
-- Перемещение на 8 строк вверх с помощью Shift+kj
map('n', '<S-k>', '8k', opts)

-- Перейти к определению
map('n', leader..'gg', ':lua vim.lsp.buf.definition()<CR>', opts)

-- Функция для поиска текущего слова
function search_current_word()
  -- Проверяем, есть ли активное выделение (подсвеченный текст поиска)
  if vim.v.hlsearch == 1 then
    vim.cmd('nohlsearch')  -- Отключаем подсветку поиска
  else
    -- Если подсветки нет, ищем текущее слово
    local word = vim.fn.expand('<cword>')  -- Получить текущее слово под курсором
    vim.cmd('execute "normal! /' .. word .. '\\<CR>"')  -- Выполнить поиск
  end
end
-- Привязка для поиска текущего слова с помощью Alt+v
map('n', leader..'v', ':lua search_current_word()<CR>', opts)

-- Переназначение отмены изменений
map('n', leader..'h', 'u', opts)
-- Переназначение повторения отмененных изменений
map('n', leader..'l', '<C-r>', opts)

-- Выделить вниз на 10 строк (Alt + j)
map('v', '<S-j>', '10j',  opts)
-- Выделить вверх на 10 строк (Alt + k)
map('v', '<S-k>', '10k',  opts)
-- Выделить до начала или конца
map('v', '<S-h>', '^',  opts)
map('v', '<S-l>', 'g_',  opts)

-- Вставляем внизу пустую строку
map('n', '<CR>', 'o<Esc>', opts)

-- Удаляем до конца или начала строки
map('o', 'H', '^', opts)
map('o', 'L', 'g_', opts)

-- Глобальная функция для замены текста в нормальном режиме
_G.replace_selected_or_prompt = function()
    -- Запрашиваем шаблон поиска
    local search_pattern = vim.fn.input("Что меняем: ")
    if search_pattern == "" then
        print("Шаблон поиска не может быть пустым!")
        return
    end

    -- Проверяем, есть ли шаблон в текущем тексте
    local current_text = vim.fn.getline(1, "$")
    local found = false
    for _, line in ipairs(current_text) do
        if string.find(line, search_pattern) then
            found = true
            break
        end
    end

    if not found then
        print("Ошибка: шаблон '" .. search_pattern .. "' не найден в тексте!")
        return
    end

    -- Запрашиваем текст для замены
    local replacement = vim.fn.input("На что заменить: ")

    -- Формируем команду замены
    local command = string.format("%%s/%s/%s/g", vim.fn.escape(search_pattern, "/\\."), vim.fn.escape(replacement, "/\\"))

    -- Выполняем команду с защитой от ошибок
    local success, err = pcall(function()
        vim.cmd(command)
    end)

    if not success then
        print("Ошибка при выполнении команды замены: " .. err)
    end

    -- Переход в нормальный режим после выполнения замены
    vim.cmd("normal! n")
end

-- Привязываем Shift+R к функции в нормальном режиме
map("n", "R", "<cmd>lua _G.replace_selected_or_prompt()<CR>", opts)


-- Горячие клавиши для создания окон (сплитов)
map('n', '<C-w><C-h>', ':vsplit<CR>', opts)  -- Вертикальный сплит (слева)
map('n', '<C-w><C-j>', ':split<CR>', opts)    -- Горизонтальный сплит (снизу)
map('n', '<C-w><C-k>', ':split<CR>', opts)    -- Горизонтальный сплит (сверху)
map('n', '<C-w><C-l>', ':vsplit<CR>', opts)  -- Вертикальный сплит (справа)

-- Горячие клавиши для изменения размера окна с помощью leader + стрелки
map('n', '<C-w><Down>', ':resize +7<CR>', opts)  -- Увеличить высоту окна вниз
map('n', '<C-w><Up>', ':resize -7<CR>', opts)   -- Уменьшить высоту окна вверх
map('n', '<C-w><Left>', ':vertical resize -7<CR>', opts)  -- Уменьшить ширину окна влево
map('n', '<C-w><Right>', ':vertical resize +7<CR>', opts) -- Увеличить ширину окна вправо 


-- Настройка для удаления
map('n', 'd', '"_d', opts)
map('n', 'dd', '"_dd', opts)
map('v', 'd', '"_d', opts)

-- Глобальная функция для вставки строки '# type: ignore' в конец текущей строки
_G.insert_type_ignore = function()
    local line = vim.api.nvim_get_current_line()
    local new_line = line .. " # type: ignore"
    vim.api.nvim_set_current_line(new_line)
end

-- Создание команды для режима normal
map('n', '"', ':lua insert_type_ignore()<CR>', opts)


-- Определим саму функцию
function MyCustomUndoFunction()
  -- Выполним отмену действия
  vim.cmd('undo')
  vim.cmd('nohlsearch')
end

-- Теперь зададим нашу собственную функцию для клавиши 'u'
map_del('n', 'u')
map('n', 'u', ':lua MyCustomUndoFunction()<CR>', { noremap = true, silent = true })
