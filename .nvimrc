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
Plug 'tpope/vim-fugitive'
Plug 'lambdalisue/gina.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'bfredl/nvim-miniyank'
Plug 'dhruvasagar/vim-table-mode'
Plug 'andymass/vim-matchup'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'yuki-ycino/fzf-preview.vim'
Plug 'fatih/vim-go'
Plug 'sheerun/vim-polyglot'
Plug 'neovim/nvim-lsp'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-lsp'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'bfredl/nvim-ipy'
Plug 'janko/vim-test'
Plug 'sebdah/vim-delve', { 'for': ['go'] }
Plug 'ka-tsu-mo/at-vim-coder'
Plug 'mipmip/vim-scimark'

call plug#end()

" ---------------------------- Color Scheme
let g:edge_transparent_background=1
syntax on
set termguicolors
set background=dark
silent! colorscheme edge

" ---------------------------- Basic Settings

" ----------- pages
filetype plugin indent on
set fileformats=unix,dos

" ----------- indicator
set number

" ----------- buffers
set hidden

" ----------- tab pages
set showtabline=2

" ----------- tab and spacing
set tabstop=2
set shiftwidth=2
set expandtab

" ----------- clipboard
set clipboard+=unnamedplus

" ----------- fold
set nofoldenable

" ----------- search and substitute
set ignorecase
set smartcase
set wrapscan
set incsearch
set inccommand=split

" ----------- completion and menu
set updatetime=300
set shortmess+=c
set signcolumn=yes
set pumheight=10

" ----------- auto read/write
set autoread
set autowrite

" ----------- backup
set nobackup
set noswapfile

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
\           ['pos', 'filetype', 'fileencoding', 'fileformat'],
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
\       'fileencoding': 'LightlineFileencoding'
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

" ---------------------------- key mapping

" ----------- mode change
inoremap <C-j> <Esc>
nnoremap <C-j> <Esc>
tnoremap <C-j> <C-\><C-n>

" ----------- close
nnoremap qq <Esc>:q<Cr>

" ----------- operate tabpages
nnoremap t <Nop>
nnoremap <silent> tt :<C-u>tabnew<Cr>:tabmove<Cr>
nnoremap <silent> tl :<C-u>tabnext<Cr>
nnoremap <silent> th :<C-u>tabprevious<Cr>
" create current buffer tabpage
nnoremap <silent> tb :execute "tabnew \| buffer " . bufnr('%')<Cr>

" ----------- builds
nnoremap mt :make test<Cr>

" ----------- yank & pasting
" use miniyank for fixing : https://github.com/neovim/neovim/issues/1822
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)

" ----------- shortcut fzf
let g:fzf_preview_floating_window_rate=1
nnoremap gf :FzfPreviewGitFiles --cached --exclude-standard --others<Cr>
nnoremap qf :FzfPreviewQuickFix<Cr>
nnoremap gs :FzfPreviewGitStatus<Cr>
nnoremap gb :FzfPreviewBuffers<Cr>
nnoremap gp :FzfPreviewProjectGrep<Space>

" ----------- neovim-lsp
lua << END
  require'nvim_lsp'.tsserver.setup{}
  require'nvim_lsp'.rust_analyzer.setup{}
  require'nvim_lsp'.gopls.setup{}
  require'nvim_lsp'.terraformls.setup{}
  require'nvim_lsp'.dockerls.setup{}
  require'nvim_lsp'.jsonls.setup{}
  require'nvim_lsp'.vimls.setup{}
END

MyAutocmd Filetype typescript setlocal omnifunc=v:lua.vim.lsp.omnifunc
MyAutocmd Filetype typescriptreact setlocal omnifunc=v:lua.vim.lsp.omnifunc
MyAutocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
MyAutocmd Filetype go setlocal omnifunc=v:lua.vim.lsp.omnifunc
MyAutocmd Filetype terraform setlocal omnifunc=v:lua.vim.lsp.omnifunc
MyAutocmd Filetype docker setlocal omnifunc=v:lua.vim.lsp.omnifunc
MyAutocmd Filetype json setlocal omnifunc=v:lua.vim.lsp.omnifunc
MyAutocmd Filetype vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>

" ----------- nvim-ipy
MyAutocmd FileType python nnoremap <Leader>i :call IPyRunCell()<Cr>

" ----------- vim-go
let g:go_fmt_command = "goimports"

" ----------- deoplate
let g:deoplete#enable_at_startup = 1

" ----------- vim-test
nmap <silent> tn :TestNearest<CR>
nmap <silent> tf :TestFile<CR>

" ----------- at-vim-coder
let g:at_vim_coder_workspace = '~/work/atcoder'
let g:at_vim_coder_template_file = '~/work/atcoder/template.cpp'

nmap <silent> ;t <Plug>(at-vim-coder-run-test)<Plug>(at-vim-coder-check-status)
nmap <silent> ;s <Plug>(at-vim-coder-submit)
