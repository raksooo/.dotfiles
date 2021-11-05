" Plugins
call plug#begin('~/.config/nvim/plug')

Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" coc-css, coc-eslint, coc-json, coc-prettier, coc-rust-analyzer, coc-tsserver
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'darfink/vim-plist'

Plug 'vimwiki/vimwiki'

Plug 'morhetz/gruvbox'

call plug#end()

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
set number relativenumber
set ruler
set scrolloff=10
set showtabline=2
set tabline=%!TabLine()
set timeoutlen=400 ttimeoutlen=5
set title
set undofile
set updatetime=100

" Common
function GetBuffers()
  return filter(range(1, bufnr('$')), 'bufexists(v:val) && buflisted(v:val)')
endfunction

function GoToBuffer(n)
  execute 'buffer ' . GetBuffers()[a:n - 1]
endfunction

" Tabline
function TabLine()
  let s = ''
  let buffers = GetBuffers()
  let remainingWidth = -1
  let totalWidth = 0
  let bufferCount = ' ' . len(buffers) . ' '
  let columns = &columns - 1

  for i in range(1, len(buffers))
    let b = buffers[i - 1]
    let isCurrent = b == bufnr('%')
    let isModified = getbufvar(b, '&mod')
    let diagnostics = get(b:, 'coc_diagnostic_info', {})
    let hasError = get(diagnostics, 'error', 0) || get(diagnostics, 'warning', 0)
    let name = fnamemodify(bufname(b), ':t')
    let visible = ' ' . i . ' ' . (name == '' ? '-' : name) . ' '
    let nameLength = strlen(visible)

    if isCurrent && hasError
      let s .= '%#TabLineError#'
    elseif isCurrent && isModified
      let s .= '%#TabLineModifiedSel#'
    elseif isCurrent
      let s .= '%#TabLineSel#'
    elseif isCurrent
      let s .= '%#TabLineModified#'
    else
      let s .= '%#TabLine#'
    endif

    if remainingWidth >= 0 && remainingWidth - nameLength <= 0
      let s .= visible[0:byteidx(visible,remainingWidth+1)-2] . '>'
      break
    else
      if isCurrent
        let centerStart = ((columns - strlen(bufferCount)) / 2) - (nameLength / 2)
        if totalWidth < centerStart
          let remainingWidth = columns - totalWidth - nameLength - strlen(bufferCount)
        else
          let remainingWidth = centerStart
        endif
      else
        let remainingWidth -= nameLength
      endif

      let totalWidth += nameLength
      let s .= visible
    endif
  endfor

  return s . '%#TabLineFill#' . '%=%#TabLineSel#' . bufferCount
endfunction

" Mappings
map <space> <leader>

map <leader>m :noh<CR>
map <leader>n :set relativenumber!<CR>

nnoremap H <C-o>
nnoremap L <C-i>
nnoremap <leader>u <C-u>
nnoremap <leader>d <C-d>

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

"" COC
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>a  <Plug>(coc-codeaction)
nmap <leader>R <Plug>(coc-rename)
nmap <silent> gE <Plug>(coc-diagnostic-prev)
nmap <silent> ge <Plug>(coc-diagnostic-next)

nmap <silent> ]d <Plug>(coc-definition)
nmap <silent> ]r <Plug>(coc-references)
nmap <silent> ]E <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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

"" Firenvim
if exists('g:started_by_firenvim')
  let g:airline#extensions#tabline#enabled = 0
endif


"" Vim Wiki
let g:vimwiki_list = [{'path': '~/Documents/vimwiki/'}]
let g:vimwiki_global_ext = 0
