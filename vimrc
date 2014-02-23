" Custom Functions
if !exists("MyFuncLoad")
  let MyFuncLoad=1

  " customize status line
  function! SetStatusLineStyle()
    let &stl="%F%m%r%h%w\ [%{&ff}]\ [%Y]\ %P\ %=[a=\%03.3b]\ [h=\%02.2B]\ [%l,%v]"
  endfunc

  " toggle columns on demand
  function FoldToggle()
    if &foldenable
      set nofoldenable
      set foldcolumn=0
    else
      set foldenable
      set foldcolumn=2
    endif
  endfunction

  function! NamedUpdateSoa(date, num)
    if (strftime("%Y%m%d") == a:date)
      return a:date . a:num+1
    endif
    return strftime("%Y%m%d") . '00'
  endfunction

  command NamedSoa :%s/\(2[0-9]\{7}\)\([0-9]\{2}\)\(\s*;\s*Serial\)/\=NamedUpdateSoa(submatch(1), submatch(2)) . submatch(3)/gc
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
set autoindent smartindent        " indent sanely
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
set tabstop=8                     " nice tabs
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
set showtabline=2                 " 2 always, 1 only if multiple tabs
set commentstring=\ #\ %s         " default to shell comments, not C
set showmatch                     " show matching bracket
set incsearch                     " search while typing
set ignorecase                    " default to case-insensitive search
set smartcase                     " case-sensitive when needed
set hlsearch                      " highlight matching search terms
set cursorcolumn                  " highlight the current column that the cursor is on
set cursorline                    " highlight the current line that the cursor is on
set foldenable
set foldcolumn=2
set foldminlines=2

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
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#helptags()
call pathogen#infect()
syntax on
filetype plugin indent on

" Crontab
au FileType crontab set nobackup nowritebackup

" Visual Tweaks
set t_Co=256
colorscheme solarized
set background=dark

let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

" 80 column vertical bar
set colorcolumn=81
highlight ColorColumn ctermfg=none ctermbg=235

" Highlight current line and column to more easily find the cursor
highlight CursorColumn cterm=NONE ctermbg=235 ctermfg=none guibg=235 guifg=none
highlight CursorLine   cterm=NONE ctermbg=235 ctermfg=none guibg=235 guifg=none
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" Search color highlights
highlight Search cterm=none ctermfg=white ctermbg=27

" syntastic
"let g:syntastic_check_on_open=1
let g:syntastic_python_checkers=['gpylint']
nmap <LocalLeader>s :SyntasticCheck<CR>

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
autocmd vimenter * if !argc() | NERDTree | endif
autocmd FileType nerdtree setlocal nolist
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" set unicode support if possible
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  scriptencoding utf-8
  " renable these to default to utf8 for new files
  set encoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

" Show invisibles (whitespace, EOL, etc)
if has("multi_byte") || (&termencoding == "utf-8")
  set listchars=tab:»\ ,trail:·,extends:…,eol:¬
  if v:version >= 700
    let &showbreak='->  '
  endif
endif
set list


" Maps
map <silent> <LocalLeader>ri G=gg<CR> " Reindent file
map <silent> <LocalLeader>Cs :%s/\s\+$//e<CR> " Clear spaces at end of line
nmap <LocalLeader>pm :set nonumber! nolist! paste!<bar>call FoldToggle()<CR> " Toggle paste mode
nmap <LocalLeader>ww :set wrap!<CR>
nmap <LocalLeader>wo :set wrap<CR>
map <LocalLeader>tc :tabnew %<CR>                " New tab
map <LocalLeader>tk :tabclose<CR>                " Close tab
map <LocalLeader>tn :tabnext<CR>                 " Next tab
map <LocalLeader>tp :tabprev<CR>                 " Previous tab
nmap F zf%                                       " Fold with paren begin/end matching
map <LocalLeader>hl :set hlsearch! hlsearch?<CR> " Toggle highlighted search


" Commands
if has('autocmd')
  if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    " Buffer Autocommands
    autocmd BufWritePre *.cpp,*.hpp,*.i :call StripTrailingWhitespace()

    augroup vimrc
      au BufReadPre * setlocal foldmethod=indent
      au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
    augroup END

    " Improve legibility
    au BufRead quickfix setlocal nobuflisted wrap number

    " Save backupfile as backupdir/filename-06-13-1331
    au BufWritePre * let &bex = strftime("-%m-%d-%H%M")

    au BufRead /etc/apache/* setlocal filetype=apache2
    au BufRead *.sh,*.cron,*.bash setlocal filetype=sh
    au BufRead *.vim,vimrc setlocal filetype=vim
    au BufRead *.c,*.h setlocal filetype=c
    au BufRead syslog-ng.conf setlocal filetype=syslog-ng

    au BufRead quickfix setlocal nobuflisted wrap number

    au BufWinLeave *.sh,*.conf,*.vim,vimrc,*.c,*.txt mkview
    au BufWinEnter *.sh,*.conf,*.vim,vimrc,*.c,*.txt silent loadview

    " When editing a file, always jump to the last known cursor position. Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim). Also don't do it when the mark is in the first line, that is the default position when opening a file.
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    autocmd BufWinLeave * call clearmatches()

    " FileType Autocommands "{{{2
    au FileType vim setlocal commentstring"%s

    " For all text files set 'textwidth' to 80 characters.
    au FileType text setlocal textwidth=80

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
    autocmd FileType java setlocal noexpandtab " don't expand tabs to spaces for Java

    " Convenient command to see the difference between the current buffer and the
    " file it was loaded from, thus the changes you made.  Only define it when not defined already.
    if !exists(":DiffOrig")
      command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
      nnoremap <Leader>d :DiffOrig<CR>
    endif

    " Better folding
    au BufRead * if line('$') > (&lines * 2000) | set foldlevel=99 | endif

    " Git autocommit
    autocmd BufWritePost * let message = input('Message? ', 'Auto-commit: saved ' . expand('%')) | execute ':silent ! if git rev-parse --git-dir > /dev/null 2>&1 ; then git add % ; git commit -m ' . shellescape(message, 1) . '; fi > /dev/null 2>&1'
  endif
endif
