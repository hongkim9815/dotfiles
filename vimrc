set nocompatible
filetype off

" Manual vim-plug installation
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin()

" UI
Plug 'yous/vim-open-color'
Plug 'w0ng/vim-hybrid'
Plug 'vim-airline/vim-airline'

" Languages
Plug 'scrooloose/syntastic'
Plug 'davidhalter/jedi-vim'
Plug 'derekwyatt/vim-scala'

" Util
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'

" snippet
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'wesleyche/srcexpl'

Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

call plug#end()
call glaive#Install()

" syntatic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_quiet_messages = { "level": "warnings" }
let g:syntastic_cpp_compiler_options = '-std=c++11'
let g:syntastic_mode_map = { "mode": "active",
                           \ "active_filetypes": [],
                           \ "passive_filetypes": ["scala"] }

function! SyntasticCheckHook(errors)
    if !empty(a:errors)
        let g:syntastic_loc_list_height = min([len(a:errors), 10])
    endif
endfunction

function! ToggleSyntastic()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            lclose
            return
        endif
    endfor
    SyntasticCheck
endfunction

nnoremap <F4> :call ToggleSyntastic()<CR>

" autoformat for google coding style
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType vue AutoFormatBuffer prettier
augroup END

" jedi-vim
autocmd FileType python setlocal completeopt-=preview

" Nerd-tree
" let g:NERDTreeDirArrows=0
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
autocmd VimEnter * NERDTree | wincmd p
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" srcexpl
nnoremap <silent> <F3> :SrcExplToggle<CR>
set tag=./tags;/
let g:SrcExpl_winHeight = 8
let g:SrcExpl_refreshTime = 100
let g:SrcExpl_jumpKey = "<ENTER>"
let g:SrcExpl_gobackKey = "<SPACE>"
let g:SrcExpl_isUpdateTags = 0

" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" vimrc fundamental setting
syntax on
set number
set background=dark
set backspace=2
set tabstop=2
set softtabstop=2
set shiftwidth=2
set scrolloff=4
set expandtab
set smartindent
set wrap
set undolevels=1000
set laststatus=2
set mouse=a
" Briefly jump to the matching one when a bracket is inserted
set showmatch

colorscheme hybrid

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
if version >= 702
	autocmd BufWinLeave * call clearmatches()
endif

autocmd FileType c,cpp,java,python setlocal expandtab
autocmd FileType html,php,js,css setlocal tabstop=2 softtabstop=2 shiftwidth=2
set display+=uhex
if has('extra_search')
	set hlsearch
endif

" Exit Paste mode when leaving Insert mode
autocmd InsertLeave * set nopaste

" Move between splitted windows
nnoremap <tab> <C-W>w

" Center display after searching
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Ignore mistakes
command Wq :wq
command WQ :wq
command W :w
command Wa :wa
command WA :wa
command Q :q

if &term =~ "screen"
  " 256 colors
  let &t_Co = 256
  " restore screen after quitting
  let &t_ti = "\<Esc>7\<Esc>[r\<Esc>[?47h"
  let &t_te = "\<Esc>[?47l\<Esc>8"
  if has("terminfo")
    let &t_Sf = "\<Esc>[3%p1%dm"
    let &t_Sb = "\<Esc>[4%p1%dm"
  else
    let &t_Sf = "\<Esc>[3%dm"
    let &t_Sb = "\<Esc>[4%dm"
  endif
endif

augroup vimrc
  " C, C++ compile
  autocmd FileType c,cpp map <F5> :w<CR>:make %<CR>
  autocmd FileType c,cpp imap <F5> <Esc>:w<CR>:make %<CR>
  autocmd FileType c
        \ if !filereadable('Makefile') && !filereadable('makefile') |
        \   setlocal makeprg=gcc\ -o\ %< |
        \ endif
  autocmd FileType cpp
        \ if !filereadable('Makefile') && !filereadable('makefile') |
        \   setlocal makeprg=g++\ -o\ %< |
        \ endif

  " Python 2, 3
  autocmd FileType python map <F5> :w<CR>:!python %<CR>
  autocmd FileType python imap <F5> <Esc>:w<CR>:!python %<CR>
  autocmd FileType python map <F6> :w<CR>:!python3 %<CR>
  autocmd FileType python imap <F6> <Esc>:w<CR>:!python3 %<CR>
augroup END


" Cursor line keep
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ endif
:autocmd WinEnter * if &buftype ==# 'quickfix' && winnr('$') == 1 | quit | endif

