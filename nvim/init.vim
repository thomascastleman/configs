syntax on

" Line numbers
set number
set relativenumber

" Indentation
set autoindent					"copy indent from current line when starting a new line
set tabstop=2						"number of space on a <Tab> character
set shiftwidth=2				"let indent correspond to a single Tab
set softtabstop=0				"inserts combo of space and tab to simulate tabstop
set smarttab
set expandtab

set clipboard=unnamed " TODO: This doesn't work at the moment

" Enable mouse in all modes (this prevents scroll from scrolling tmux)
set mouse=a

" create window splits with vv and ss
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" Escape with jk
inoremap jk <Esc>

" Enable Y to yank to end of line
nnoremap Y y$

" enable pretty highlighting on yank 
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END

" To install new plugins, run :PlugInstall
call plug#begin('~/.local/nvim/plugins')

" Colors
Plug 'markvincze/panda-vim'

" Editing
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 

" Status bar
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'		" display icons

call plug#end()

" Color scheme
set termguicolors
colorscheme panda

" ================== lualine =================
lua << END
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'material',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
		lualine_a = {'mode'},
		lualine_b = {
			{
				'tabs',
				max_length = vim.o.columns / 3, -- maximum width of tabs component
																				-- can also be a function that returns value of max_length dynamicaly
				mode = 2, -- 0  shows tab_nr
									-- 1  shows tab_name
									-- 2  shows tab_nr + tab_name
				tabs_color = {
					active = 'lualine_{section}_normal',   -- color for active tab
					inactive = 'lualine_{section}_inactive', -- color for inactive tab
				},
			}
		},
    lualine_c = {'branch', 'diff', 'diagnostics'},
    lualine_d = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
END
