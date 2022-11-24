source ~/.config/nvim/tabline.vim
source ~/.config/nvim/moreinit.vim

" Plugins
call plug#begin('~/.config/nvim/plug')

Plug 'neovim/nvim-lspconfig'
Plug 'L3MON4D3/LuaSnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'jiangmiao/auto-pairs'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'vimwiki/vimwiki'

Plug 'morhetz/gruvbox'

call plug#end()

" autocomplete
lua require("lsp-config")

" Settings
syntax on
filetype plugin indent on

set colorcolumn=100
set cursorline
set expandtab shiftwidth=2 smartindent softtabstop=2 tabstop=2
set hidden
set ignorecase smartcase
set laststatus=0
set list
set number
set ruler
set scrolloff=10
set showtabline=2
set tabline=%!TabLine()
set timeoutlen=400 ttimeoutlen=5
set title
set undofile
set updatetime=100


" Mappings
map <space> <leader>

map <leader>m :noh<CR>
map <leader>n :set relativenumber!<CR>

nnoremap H <C-o>
nnoremap L <C-i>

"" Buffers
nmap <leader>j :bnext<CR>
nmap <leader>k :bprevious<CR>
nmap <leader>q :bp <BAR> bd #<CR>
nnoremap <leader><tab> :e#<CR>
nnoremap <leader>1 :call GoToBuffer(1)<CR>
nnoremap <leader>2 :call GoToBuffer(2)<CR>
nnoremap <leader>3 :call GoToBuffer(3)<CR>
nnoremap <leader>4 :call GoToBuffer(4)<CR>
nnoremap <leader>5 :call GoToBuffer(5)<CR>
nnoremap <leader>6 :call GoToBuffer(6)<CR>
nnoremap <leader>7 :call GoToBuffer(7)<CR>
nnoremap <leader>8 :call GoToBuffer(8)<CR>
nnoremap <leader>9 :call GoToBuffer(9)<CR>
nnoremap <leader>0 :call GoToBuffer(10)<CR>

"" FZF
command! -bang -nargs=*  RgFiles
      \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --glob "!{.git/*}"'}))

nnoremap <leader>t :RgFiles<Cr>
nnoremap <leader>f :Rg<Cr>
nnoremap <leader>b :Buffers<Cr>

"" Nerdtree
nnoremap <leader>l :NERDTreeToggle<CR>
nnoremap <leader>ö :NERDTreeFind<CR>

" Theme
set background=dark
colorscheme gruvbox

"" Colors
hi Normal ctermbg=0
hi Colorcolumn ctermbg=237

hi TabLine cterm=none ctermfg=7 ctermbg=236
hi TabLineFill ctermbg=236
hi TabLineSel ctermfg=7 ctermbg=238
hi TabLineModified ctermfg=2
hi TabLineModifiedSel ctermfg=2 ctermbg=238
hi TabLineError ctermfg=1 ctermbg=238

"Plugins
"" FZF
let g:fzf_preview_window = 'up:50%'

"" Better whitespace
let g:better_whitespace_enabled=1
let g:better_whitespace_guicolor='#e5c07b'

"" Gitgutter
hi SignColumn ctermbg=none
hi GitGutterAdd ctermbg=none ctermfg=114
hi GitGutterChange ctermbg=none ctermfg=221
hi GitGutterDelete ctermbg=none ctermfg=204
hi GitGutterChangeDelete ctermbg=none ctermfg=204

"" Auto-pairs
let g:AutoPairsMultilineClose = 0
