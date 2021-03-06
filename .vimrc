" my .vimrc file: Paul Cochrane
" originally from Bram Moolenaar <Bram@vim.org> as part of vim

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup              " keep a backup file
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set softtabstop=4
set shiftwidth=4
set textwidth=76
set scrolloff=10        " always see the top or bottom 10 lines in the window
set number              " use line numbers
set winheight=40        " focussed windows in splits have this height

" stop folds from occuring
set nofoldenable

" map the leader key to comma (copied from Gary Bernhardt's .vimrc)
let mapleader=","

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" cursor highlighting
set cursorline          " highlight current line
" highlight the background "sort of grey", i.e. Black (which isn't actually
" black when using the gnome colours in Terminator)
highlight CursorLine ctermbg=Black cterm=none

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

    augroup END

    " html files shouldn't use tabs; they should use a 2-space indent
    autocmd BufRead,BufNewFile *.html set expandtab shiftwidth=2 softtabstop=2
    " tmpl files are also html files
    autocmd BufRead,BufNewFile *.tmpl set expandtab shiftwidth=2 softtabstop=2 ft=html
    " tt files are also html files
    autocmd BufRead,BufNewFile *.tt set expandtab shiftwidth=2 softtabstop=2 ft=html

    " Haskell files shouldn't use tabs
    autocmd BufRead,BufNewFile *.hs set expandtab shiftwidth=4 softtabstop=4 ft=haskell

    " ruby files shouldn't use tabs; they use a 2-space indent
    autocmd BufRead,BufNewFile *.rb set expandtab shiftwidth=2 softtabstop=2
    autocmd BufRead,BufNewFile *.gemspec set expandtab shiftwidth=2 softtabstop=2

    " This makes sure that .part files are treated as if they were html
    autocmd BufRead,BufNewFile *.part set ft=html

    " recognise .t as being perl files
    autocmd BufRead,BufNewFile *.t set ft=perl expandtab shiftwidth=4 softtabstop=4
    " recognise .pmc and .ops as being C files
    autocmd BufRead,BufNewFile *.pmc set ft=c
    autocmd BufRead,BufNewFile *.ops set ft=c
    " recognise .inc as being Fortran files
    autocmd BufRead,BufNewFile *.i set ft=fortran
    autocmd BufRead,BufNewFile *.inc set ft=fortran
    " recognise .runfile as being ini files
    autocmd BufRead,BufNewFile *.runfile set ft=dosini
    " recognise .cls as being TeX files
    autocmd BufRead,BufNewFile *.cls set ft=tex
    " recognise .md as being MarkDown format
    autocmd BufRead,BufNewFile *.md set ft=markdown

else

    set autoindent              " always set autoindenting on

endif " has("autocmd")

" running make
map <leader>m :call RunMake('')<cr>
map <leader>M :call RunMake('clean')<cr>

function! RunMake(cleanoption)
    if a:cleanoption == 'clean'
        exec ":!make clean && make"
    else
        exec ":!make"
    endif
endfunction

" swap two words (from
" http://www.reddit.com/r/vim/comments/2772n9/nonprogrammers_your_best_tips_tricks/)
nnoremap <leader>xp dawwP

" indent a paragraph
nnoremap <leader>q gqip

" use New Zealand English and German by default
set spelllang=en_nz,de

" expand %% to path of active buffer (i.e. %:h<Tab>)
" from Practical Vim; Drew Neil
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" extend dot command to visual mode
" from Drew Neil
xnoremap . :norm.<CR>

" multipurpose tab key
" indent if we're at the beginning of a line. else, do completion.
" adapted from Gary Bernhardt's .vimrc
function! InsertTabWrapper()
    let col = col('.') - 1
    " if we're at the start of a line or there is only whitespace up until
    " the column just before the cursor position, add a tab
    if !col || getline('.')[0:col-1] !~ '\w'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" map indent the entire file with <leader>I
nnoremap <leader>I gg<C-V>G=

" vim: expandtab shiftwidth=4
