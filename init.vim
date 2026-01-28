set nocompatible
set t_Co=256

call plug#begin('~/.config/nvim/plugged')

Plug 'airblade/vim-rooter'
Plug 'scrooloose/nerdtree'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' }
Plug 'joerdav/templ.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'numToStr/Comment.nvim'

Plug 'github/copilot.vim'

"themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tomasiser/vim-code-dark'

call plug#end()

colors codedark
let g:airline_theme = 'codedark'


" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

set tabstop=4
set shiftwidth=4
set expandtab

set wrap!
set number

syntax on
filetype plugin indent on

set nu
set autochdir
set autoread
set completeopt=menu
set linebreak
set noswapfile
set wildignore+=*.pyc

set clipboard+=unnamedplus
set nofoldenable

set completeopt=menuone,noinsert,noselect


nnoremap ff :Telescope find_files<CR>
nnoremap fg :Telescope live_grep<CR>
nnoremap fb :Telescope buffers<CR>
nnoremap fh :Telescope help_tags<CR>
nnoremap rr :!bash run.sh<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call CocActionAsync('doHover')<CR>

" go stuff
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
