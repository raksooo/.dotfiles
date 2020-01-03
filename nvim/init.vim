" Plugins
call plug#begin('~/.config/nvim/plug')

Plug 'morhetz/gruvbox'

Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" coc-css, coc-eslint, coc-json, coc-lua, coc-prettier, coc-rls, coc-tsserver
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

call plug#end()

" Settings
syntax on
filetype plugin indent on

set colorcolumn=100
set cursorline
set expandtab shiftwidth=2 smartindent softtabstop=2 tabstop=2
set hidden
set ignorecase smartcase
set number relativenumber
set ruler
set scrolloff=10
set timeoutlen=400
set title
set undofile
set updatetime=100

" Mappings
map <space> <leader>

map <leader>m :noh<CR>
map <leader>n :set relativenumber!<CR>

"" Buffers
nmap <leader>j :bnext<CR>
nmap <leader>k :bprevious<CR>
nmap <leader>q :bp <BAR> bd #<CR>
nnoremap <leader><tab> :e#<CR>
nnoremap <leader>1 :1b<CR>
nnoremap <leader>2 :2b<CR>
nnoremap <leader>3 :3b<CR>
nnoremap <leader>4 :4b<CR>
nnoremap <leader>5 :5b<CR>
nnoremap <leader>6 :6b<CR>
nnoremap <leader>7 :7b<CR>
nnoremap <leader>8 :8b<CR>
nnoremap <leader>9 :9b<CR>
nnoremap <leader>0 :10b<CR>

"" FZF
nnoremap <leader>t :Files<Cr>
nnoremap <leader>f :Rg<Cr>
nnoremap <leader>b :Buffers<Cr>

"" Nerdtree
nnoremap <leader>l :NERDTreeToggle<CR>

"" COC
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>a  <Plug>(coc-codeaction)
nmap <leader>R <Plug>(coc-rename)

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Theme
set background=dark
colorscheme gruvbox

"" Colors
hi Normal ctermbg=0
hi Colorcolumn ctermbg=237

"Plugins
"" Airline
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ' '
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#show_buffers = 1

"" Better whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:better_whitespace_guicolor='#e5c07b'

"" Gitgutter
hi SignColumn ctermbg=none
hi GitGutterAdd ctermbg=none ctermfg=114
hi GitGutterChange ctermbg=none ctermfg=221
hi GitGutterDelete ctermbg=none ctermfg=204
hi GitGutterChangeDelete ctermbg=none ctermfg=204

"" jsx-typescript
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

"" Prettier
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#single_quote = 'true'
let g:prettier#config#print_width = 100
let g:prettier#config#trailing_comma = 'all'
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

