set t_Co=256
set nocompatible
set number
set ruler
syntax on
set encoding=utf-8
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
" set list listchars=tab:\ \ ,trail:·
set hlsearch
set incsearch
set ignorecase
set smartcase
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*
set laststatus=2
" set cul
set autoindent

set wrap
set linebreak
set nolist  " list disables linebreak

let g:molokai_original=0

" make rvm happy
set shell=/bin/sh

augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END


" rvm ruby configuration
" let g:ruby_path="/Users/metalelf0/.rvm/bin/ruby"

" Show (partial) command in the status line
set showcmd

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Include user's local vim config
if filereadable(expand("~/Dropbox/vim.local/macros.rc"))
  source ~/Dropbox/vim.local/macros.rc
endif

function! NeatFoldText() "{{{2
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()
" }}}2

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" make uses real tabs
au FileType make set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

" double tap esc to clear highlighting after search
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" :w!! saves a file as root
cmap w!! w !sudo tee % >/dev/null
cmap W call RetabAndSave()

function! RetabAndSave()
  %s/\s\+$//e
  retab
  w
endfunction

function! DeleteRubyComments()
  g/#.*$/d
endfunction

nmap <silent> <Leader>dc call DeleteRubyComments()


" Use modeline overrides
set modeline
set modelines=10

" Directories for swp files
set backupdir=~/.vim_backup
set directory=~/.vim_backup

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" plugin configuration {{{1

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
map <Leader><Leader> :NERDTreeToggle<CR>
map <Leader>f :NERDTreeFind<CR>

" NERDCommenter configuration
" add extra spaces around delimiters
let NERDSpaceDelims=1

let g:vroom_detect_spec_helper=1

function! VroomUseRspec1x()
  let g:vroom_rspec_version="1.x"
  let g:vroom_spec_command="spec "
endfunction

function! VroomUseRspec2x()
  let g:vroom_rspec_version="2.x"
  let g:vroom_spec_command="rspec "
endfunction

" gist-vim defaults
if has("mac")
  let g:gist_clip_command = 'pbcopy'
elseif has("unix")
  let g:gist_clip_command = 'xclip -selection clipboard'
endif
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" "" YouCompleteMe
" let g:ycm_key_list_previous_completion=['<Up>']

"" Ultisnips
let g:UltiSnipsExpandTrigger="<c-tab>"
let g:UltiSnipsListSnippets="<c-s-tab>"
" }}}1

"" Github flavoured markdown
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" CTags
noremap <Leader>rt :!ctags --extra=+f -R *<CR><CR>
noremap <C-\> :tnext<CR>

" pomodoro.vim
let g:pomodoro_time_work = 25
let g:pomodoro_time_slack = 5
let g:pomodoro_do_log = 1
let g:pomodoro_log_file = "/Users/metalelf0/Documents/pomodoro_log.txt"

" http://stackoverflow.com/questions/5375240/a-more-useful-statusline-in-vim
" http://got-ravings.blogspot.it/2008/08/vim-pr0n-making-statuslines-that-own.html

    " set statusline=
    " set statusline +=%#Identifier#\ %n\ %*                  " buffer number
    " set statusline +=%#PreProc#%{&ff}%*                     " file format
    " set statusline +=%#Number#%y%*                          " file type
    " set statusline +=%#String#\ %<%t%*                      " full path
    " set statusline +=%#SpecialKey#%m%*                      " modified flag
    " set statusline +=%#Identifier#\ %{PomodoroStatus()}\ %* " pomodoro status
    " set statusline +=%=%*                                   " padding
    " set statusline +=%#Identifier#%5l%*                     " current line
    " set statusline +=%#SpecialKey#/%L%*                     " total lines
    " set statusline +=%#Identifier#%4v\ %*                   " virtual column number
    " set statusline +=%#SpecialKey#0x%04B\ %*                " character under cursor

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" -k means 'only filetypes known to ACK'
"  if something is missing, look into ack --help-types
let g:ackprg='/usr/local/bin/ack -H --nocolor --nogroup --column'

let @l='Hilet(:WbEa)f=r{A }jH'

let g:ctrlp_working_path_mode = 'ra'

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

 " let Vundle manage Vundle
 " required!
  Bundle 'gmarik/vundle'
  " Bundle 'ervandew/supertab.git'
  " Bundle 'Valloric/YouCompleteMe'
  Bundle 'julienXX/Hemisu'
  Bundle 'metalelf0/Smyck-Color-Scheme.git'
  Bundle 'metalelf0/vimt0d0.git'
  Bundle 'mileszs/ack.vim.git'
  Bundle 'scrooloose/nerdcommenter.git'
  Bundle 'scrooloose/nerdtree.git'
  Bundle 'scrooloose/syntastic.git'
  Bundle 'tpope/vim-fugitive.git'
  Bundle 'tpope/vim-markdown.git'
  Bundle 'tpope/vim-rails.git'
  Bundle 'tpope/vim-surround.git'
  Bundle 'tpope/vim-dispatch'
  Bundle 'tpope/vim-rvm'
  " Bundle 'vim-ruby/vim-ruby.git'
  Bundle 'vim-scripts/blackboard.vim'
  Bundle 'chriskempson/base16-vim'
  Bundle 'mattn/gist-vim'
  Bundle 'vim-scripts/Align'
  Bundle 'vim-scripts/bufexplorer.zip'
  Bundle 'vim-scripts/vim-indent-object'
  Bundle 'vim-scripts/LustyJuggler'
  Bundle 'vim-scripts/mayansmoke'
  Bundle 'jaromero/vim-monokai-refined'
  Bundle 'dhruvasagar/vim-railscasts-theme'
  Bundle 'molok/vim-vombato-colorscheme'
  Bundle 'ujihisa/tabpagecolorscheme'
  Bundle 'rking/vim-ruby-refactoring'
  Bundle 'skwp/vim-rspec'
  Bundle 'kien/ctrlp.vim'
  Bundle 'skalnik/vim-vroom'
  Bundle 'Valloric/vim-valloric-colorscheme'
  Bundle 'kchmck/vim-coffee-script'
  Bundle 'pydave/AsyncCommand'
  Bundle 'metalelf0/vim-pomodoro'
  Bundle 'Pychimp/vim-luna'
  Bundle 'jtratner/vim-flavored-markdown'
  Bundle "merlinrebrovic/focus.vim"
  Bundle 't9md/vim-ruby-xmpfilter'
  " Bundle 'Shougo/unite.vim'
  " Bundle 'Shougo/vimproc.vim'

" focus.vim configuration
nmap <Leader>o <Plug>FocusModeToggle
let t:focus_fillchars="."
let g:focusmode_width = 72


" drastic remaps!
noremap H ^
noremap L $
inoremap kj <Esc>

" macbook remaps!
nnoremap <D-Right> :tabnext<CR>
nnoremap <D-Left>  :tabprevious<CR>

" xmpfilter
map <Leader>xa <Plug>(xmpfilter-mark)
map <Leader>xr <Plug>(xmpfilter-run)

nnoremap <D-Up> :bn<CR>
nnoremap <D-Down> :bp<CR>

" " Unite.vim
" nnoremap <C-p> :<C-u>Unite -start-insert file_rec/async:!<CR>
" nnoremap <space>/ :Unite grep:.<CR>
" nnoremap <space>s :Unite -quick-match buffer<CR>

 filetype plugin indent on     " required!
 set foldlevelstart=20

" map <Esc>a :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Extra vimrc {{{
let s:extrarc = expand($HOME . '/.vim/passwords.vim')
if filereadable(s:extrarc)
    exec ':so ' . s:extrarc
endif
" }}}
