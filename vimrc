syntax on

" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Bundle 'gmarik/vundle'

Plugin 'Valloric/YouCompleteMe'
Bundle 'Raimondi/delimitMate'
Bundle 'scrooloose/nerdcommenter'
Bundle 'godlygeek/tabular'
Plugin 'airblade/vim-gitgutter'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'

Bundle 'altercation/vim-colors-solarized'

call vundle#end()
filetype plugin indent on

" Theme
set background=dark
let g:solarized_termtrans=0
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

hi LineNr ctermfg=grey ctermbg=none
hi CursorLine ctermbg=237
hi CursorLineNr ctermbg=237
hi Folded cterm=bold ctermbg=234
hi Colorcolumn ctermbg=23

highlight ExtraWhitespace ctermbg=red
match ExtraWhitespace /\s\+$/

" gitgutter
hi SignColumn ctermbg=none
hi GitGutterAdd ctermbg=none ctermfg=lightgreen
hi GitGutterChange ctermbg=none ctermfg=yellow
hi GitGutterDelete ctermbg=none ctermfg=red
hi GitGutterChangeDelete ctermbg=none ctermfg=lightred

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ' '
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#show_buffers = 1

" NerdTree
let NERDTreeShowHidden=1
map <Leader>n :NERDTreeToggle<CR>

" Settings
set autoindent
set backspace=2
set colorcolumn=80
set cursorline
set expandtab
set foldmethod=indent
set foldnestmax=2
set hidden
set hlsearch
set ignorecase
set number
set ruler
set scrolloff=10
set shortmess=atI
set shiftwidth=4
set smartcase
set smartindent
set tabstop=4
set timeoutlen=400
set title

" Mappings
map <space> <leader>

map <leader>yy :.w !xclip -i<CR><CR>
map <leader>p :r !xclip -o<CR>
map <leader>c zA
map <leader>f :noh<CR>
map <leader>w :w<CR><CR>

"" Buffers
nmap <leader>t :enew<cr>" New
nmap <leader>j :bnext<CR>" Next
nmap <leader>k :bprevious<CR>" Previous
nmap <leader>q :bp <BAR> bd #<CR>" Close
nmap <leader>s :ls <CR>" List
nmap <leader>n :badd %:h/<CR>:bnext<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

" Commands
command! J w | !javac %
command! W w
if !exists(":DiffOrig")
    command! Diff vert new | set bt=nofile | r # | 0d_ | diffthis
              \ | wincmd p | diffthis
endif

" Autocommands
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
