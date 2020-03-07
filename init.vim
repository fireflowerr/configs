" ****************************************************************************************************
" NVIM CONFIG - modularized vim config
" ****************************************************************************************************

" Dev filetypes
let s:dev_ft = [ 'java', 'haskell', 'c', 'cpp' ]
" Use dein as plugin manager
if &compatible
  set nocompatible
endif

" Set leader
let mapleader = "\<Space>"

" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Install plugins
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('vim-airline/vim-airline', {'lazy': 0, 'if': 1})
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('beikome/cosme.vim')
  call dein#add('liuchengxu/vista.vim')
  call dein#add('junegunn/fzf', {'build': './install --all'})
  call dein#add('junegunn/fzf.vim')
  call dein#add('neoclide/coc.nvim', {'merge':0, 'build': './install.sh nightly'})
  call dein#add('luochen1990/rainbow')
  call dein#add('shime/vim-livedown', {'lazy': 1, 'on_ft': ['markdown']})
  call dein#add('paroxayte/vwm.vim')
  call dein#add('mhinz/vim-startify')
  call dein#add('airblade/vim-rooter')
  call dein#add('Shougo/defx.nvim')
  call dein#add('kristijanhusak/defx-icons')
  call dein#add('ap/vim-css-color')
  call dein#add('junegunn/vim-easy-align')
  call dein#add('Yggdroot/indentLine')
  call dein#add('paroxayte/vkmap.vim')
  call dein#add('itchyny/lightline.vim', {'if': 0})
  call dein#add('junegunn/vader.vim')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-fugitive')
  call dein#add('Procrat/oz.vim')
  call dein#end()

  call dein#save_state()
endif

if !exists('s:known_links')
  let s:known_links = {}
endif

function! s:Find_links() " {{{1
  " Find and remember links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx links to Constant" in the
    " output of the :highlight command.
    if len(tokens) == 5 && tokens[1] == 'xxx' && tokens[2] == 'links' && tokens[3] == 'to'
      let fromgroup = tokens[0]
      let togroup = tokens[4]
      let s:known_links[fromgroup] = togroup
    endif
  endfor
endfunction

function! s:Restore_links() " {{{1
  " Restore broken links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  let num_restored = 0
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx cleared" in the
    " output of the :highlight command.
    if len(tokens) == 3 && tokens[1] == 'xxx' && tokens[2] == 'cleared'
      let fromgroup = tokens[0]
      let togroup = get(s:known_links, fromgroup, '')
      if !empty(togroup)
        execute 'hi link' fromgroup togroup
        let num_restored += 1
      endif
    endif
  endfor
endfunction

function! s:AccurateColorscheme(colo_name)
  call <SID>Find_links()
  exec "colorscheme " a:colo_name
  call <SID>Restore_links()
endfunction

command! -nargs=1 -complete=color Color call <SID>AccurateColorscheme(<q-args>) | hi pmenu guibg=grey50

" SOURCE INIT MODS
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/keybindings.vim
" AUTOCMS

" Remember line number
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Trim on save
au BufWritePre * normal :%s/\s\+$//e

function! GetHighlight(group)
  let output = execute('hi ' . a:group)
  let list = split(output, '\s\+')
  let dict = {}
  for item in list
    if match(item, '=') > 0
      let splited = split(item, '=')
      let dict[splited[0]] = splited[1]
    endif
  endfor
  return dict
endfunction

" Constant settings
set clipboard+=unnamedplus cmdheight=2 nu rnu autoindent smartindent tabstop=2 softtabstop=2
      \   shiftwidth=2 expandtab hidden background=dark termguicolors tw=100 updatetime=500
      \   timeoutlen=500 foldmethod=marker
hi Visual guibg=#fffacd guifg=black
hi pmenu guibg=grey50
Color cosme
