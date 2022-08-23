" vim-plug
" :PlugInstall to install the plugins
" :PlugUpdate to update them
" :PlugClean will remove unused plugins
" :PlugUpgrade will update vim-plug
call plug#begin('~/.vim_plugins')
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/syntastic'
Plug 'sjl/gundo.vim'
Plug 'tsaleh/vim-align'
Plug 'tpope/vim-pathogen'
Plug 'tpope/vim-git'
Plug 'vim-scripts/taglist.vim'
Plug 'rodjek/vim-puppet'
Plug 'godlygeek/tabular'
Plug 'scrooloose/nerdtree'
call plug#end()

set rtp+=~/.vim_plugins/powerline/powerline/bindings/vim

" Custom Functions
if !exists("MyFuncLoad")
  let MyFuncLoad=1

  " customize status line
  function! SetStatusLineStyle()
    let &stl="%F%m%r%h%w\ [%{&ff}]\ [%Y]\ %P\ %=[a=\%03.3b]\ [h=\%02.2B]\ [%l,%v]"
  endfunc
endif


" Setup
set nocompatible                  " turn off vi compatiblity. first. always.
set modeline                      " enable modelines
set tags=tags;/                   " search recursively for tags
set ttyfast                       " fast terminal
set undolevels=5000               " lots of undos (default: 1000)
set updatecount=50                " switch every 50 chars (default: 200)
set whichwrap+=b,s,<,>,h,l,[,]    " wrap on more (default: b,s)
set nowrap                        " don't wrap long lines
set autoindent                    " indent sanely
set smartindent

set autoread                      " watch for changes
set backspace=indent,eol,start    " back over anything
set backup                        " keep a backup file
set cmdheight=1                   " cmd line (default: 1)
set complete=.,w,b,u,U,t,i,d      " lots of tab complete goodness
set nocursorline                  " never show a cursor line
set history=3000                  " keep more cmd line history (default: 20)
set keywordprg=TERM=mostlike\ man\ -s\ -Pless " (default man -s)
set laststatus=2                  " always show status line
set lazyredraw                    " don't redraw when don't have to
set magic                         " Enable the magic
set noautowrite                   " don't automagically write on :next
set noerrorbells visualbell t_vb= " Disable ALL bells
set nohidden                      " close the buffer when I close a tab (I use tabs more than buffers)
set nospell                       " no spelling by default
set swapfile                      " use a swapfile
set tabstop=2                     " nice tabs
set shiftwidth=2                  " nice tabs, please?
set softtabstop=2                 " delete expanded tabs with a single keystroke
set smarttab                      " use shiftwidth not tabstop at the beginning of a line
set expandtab                     " tabs become spaces
set scrolloff=5                   " show a few lines above/below cursor
set number                        " line numbers
set showcmd                       " show the cmd i'm typing
set showfulltag                   " show full completion tags
set ruler                         " tell me where i am
set showmode                      " always show mode (default: on)
set sidescroll=2                  " if wrap is off, this is fasster for horizontal scrolling
set sidescrolloff=5               " keep at least 5 lines left/right
set splitright splitbelow         " split out of the way
set winheight=2                   " more room if possible (default: 1)
set winminheight=0                " smash windows done to the status line (default: 1)
set equalalways                   " keep windows the same size
set switchbuf=usetab              " tabs rock
set tabpagemax=30                 " max out at 30 tabs (increase at own risk)
set showtabline=1                 " 2 always, 1 only if multiple tabs - 2 causes flickering in powerline.
set showmatch                     " show matching bracket
set incsearch                     " search while typing
set ignorecase                    " default to case-insensitive search
set smartcase                     " case-sensitive when needed
set hlsearch                      " highlight matching search terms
"set cursorcolumn                  " highlight the current column that the cursor is on
"set cursorline                    " highlight the current line that the cursor is on
set foldenable                    " enable folding
set foldlevel=20
set foldlevelstart=20
set foldmethod=syntax

" create .state directory, readable by the group.
silent execute '!(umask 027; mkdir -p ~/.vim/state)'

" buffers
if has('persistent_undo')
  set undodir=~/.vim/state
  set undofile
endif

" backups
set backupdir=~/.vim/state
set directory=~/.vim/state

" statusline
if has('statusline')
  call SetStatusLineStyle()
endif

" Init Pathogen (https://github.com/tpope/vim-pathogen)
if has('pathogen')
  runtime bundle/vim-pathogen/autoload/pathogen.vim
  call pathogen#helptags()
  call pathogen#infect()
  syntax on
  "filetype plugin indent on
endif

" Crontab
au FileType crontab set nobackup nowritebackup

