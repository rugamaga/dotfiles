" ---------------------------- Encodings
set encoding=utf-8
scriptencoding utf-8
set termencoding=utf-8
set fileencodings=utf-8,ucs-bom,euc-jp,cp932,sjis

" ---------------------------- Use vim
set nocompatible

" ---------------------------- Auto plugin install
if empty(glob($HOME . '/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'sainnhe/edge'
Plug 'itchyny/lightline.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'editorconfig/editorconfig-vim'
Plug 'thinca/vim-quickrun'
Plug 'airblade/vim-gitgutter'
Plug 'lambdalisue/gina.vim'
Plug 'bronson/vim-trailing-whitespace'
" Plug 'bfredl/nvim-miniyank'
Plug 'dhruvasagar/vim-table-mode'
Plug 'andymass/vim-matchup'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'sheerun/vim-polyglot'

call plug#end()

" ---------------------------- Color Scheme
syntax on
set notermguicolors
set background=dark
silent! colorscheme edge
" set background color as transparent
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
hi! LineNr ctermbg=NONE guibg=NONE
hi! EndOfBuffer ctermbg=NONE guibg=NONE
hi! Terminal ctermbg=NONE guibg=NONE

" ---------------------------- Basic Settings

" ----------- pages
filetype plugin indent on
set fileformats=unix,dos

" ----------- indicator
set number

" ----------- tab pages
set showtabline=2

" ----------- tab and spacing
set tabstop=2
set shiftwidth=2
set expandtab

" ----------- clipboard
set clipboard=unnamed

" ----------- fold
set nofoldenable

" ----------- search and substitute
set ignorecase
set smartcase
set wrapscan
set incsearch
" set inccommand=split

" ----------- completion and menu
set updatetime=300
set shortmess+=c
set signcolumn=yes

" ----------- autowrite
set autowrite

" ---------------------------- Leader
let mapleader = ' '

" ---------------------------- Functions
" create directory automatically
function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
endfunction

" ---------------------------- Augroup
augroup my_augroup
    autocmd!
augroup END

command! -bang -nargs=* MyAutocmd autocmd<bang> my_augroup <args>

" ---------------------------- autocmd
MyAutocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
MyAutocmd FileType php setlocal shiftwidth=4 softtabstop=4 expandtab

MyAutocmd BufRead,BufNewFile *.sbt set filetype=scala

" ---------------------------- quickrun
let g:quickrun_config = {}
let g:quickrun_config.cpp = {
      \ 'type': 'cpp',
      \ 'cmdopt': '-std=c++14'
      \ }

" ---------------------------- indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 30
let g:indent_guides_space_guides = 1

" ---------------------------- lightline
let g:lightline = {
\   'colorscheme': 'edge',
\   'separator': { 'left': "\uE0C4", 'right': "\uE0C5" },
\   'subseparator': { 'left': "\uE0b1", 'right': "\uE0b3" },
\   'active': {
\       'left': [
\           ['mode', 'paste', 'gitgutter', 'gina', 'filename' ]
\       ],
\       'right': [
\           ['pos', 'cocstatus', 'filetype', 'fileencoding', 'fileformat'],
\       ],
\   },
\   'component_function': {
\       'mode': 'LightlineMode',
\       'gina': 'LightlineGina',
\       'gitgutter': 'LightlineGitGutter',
\       'pos': 'LightlinePos',
\       'filename': 'LightlineFilename',
\       'fileformat': 'LightlineFileformat',
\       'filetype': 'LightlineFiletype',
\       'fileencoding': 'LightlineFileencoding',
\       'cocstatus': 'coc#status'
\   },
\}
let g:lightline.inactive = g:lightline.active

function! LightlineMode()
    return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineModified()
    return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
    return &readonly ? '' : ''
endfunction

function! LightlineGina()
    let icon = ''
    let branch = gina#component#repo#branch()
    return strlen(branch) ? icon . branch : ''
endfunction

function! LightlineGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 60
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

function! LightlinePos()
    return line('.') . '/' . line('$') . ' : ' . col('.')
endfunction

function! LightlineFilename()
    return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \  '' != expand('%:.') ? expand('%:.') : '[No Name]') .
        \ LightlineModified()
endfunction

function! LightlineFileformat()
    return winwidth(0) > 60 ?
        \ &fileformat == 'unix' ? 'unix/LF' :
        \ &fileformat == 'dos' ? 'dos/CRLF' :
        \ &fileformat == 'mac' ? 'mac/CR' :
        \ &fileformat : ''
endfunction

function! LightlineFiletype()
    return winwidth(0) > 60 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
    return winwidth(0) > 60 ? strlen(&fenc) ? &fenc : &enc : ''
endfunction

" ---------------------------- coc
let g:coc_config_home = $SETTINGS_ROOT

" ---------------------------- key mapping

" ----------- mode change
inoremap <C-j> <Esc>
nnoremap <C-j> <Esc>

" ----------- close
nnoremap qq <Esc>:q<Cr>

" ----------- operate tabpages
nnoremap t <Nop>
nnoremap <silent> tt :<C-u>tabnew<Cr>:tabmove<Cr>
nnoremap <silent> tl :<C-u>tabnext<Cr>
nnoremap <silent> th :<C-u>tabprevious<Cr>
" create current buffer tabpage
nnoremap <silent> tb :execute "tabnew \| buffer " . bufnr('%')<Cr>

" ----------- yank & pasting
" use miniyank for fixing : https://github.com/neovim/neovim/issues/1822
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)

" ----------- shortcut fzf
nnoremap gf :GFiles --cached --exclude-standard --others<Cr>

" ----------- coc
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>ac <Plug>(coc-codeaction)

nnoremap <silent> F :call CocAction('format')<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

MyAutocmd CursorHold * silent call CocActionAsync('highlight')

nmap <Leader>n <Plug>(coc-rename)

nmap <silent> <Leader>c <Plug>(coc-diagnostic-next)
nnoremap <silent> <Leader>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <Leader>o  :<C-u>CocList outline<cr>
nnoremap <silent> <Leader>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent> <Leader>j  :<C-u>CocNext<CR>
nnoremap <silent> <Leader>k  :<C-u>CocPrev<CR>
nnoremap <silent> <Leader>p  :<C-u>CocListResume<CR>
