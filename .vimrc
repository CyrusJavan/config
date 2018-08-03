" Vimscript file settings ---------------------- {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Vundle Plugins ---------------------- {{{
set nocompatible              " be iMproved, required
filetype off                  " required
"" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'octol/vim-cpp-enhanced-highlight' "Highlights c++ characters
"Plugin 'git://git.wincent.com/command-t.git' " Fuzzy finder for faster searching
Plugin 'sjl/badwolf' " Really nice colorscheme
Plugin 'flazz/vim-colorschemes' " Stores all available colorschemes
call vundle#end()            " required
filetype plugin indent on    " required
"" }}}

" Generic Vim Settings ---------------------- {{{
"
" Indents to format for corresponding filetype
syntax enable
" Indents to format for corresponding filetype
filetype indent on

set statusline+=%f " Show the relative path at all times, mainly to see the filename
set laststatus=2 " Make sure the status line is always visible
set showcmd " Shows the command that was typed in
set tabstop=2 shiftwidth=2 expandtab " Set tabs to to spaces.
set showmatch "Matches the corresponding open or closing bracket
set wildmenu " Provides options for autocompletion
set incsearch " Automatically starts searching for characters
set hlsearch " Lets you see the items you've searched
set ignorecase " Vim Automatically searches case insensitive
set splitright " Moves new vim windows to the right
set splitbelow " Moves new horizantal windows to the bottom
set cindent " Allows cindentation
set nostartofline " Doesn't move to the beginning on big jumps
set cinoptions+=g0 " prevents private and public from being autotabbed
" This sets formatting so that function arguements align when on next line
set cinoptions+=(0 
" No namespace indenting
set cinoptions+=N-s
" This sets class inheritence to be after the ":"
"set cinoptions+=i0
set number relativenumber " Makes it so you can see the line numbers
set autochdir " Automatically make the open buffer the curr directory
set autoread

" By default keep all files unfolded and focuses on the last line selected
autocmd BufRead * normal zRzz
" This is super cool, removes relative number on entry
autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
" }}}

" Vim Colorscheme Settings ---------------------- {{{
set t_Co=256 " Allows for vim to support colorschemes in putty
"set t_BE=
colorscheme badwolf
let g:badwolf_tabline=0
let g:badwolf_darkgutter=0
set colorcolumn=110
" }}}

" Vim Shortcuts ---------------------- {{{ 

" Throw the training wheels in the garbage
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
"Maybe take the front wheel off too
"noremap h <NOP>
"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>

" Set local leader to space
let mapleader="\\"
map <space> \

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Escapes instead of using escape key
"inoremap jk <Esc>
inoremap ` <Esc>
imap <S-Space> <Esc>
nmap <S-Space> i
" Quit application with <C-Q>
noremap <silent> <C-Q> :q<CR>
vnoremap <silent> <C-Q> <C-C>:q<CR>
inoremap <silent> <C-Q> <C-O>:q<CR>

" Save application with good old <C-S>
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O> <ESC>:update<CR>

" Clear searches
nnoremap <leader><space> :nohlsearch <CR>

" Jump to beginning of line
nnoremap H ^
vnoremap H ^

" Jump to end of line
"nnoremap L $
"vnoremap L $

" Prevent upper case K from doing lookups
nnoremap K <nop>
vnoremap K <nop>

""" Copy and paste shortcuts """
""" Automagically format my paste.
"noremap p ]p
"noremap P ]P

vnoremap <C-c> "+y
vnoremap <C-x> "+d

inoremap <C-a> <ESC>"+pa
vnoremap <C-a> "+]P
nnoremap <C-a> "+]P

" Change word to upper case
inoremap <C-u> <ESC>bveUea

""" Open file explorer in new window
noremap  <silent> <C-o> :call P4Open()<CR>

""" Movement commands. Move to in parenthsis
onoremap np :<c-u>normal! f(vi(<cr>
onoremap lp :<c-u>normal! F(vi(<cr>

""" Format inside of a block of curlies
nnoremap <leader>f mzvi{='zzz
""" Format the entire document and clear out trailing white space.
nnoremap <leader>F mzggvG='zzz

""" Clear the white space from a file
nnoremap <leader>cw mz:%s/\s\+$//g<cr>'zzz

""" Clear out trailing white space """
"nnoremap <leader>cw mz:%s/\s\+$//g<cr>'zzz

""" C language only. Change function arguements
""" Normall upper case indicates going to last, however it is unlinkely that
""" you will be searching forward. Usually you will be in the function of
""" interest
onoremap Fa :<c-u>execute "normal! /^\\(\\(::\\)\\=\\w\\+\\(\\s\\+\\)\\=\\)\\{2,}([^!@#$+%^]*)\r:nohlsearch\rf(vi("<cr>
onoremap fa :<c-u>execute "normal! ?^\\(\\(::\\)\\=\\w\\+\\(\\s\\+\\)\\=\\)\\{2,}([^!@#$+%^]*)\r:nohlsearch\rf(vi("<cr>

""" Remap auto complete to Ctrl-Space
if has("gui_running")
" Gvim accepts ctrl space
  inoremap <c-space> <c-p>
else
" Regular Vims treats c-space as nul
  inoremap <Nul> <c-p>
endif
" }}}
"
" User Functions ---------------------- {{{
" Most of the functions I write will be defined here. Consider ,vimrc my header
"so ~/.vim/iroPlugin.vim

" Jump to line center
nnoremap gm :call LineCenter() <CR>

" Commands from external plugins
"
" Toggle NERDtree for file finding
nnoremap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeQuitOnOpen=1

" Brazenly stolen from CurineIncSw. Slight modifications made so that
" switching filles when not found doesn't crash. Original can be found here:
" Plugin 'ericcurtin/CurtineIncSw.vim' " Let's you switch files
function! FindInc()
  let dirname=fnamemodify(expand("%:p"), ":h")
  let cmd="find . " . dirname . " -type f -iname " . t:IncSw . " | head -n1 | tr -d '\n'"

  let findRes=system(cmd)
  if &mod == 1
    echo "ERROR: FILE HAS BEEN MODIFIED, PLEASE SAVE OR DISCARD TO CONTINUE"
  else
    exe "e " findRes
  endif
endfun

function! CurtineIncSw()
  if match(expand("%"), '\.c') > 0
    let t:IncSw=substitute(expand("%:t"), '\.c\(.*\)', '.h*', "")
    call FindInc()
  elseif match(expand("%"), "\\.h") > 0
    let t:IncSw=substitute(expand("%:t"), '\.h\(.*\)', '.c*', "")
    call FindInc()
  else 
    echo "No Matching c/h file found"
  endif

endfun

" Switch cpp and h file
noremap <C-h> :call CurtineIncSw()<CR>
" }}}

" Open the netrw file explorer
" <C-f> because it is like trying to find something
noremap <C-f> :Explore<CR>

" Qt indentation function ---------------------- {{{
function! QtCppIndent()
" Patterns used to recognise labels and search for the start
" of declarations
let labelpat='signals:\|slots:\|public:\|protected:\|private:\|Q_OBJECT'
let declpat='\(;\|{\|}\)\_s*.'
" If the line is a label, it's a no brainer
if match(getline(v:lnum),labelpat) != -1
  return 0
endif
" If the line starts with a closing brace, it's also easy: use cindent
if match(getline(v:lnum),'^\s*}') != -1
  return cindent(v:lnum)
endif
" Save cursor position and move to the line we're indenting
let pos=getpos('.')
call setpos('.',[0,v:lnum,1,0])
" Find the beginning of the previous declaration (this is what
" cindent will mimic)
call search(declpat,'beW',v:lnum>10?v:lnum-10:0)
let prevlnum = line('.')
" Find the beginning of the next declaration after that (this may
" just get us back where we started)
call search(declpat,'eW',v:lnum<=line('$')-10?v:lnum+10:0)
let nextlnum = line('.')
" Restore the cursor position
call setpos('.',pos)
" If we're not after a label, cindent will do the right thing
if match(getline(prevlnum),labelpat)==-1
  return cindent(v:lnum)
" It will also do the right thing if we're in the middle of a
" declaration; this occurs when we are neither at the beginning of
" the next declaration after the label, nor on the (non-blank) line
" directly following the label
elseif nextlnum != v:lnum && prevlnum != prevnonblank(v:lnum-1)
  return cindent(v:lnum)
endif
" Otherwise we adjust so the beginning of the declaration is one
" shiftwidth in
return &shiftwidth
endfunc

autocmd BufRead *.h :setlocal indentexpr=QtCppIndent()


" }}}


