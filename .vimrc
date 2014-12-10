" Sample .vimrc file by Martin Brochhaus
" Presented at PyCon APAC 2012

set nocompatible		" 设成vim模式 而不是vi 否则很多特性会默认disable

set fileencodings=utf-8,gbk,ucs-bom,cp936
set fileencoding=gbk
set encoding=utf8


" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %


" Better copy & paste
" When you want to paste large blocks of code into vim, press F2 before you
" paste. At the bottom you should see ``-- INSERT (paste) --``.

set pastetoggle=<F2>
set clipboard=unnamed


" Mouse and backspace
" enable mouse. When the mouse is not enabled, the GUI will still use the mouse for modeless selection. This doesn't move the text cursor.
set mouse=a
" make backspace behave like normal again
set bs=2


" Rebind <Leader> key
" I like to have it here becuase it is easier to reach than the default and
" it is next to ``m`` and ``n`` which I use for navigating between tabs.
let mapleader = ";"


" Bind nohl
" Removes highlight of your last search
" ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
noremap <C-n> :nohl<CR>
vnoremap <C-n> <Esc>:nohl<CR>
inoremap <C-n> <Esc>:nohl<CR>


" Quicksave command
" Like ":write", but only write when the buffer has been modified.  {not in Vi}
noremap <Leader>s :update<CR>
noremap <Leader>ss :update!<CR>
vnoremap <Leader>s <C-C>:update<CR>
inoremap <Leader>s <C-O>:update<CR>
noremap <Leader>S :wa<CR>
vnoremap <Leader>S <C-C>:wa<CR>
inoremap <Leader>S <C-O>:wa<CR>



" Quick quit command
" noremap <Leader>q :quit<CR>  " Quit current window
" this sucks! I frequently use caps+p in my project to debug.
" and this will let me to close without saving when the caps is on.
" noremap <Leader>Q :qa!<CR>   " Quit all windows
nnoremap zz :wa<cr>:mksession! ~/.vim_session<cr>:qa<cr>
au VimEnter * call VimEnter()
function! VimEnter()
	if argc() == 0
		exe "source "."~/.vim_session"
	endif
endfunction


" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h


" easier moving between tabs
map <c-left> <esc>:tabprevious<CR>
map <c-right> <esc>:tabnext<CR>


" map sort function to a key
vnoremap <Leader>a :sort<CR>


" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap <s-tab> <gv  " better indentation
vnoremap <tab> >gv  " better indentation
" nnoremap <s-tab> v<gv
" nnoremap <tab> v>gv


" Show whitespace
" MUST be inserted BEFORE the colorscheme command
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

" Refresh buffers when the file is changed externally
set autoread
au CursorHold * checktime

" Color scheme
" mkdir -p ~/.vim/colors && cd ~/.vim/colors
" wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400
set t_Co=256
color monokai-sublime


" Enable syntax highlighting
" You need to reload this file for the change to apply
filetype on
filetype plugin indent on
syntax on


" Showing line numbers and length
set number  " show line numbers
set tw=79   " width of document (used by gd)
set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing
set colorcolumn=80
highlight ColorColumn ctermbg=233


" easier formatting of paragraphs
vmap qq gq
nmap qq vgq


" Useful settings
set history=700
set undolevels=700


" Real programmers don't use TABs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
" set expandtab


" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase


" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

" zjy added ultils
" select current word and yank it
map <Leader>w bve
" add file header @TODO
map <Leader>h <esc>ggO# -*- coding: utf-8 -*-<esc><c-o>

map <C-s-f> <esc>:SearchInProject<space>

map <Leader>C <esc>:set fenc=gbk<cr>

vmap ' <esc>bi'<esc>wwi'<esc>

nmap ' *
nmap " #

function! s:SearchInProject(keyword, ...)
  let dir = a:0 >= 1 ? a:1 : "."
  exec "noautocmd vim /".a:keyword."/gj ".dir."/**/*.py"
  cw
endfunction

com! -nargs=+ SearchInProject call s:SearchInProject(<f-args>)

cmap <C-v> <MiddleMouse>
function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf 
endfunction
""""""""""""""""""""""""""""""X9 client"""""""""""""""""""""""""
function! ReloadFile()
	let curFileName = expand('%:t:r')
	exe system('tw2_re.py '.curFileName)
endfunction