" Visual Tweaks
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme my-custom-solarized

" indentLine
let g:indentLine_char = '│'

" 80 column vertical bar
set colorcolumn=81
highlight ColorColumn ctermfg=none ctermbg=235

" Highlight current line and column to more easily find the cursor
highlight CursorColumn cterm=NONE ctermbg=235 guibg=#262626
highlight CursorLine   cterm=NONE ctermbg=235 guibg=#262626
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" Search color highlights
highlight Search cterm=none ctermfg=white ctermbg=27

" syntastic
"let g:syntastic_check_on_open=1
let g:syntastic_python_checkers=['gpylint']
nmap <LocalLeader>s :SyntasticCheck<CR>

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_min_count = 2

" menu
set wildmenu
set wildmode=longest:full,full
set wildignore=*.o,*.obj*.bak,*.so,*.exe
set cpo-=<
set wcm=<C-Z>
map <F4> :emenu <C-Z>

" gundo
nnoremap <F3> :GundoToggle<CR>

" NERDTree
let NERDChristmasTree = 1
nnoremap <silent> <F2> :NERDTreeToggle<CR>
"autocmd vimenter * if !argc() | NERDTree | endif
autocmd FileType nerdtree setlocal nolist
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" set unicode support if possible
if &termencoding == ""
  let &termencoding = &encoding
endif
scriptencoding utf-8
" renable these to default to utf8 for new files
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1

" Show invisibles (whitespace, etc)
set listchars=tab:»\ ,trail:·,extends:…
set list


" Maps
map <silent> <LocalLeader>ri G=gg<CR> " Reindent file
map <silent> <LocalLeader>Cs :%s/\s\+$//e<CR> " Clear spaces at end of line
nmap <LocalLeader>pm :set number!<CR>:set list!<CR>:set paste!<CR>:silent! IndentLinesToggle<CR> " Toggle paste mode
nmap <LocalLeader>ww :set wrap!<CR>
nmap <LocalLeader>wo :set wrap<CR>
map <LocalLeader>tc :tabnew %<CR>                " New tab
map <LocalLeader>tk :tabclose<CR>                " Close tab
map <LocalLeader>tn :tabnext<CR>                 " Next tab
map <LocalLeader>tp :tabprev<CR>                 " Previous tab
nmap F zf%                                       " Fold with paren begin/end matching
map <LocalLeader>hl :set hlsearch! hlsearch?<CR> " Toggle highlighted search
command WQ wq
command Wq wq
command Q q!

" Commands
if has('autocmd')
  if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    " Buffer Autocommands
    autocmd BufWritePre *.cpp,*.hpp,*.i :call StripTrailingWhitespace()

    " Improve legibility
    au BufRead quickfix setlocal nobuflisted wrap number

    " Save backupfile as backupdir/filename-06-13-1331
    au BufWritePre * let &bex = strftime("-%m-%d-%H%M")

    au BufRead /etc/apache/* setlocal filetype=apache2
    au BufRead *.sh,*.cron,*.bash setlocal filetype=sh
    au BufRead *.vim,vimrc setlocal filetype=vim
    au BufRead *.c,*.h setlocal filetype=c
    au BufRead syslog-ng.conf setlocal filetype=syslog-ng
    au BufRead *.erb setlocal indentexpr= " disable auto indent
    au BufRead *.eyaml setlocal filetype=yaml
    au BufRead *.go setlocal filetype=go
    au BufRead *.pp setlocal filetype=puppet
    au BufRead *.plist setlocal noexpandtab
    au BufRead *.plist.erb setlocal noexpandtab

    au BufRead quickfix setlocal nobuflisted wrap number

    au BufWinLeave *.sh,*.conf,*.vim,vimrc,*.c,*.txt mkview
    au BufWinEnter *.sh,*.conf,*.vim,vimrc,*.c,*.txt silent loadview

    " When editing a file, always jump to the last known cursor position. Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim). Also don't do it when the mark is in the first line, that is the default position when opening a file.
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    autocmd BufWinLeave * call clearmatches()

    " Turn on omni-completion for the appropriate file types.
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType c set omnifunc=ccomplete#Complete
    autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
    autocmd FileType ruby,eruby let g:rubycomplete_rails = 1  " Rails support
    autocmd FileType go,java setlocal noexpandtab
    autocmd FileType go set colorcolumn=100
    autocmd FileType puppet set colorcolumn=0

    " Convenient command to see the difference between the current buffer and the
    " file it was loaded from, thus the changes you made.  Only define it when not defined already.
    if !exists(":DiffOrig")
      command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
      nnoremap <Leader>d :DiffOrig<CR>
    endif
  endif
endif
