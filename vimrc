set nocompatible
filetype off

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

Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

Plug 'Vimjas/vim-python-pep8-indent'

call plug#end()
call glaive#Install()

" syntatic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_cpp_compiler_options = '-std=c++11'
let g:syntastic_python_python_exec = 'python3'

function! SyntasticCheckHook(errors)
  if !empty(a:errors)
    let g:syntastic_loc_list_height = min([len(a:errors), 8]) + 2
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
  " autocmd FileType python AutoFormatBuffer yapf
  " autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType vue AutoFormatBuffer prettier
augroup END
autocmd FileType php setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" jedi-vim
autocmd FileType python setlocal completeopt-=preview
let g:jedi#show_call_signatures = "0"
let g:jedi#popup_on_dot = 0
autocmd ColorScheme *
      \ highlight jediFunction ctermfg=250 ctermbg=240 |
      \ highlight jediFat ctermfg=232 ctermbg=250

" Nerd-tree
" let g:NERDTreeDirArrows=0
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
autocmd VimEnter * NERDTree | wincmd p
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
let NERDTreeShowHidden=1

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

" gitgutter
autocmd BufWritePost * GitGutter
let g:gitgutter_max_signs= 1000
autocmd ColorScheme * highlight GitGutterDelete ctermfg=red

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
set nowrap
set undolevels=1000
set laststatus=2
set mouse=a
" Briefly jump to the matching one when a bracket is inserted
set showmatch
set cul
set colorcolumn=120

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=darkgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
if version >= 702
  autocmd BufWinLeave * call clearmatches()
endif

" Colorscheme Active
autocmd ColorScheme * highlight ColorColumn ctermbg=237
autocmd ColorScheme * highlight MatchParen ctermfg=221
colorscheme hybrid

set display+=uhex
if has('extra_search')
  set hlsearch
endif

" Exit Paste mode when leaving Insert mode
autocmd InsertLeave * set nopaste

" Move between splitted windows
nnoremap <tab> <C-W>w
nnoremap <S-tab> <C-W>W

" Remove highlights
nnoremap <C-h> :nohlsearch<CR>

" Display center
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap <PageUp> <C-u>zz
nnoremap <PageDown> <C-d>zz
inoremap <PageUp> <ESC><C-u>zz
inoremap <PageDown> <ESC><C-d>zz
autocmd BufWinEnter * exe "normal zz"

" Utils
nnoremap <C-a> ggvG
vnoremap <C-a> vggvG
nnoremap <C-u> <C-r>

" Ignore mistakes
command Wq :wq
command Qw :wq
command QW :wq
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

augroup autocompile
  " Python 2 and Python 3
  autocmd FileType python map <F5> :w<CR>:!python %<CR>
  autocmd FileType python imap <F5> <Esc>:w<CR>:!python %<CR>
  autocmd FileType python map <F6> :w<CR>:!python3 %<CR>
  autocmd FileType python imap <F6> <Esc>:w<CR>:!python3 %<CR>
  autocmd FileType ruby map <F5> :w<CR>:!ruby %<CR>
  autocmd FileType ruby imap <F5> <Esc>:w<CR>:!ruby %<CR>
augroup END

" keep cursor line and display it to the center
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \ exe "normal g`\"" |
      \ endif

