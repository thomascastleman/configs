syntax on

" Line numbers
set number
set relativenumber

" Indentation
set autoindent          "copy indent from current line when starting a new line
set tabstop=2           "number of space on a <Tab> character
set shiftwidth=2        "let indent correspond to a single Tab
set softtabstop=0       "inserts combo of space and tab to simulate tabstop
set smarttab
set expandtab

set clipboard=unnamed " TODO: This doesn't work at the moment

" Highlight all search matches
:set hlsearch

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
Plug 'airblade/vim-gitgutter'   " Show git diff in gutter

" Status bar
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'		" display icons

" Rust
Plug 'rust-lang/rust.vim'

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
		lualine_b = {{
			'filename',
			path = 0,
		}},
		lualine_c = {'diff'},
    lualine_x = {'filetype'},
    lualine_y = {},
    lualine_z = {}
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

" ================== Rust =================
" rustfmt
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

au Filetype rust set colorcolumn=100 " 100 char ruler
au Filetype rust source ~/.config/nvim/indentwidth4.vim " indent with 4 spaces