nmap <silent> <f5> :call ReloadFile()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""svn operation"""""""""""""""""""""
function! RequestLog()
	let filePath = system('cygpath -w '.expand('%:p'))
	let filePathClean = substitute(filePath,'\v%^\_s+|\_s+%$','','g')
	let mcmd = 'TortoiseProc /command:log /path:"'.filePathClean.'"'
	exe system(mcmd)
endfunction

nmap <silent> <leader>sg :call RequestLog()<CR>

function! RequestBlame()
	let filePath = system('cygpath -w '.expand('%:p'))
	let filePathClean = substitute(filePath,'\v%^\_s+|\_s+%$','','g')
	let mcmd = 'TortoiseProc /command:blame /path:"'.filePathClean.'"'
	exe system(mcmd)
endfunction

nmap <silent> <leader>sb :call RequestBlame()<CR>

function! RequestCommit()
	let filePathClean = 'f:/X9ClientCoder/res/entities'
	let mcmd = 'TortoiseProc /command:commit /path:"'.filePathClean.'"'
	exe system(mcmd)
endfunction

nmap <silent> <leader>sc :call RequestCommit()<CR>

function! RequestUpdate()
	let filePathClean = 'f:/X9ClientCoder/res/entities'
	let mcmd = 'TortoiseProc /command:update /path:"'.filePathClean.'"'
	exe system(mcmd)
endfunction

nmap <silent> <leader>su :call RequestUpdate()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""file operation"""""""""""""""""""""
function! OpenPath()
	let filePath = system('cygpath -w '.expand('%:h'))
	let filePathClean = substitute(filePath,'\v%^\_s+|\_s+%$','','g')
	let wcmd = 'start '.filePathClean
	let mcmd = "cmd /C '".wcmd."'"
	exe system(mcmd)
endfunction

nmap <silent> <leader><C-O> :call OpenPath()<CR>

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>

function! CloseSomething()
  if winnr("$") == 1 && tabpagenr("$") > 1 && tabpagenr() > 1 && tabpagenr() < tabpagenr("$")
    tabclose | tabprev
  else
    q
  endif
endfunction
map <leader>q :call CloseSomething()<CR>
"block comment
nmap <leader>/ <C-V>^I# <esc>

" Setup Pathogen to manage your plugins
" mkdir -p ~/.vim/autoload ~/.vim/bundle
" curl -so ~/.vim/autoload/pathogen.vim https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
" Now you can install any plugin into a .vim/bundle/plugin-name/ folder
call pathogen#infect()


" ============================================================================
" Python IDE Setup
" ============================================================================


" Settings for vim-powerline
" cd ~/.vim/bundle
" git clone git://github.com/Lokaltog/vim-powerline.git
set laststatus=2


" Settings for ctrlp
" cd ~/.vim/bundle
" git clone https://github.com/kien/ctrlp.vim.git
let g:ctrlp_max_height = 30
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*
let g:ctrlp_prompt_mappings = {
\ 'AcceptSelection("e")': ['<2-LeftMouse>'],
\ 'AcceptSelection("h")': ['<c-x>', '<c-s>'],
\ 'AcceptSelection("t")': ['<cr>', '<c-t>'],
\ 'AcceptSelection("v")': ['<c-cr>', '<c-v>', '<RightMouse>'],
\ }


" meta key比较特殊 按道理在cygwin的xterm中应该是可以的
" for more details see
" http://stackoverflow.com/questions/14641942/how-to-unmap-tab-and-do-not-make-ctrl-i-invalid-in-vim
" http://vimdoc.sourceforge.net/htmldoc/intro.html#key-notation
map <M-O> <C-O> " not working


" Better navigating through omnicomplete option list
" See http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction

inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>


" Python folding
" mkdir -p ~/.vim/ftplugin
" wget -O ~/.vim/ftplugin/python_editing.vim http://www.vim.org/scripts/download_script.php?src_id=5492
"" set nofoldenapble

" Settings for YouCompleteMe
nnoremap <leader>d :YcmCompleter GoTo<cr>

" NERDcommenter
map <Leader>cc  <plug>NERDCommenterToggle
map <Leader>c<space>  <plug>NERDCommenterComment
" Add extra space after delimiters for all files. The first one is expected to
" work only for python, but it doesn't.
" let g:NERDCustomDelimiters = { 'py' : { 'left': '# ', 'leftAlt': '', 'rightAlt': '' }} " extra space
let NERDSpaceDelims=1

" guicolorscheme settings

" flake8 settings @use syntastic instead
"let g:PyFlakeDisabledMessages = 'W191'
"let g:flake8_ignore="E501,E302,W191,W291,E251,E261,E265,W293,E101,E231,E303,E231"

" syntastic settings
map <Leader>e :Errors<CR>
let g:syntastic_python_flake8_args='--ignore=W'
