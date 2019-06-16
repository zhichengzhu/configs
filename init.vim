
let g:fb_kill_whitespace = 0
if filereadable($LOCAL_ADMIN_SCRIPTS . "/master.vimrc")
  source $LOCAL_ADMIN_SCRIPTS/master.vimrc
else
  source $ADMIN_SCRIPTS/master.vimrc
endif

source /home/engshare/admin/scripts/vim/biggrep.vim

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
" Initialize plugin system
Plug 'w0rp/ale'
" Plug 'vim-airline/vim-airline'
Plug 'iCyMind/NeoSolarized'
Plug 'jlanzarotta/bufexplorer'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'hhvm/vim-hack'
Plug 'flowtype/vim-flow', {
            \ 'autoload': {
            \     'filetypes': 'javascript'
            \ },
            \ 'build': {
            \     'mac': 'npm install -g flow-bin',
            \     'unix': 'npm install -g flow-bin'
            \ }}
" Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'kassio/neoterm'
Plug 'airblade/vim-gitgutter'
Plug 'aly006/a.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'roxma/vim-tmux-clipboard'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'yegappan/mru'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
Plug 'benmills/vimux'
Plug 'itchyny/lightline.vim'
call plug#end()

let g:VimuxHeight = "30"


let g:python3_host_prog='/usr/bin/python3'
" same for Python 2
let g:python_host_prog='/usr/bin/python2'

" Ale Config
" nmap <silent> <A-k> <Plug>(ale_previous_wrap)
" nmap <silent> <A-j> <Plug>(ale_next_wrap)
" nnoremap <silent> K :ALEHover<CR>
" nnoremap <silent> gd :sp \| ALEGoToDefinition \| res 20<CR> zz
" auto complete
let g:ale_linters = {'cpp': ['cquery'], 'c':['cquery'], 'cc':['cquery']}
" let g:ale_cpp_clangtidy_executable = "clang-tidy.par"
" let g:ale_fixers = {'cpp': ['clang-format']}
let g:ale_completion_enabled = 0
" Set this in your vimrc file to disabling highlighting
" let g:ale_set_highlights = 1
" always display the lint column
let g:ale_sign_column_always = 1
" enable airline
let g:airline#extensions#ale#enabled = 1
let g:ale_fix_on_save = 1
let g:ale_set_loclist = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_close_preview_on_insert = 1
let g:ale_fixers = {'python': ['isort', 'black']}
" let g:ale_cpp_clangtidy_checks = ['*']



autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler


let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'cocstatus'] ]
      \ },
      \ 'component_function':{
      \   'gitbranch': 'fugitive#head',
      \   'cocstatus': 'coc#status',
      \ },
      \ }


" Myles facebook's fuzzy finder
set rtp+=/usr/local/share/myc/vim
" Replace with a keybind you like
nmap <space>t :MYC<CR>

colorscheme NeoSolarized
set background=dark


set t_Co=256
" set termguicolors

set clipboard=unnamed


" set clipboard+=unnamedplus

" auto format python file when close
autocmd BufWritePost */mysql/mysql-fork/* silent! exec "!pushd ~/mysql/mysql-fork && git diff --no-color -U0 | clang-format-diff.py -i -p1" |:e
autocmd BufWritePost TARGETS silent! exec "!~/fbsource/tools/third-party/buildifier/run_buildifier.py -i %" |:e
" for window
set splitbelow


" auto format buck


" 5) better searches
set hlsearch
set incsearch
set ignorecase
set smartcase


" set relative line nu
set number
set relativenumber
augroup numbertoggle
autocmd!
autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

set mouse=a

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1


if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set updatetime=500
let g:lsp_preview_keep_focus=0

" coc config start
set hidden
let g:coc_node_path = expand("/data/users/$USER/fbsource/xplat/third-party/node/bin/node")

let g:coc_filetype_map = {'cc': 'cpp'}
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction


" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" coc config end
"


" ======================================remote-copy======================================
function! PbCopy() range
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\n")).'| pbcopy')
endfunction

function! KeyMapSetup()
  map <Space> <Leader>
  xnoremap <leader>rc <esc>:'<,'>call PbCopy()<CR>
  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  " show symbol outline
  nnoremap <silent> <leader>so :CocList outline <cr>
  nnoremap <silent> <leader>sf :echom CocAction('getCurrentFunctionSymbol')<cr>
  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy  <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " navigate by display lines
  noremap j gj
  noremap k gk

  " navigate window easily
  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l
  " \ d is for delete
  nnoremap <leader>d ""d
  vnoremap <leader>d ""d
  xnoremap <leader>p ""dP

  nnoremap d "_d
  vnoremap d "_d
  xnoremap p "_dP

   " Prompt for a command to run
  map <leader>vr :VimuxPromptCommand<CR>

  " Run last command executed by VimuxRunCommand
  map <leader>vl :VimuxRunLastCommand<CR>

  " Zoom the runner pane (use <bind-key> z to restore runner pane)
  map <leader>vz :call VimuxZoomRunner()<CR>

  " Inspect runner pane
  map <leader>vi :VimuxInspectRunner<CR>

  " Interrupt any command running in the runner pane map
  map <Leader>vc :VimuxInterruptRunner<CR>

  " fzf buffer search
  nnoremap <space>b :Buffers<CR>
  nnoremap <space>g :Rg<space>
  nnoremap <space>h :History<CR>
  nnoremap <space>o :Files<CR>

  " paste over without override register
  xnoremap p pgvy

  " natural copy
  nnoremap p P<cr>
  nnoremap P p<cr>

  " Toggele Nerd Tree
  map <space>n :NERDTreeToggle<CR>
endfunction
call KeyMapSetup()
