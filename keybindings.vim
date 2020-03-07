" ****************************************************************************************************
" DEFINITIONS
" ****************************************************************************************************


" From: https://github.com/altercation/solarized/issues/102#issuecomment-275269574
" Find and remember links between highlighting groups.
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

command! -nargs=1 -complete=color MyColorscheme call <SID>AccurateColorscheme(<q-args>)

" ****************************************************************************************************
" KEYBINDINGS
" ****************************************************************************************************

" Bind d, s, and x to a register. Normal use case for cut is in visual mode
nnoremap d "ad
nnoremap D "ad
nnoremap x "ax
nnoremap s "as
nnoremap X "aX
vnoremap d "ad
vnoremap D "aD
vnoremap s "as

" Alt paste
nnoremap [ "pa
nnoremap { "Pa

" Do not need two keybindings for visual mode
nnoremap c <Nop>

" NERDTree toggle


" From: https://stackoverflow.com/questions/4739901/scrolling-in-vim-autocomplete-box-with-jk-movement-keys
" Keep interface consistent. Use ctrl j / k for deoplate nav
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" Map alt window
nnoremap <M-6> <C-w>p

" Disable annoying help mapping
nnoremap <F1> <Nop>
inoremap <F1> <Nop>

inoremap <C-q> <Nop>



" Remap terminal mode stuffs
tnoremap <C-q> <C-\><C-n>

" Coc mappings
nmap <Space>ld <Plug>(coc-definition)
nmap <Space>li <Plug>(coc-diagnostic-info)
nmap <Space>ln <Plug>(coc-diagnostic-next)
nmap <Space>lp <Plug>(coc-diagnostic-prev)
nmap <Space>lf <Plug>(coc-references)
nmap <Space>lr <Plug>(coc-rename)
nmap <Space>la <Plug>(coc-codeaction)

xmap <Space>la <Plug>(coc-codeaction-selected)

" Editor mappings
nmap <Space>rt :RainbowToggle<CR>

"Toggle dev panel
nnoremap <silent> <Space>t :VwmToggle term<CR>

" DEFX mappings
nnoremap <silent> <Space>o :VwmToggle defx<CR>


nnoremap <silent> <Space>s :VwmToggle dev_panel<CR>

" Easy align config
nmap <Space>a <Plug>(EasyAlign)

nnoremap <silent> <Space>r :VwmRefresh<CR>

nnoremap <silent> <Space>f :FlyGrep<CR>

nnoremap <Space>p :LivedownPreview<CR>
