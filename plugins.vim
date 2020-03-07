" ****************************************************************************************************
" PLUGIN CONFIGURATION
" ****************************************************************************************************

" Required to patch airline among other things
fun! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

" dein config
let g:dein#types#git#pull_command = "pull -r"

" airline theme
" AIRLINE SETTINGS
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tagbar#enabled = 1

" Airline theme mods
let g:airline_theme = 'fruit_punch'
let g:airline_extensions = ['coc', 'whitespace', 'tabline', 'hunks']

" Do webdevicons job manually (better...)
let g:webdevicons_enable_airline_statusline = 0
let g:airline_section_a = '%#__accent_bold#%{airline#util#wrap(airline#parts#mode(),0)} %{airline#util#wrap(airline#extensions#branch#get_head(),80)}%#__restore__#%{airline#util#append(airline#parts#crypt(),0)}%{airline#util#append(airline#parts#paste(),0)}%{airline#util#append("",0)}%{airline#util#append(airline#parts#spell(),0)}%{airline#util#append("",0)}%{airline#util#append("",0)}%{airline#util#append(airline#parts#iminsert(),0)}'
let g:airline_section_x = '%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#wrap(airline#parts#filetype(),0)} %{WebDevIconsGetFileTypeSymbol()}'
" Don't show OS in section y
let g:airline_section_y = '%{&encoding}'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.space = ' '
let g:airline_symbols.maxlinenr = ' '
let g:airline_symbols.branch = ''



" language server config
let g:LanguageClient_serverCommands = {
      \     'java': ['/home/azae/.local/bin/jdtls', '-data', '/home/azae/Dev/school/algs/assign1'],
      \     'cpp': ['cquery',
      \       '--language-server',
      \       '--log-file=/tmp/cq.log',
      \       '--init={"cacheDirectory":"/tmp/cquery/"}'
      \     ],
      \     'c': ['cquery',
      \       '--language-server',
      \       '--log-file=/tmp/cq.log',
      \       '--init={"cacheDirectory":"/tmp/cquery/"}'
      \     ],
      \     'haskell': ['hie-wrapper']
      \  }
" autocomplete stuff
let g:deoplete#enable_at_startup = 1
let g:echodoc#enable_at_startup = 1

" papercolor theme mods
let g:PaperColor_Theme_Options = {
      \    'theme': {
      \      'default.dark': {
      \        'override': {
      \          'transparent_background': 0,
      \          'color00': ['#181623', 232],
      \          'linenumber_bg': ['#201d30', 233]
      \        }
      \      }
      \    }
      \  }

" rainbow config
let g:rainbow_conf = {
      \	'guifgs': ['#8ddef4', '#ffbc38', 'seagreen3', '#ff4c35'],
      \	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
      \	'operators': '_,_',
      \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \	'separately': {
      \		'*': {},
      \		'tex': {
      \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
      \		},
      \		'lisp': {
      \			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
      \		},
      \		'vim': {
      \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
      \		},
      \		'html': {
      \			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
      \		},
      \		'css': 0,
      \	}
      \}

" Set the current directory based on recursive upward seach
let g:rooter_patterns = ['stack.yaml', '.vscode/', '.project/', 'pom.xml', '.git/']

fun! s:sync_term(termId)
  if vwm#util#lookup('term').active
    let l:cd_cmd = 'cd ' . getcwd() . "\n"
    call chansend(a:termId, l:cd_cmd)
    call chansend(a:termId, "clear\n")
  endif
endfun

" Target term must be focused
let s:ltid = 0
fun! s:term_mods()
  let s:ltid = b:terminal_job_id
  tnoremap <buffer> <silent> <C-q> <C-\><C-n>
  tnoremap <buffer> <silent> <C-a> <C-\><C-n>:execute(winnr('#') . 'wincmd w')<CR>
  setlocal nonumber norelativenumber
  call s:clear_term()
endfun

fun! s:clear_term()
  execute('call chansend(' . b:terminal_job_id . ', "clear\n")')
endfun

fun! s:resz_term()
  return &co / 2
endfun

" Set layouts
let g:vwm#pop_order = 'vert'
let g:vwm#layouts = [
      \  {
      \    'name': 'term',
      \    'opnAftr': ['vert resize +1', 'vert resize -1'],
      \    'bot':
      \    {
      \      'init': ['term zsh', function('s:term_mods')],
      \      'restore': [function('s:clear_term')],
      \      'set': ['bh=hide', 'nobl', 'noswapfile', 'winfixheight'],
      \      'h_sz': 12,
      \      'v_sz': function('s:resz_term'),
      \      'left':
      \      {
      \        'init': ['term zsh', function('s:term_mods')],
      \        'restore': [function('s:clear_term')],
      \        'set': ['bh=hide', 'nobl', 'noswapfile', 'winfixheight'],
      \        'focus': 1
      \      }
      \    }
      \  }
      \]

" Rainbow
let g:rainbow_active = 1

"Change defx icons
call defx#custom#column('filename', {
      \ 'directory_icon': '▶',
      \ 'opened_icon': '▼',
      \ 'indent': " "
      \ })

" Plugin augroup
augroup user_plugins
  autocmd!
  au! User RooterChDir call s:sync_term(s:ltid)
  au! BufEnter * if expand('%:t') =~# '[defx]' | sleep 50ms | call defx#call_async_action('cd', getcwd())
augroup END

" Change Coc.nvim error hilight
hi link CocErrorHighlight ErrorMsg

" Disable indent guidelines by default
let g:indentLine_enabled = 0

" Configure whichkey interface
let g:mapleader = "\<Space>"
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler


let g:spacevim_debug_level = 3

" Configure defx layout
fun! <SID>defx_open_smart()
  if 1 == line('.')
    call defx#call_async_action('cd', '..')

  elseif defx#is_directory()
    call defx#call_async_action('open_or_close_tree')

  else
    call defx#call_async_action('drop')
  endif
endfun

fun! s:defx_restore_mods()
  let l:hi = GetHighlight('Normal')
  setlocal foldcolumn=1
  if exists('l:hi.guibg')
    execute('hi FoldColumn guibg=' . GetHighlight('Normal')['guibg'])
  else
    hi clear FoldColumn
  endif
endfun

fun! s:defx_mods()
  nnoremap <buffer> <silent> <CR> :call <SID>defx_open_smart()<CR>
  nnoremap <buffer> <silent> o :call defx#call_async_action('open_tree_recursive')<CR>
  nnoremap <buffer> <silent> c :if defx#is_directory() <bar> call defx#call_async_action('open') <bar> endif<CR>
  nnoremap <buffer> <silent> m :call <SID>defx_ex_menu({
        \    '1. cut': "call defx#call_action('move')",
        \    '2. copy': "call defx#call_action('copy')",
        \    '3. paste': "call defx#call_action('paste')",
        \    '4. rename': "call defx#call_action('rename')",
        \    '5. new': "call defx#call_action('new_multiple_files')",
        \    '6. trash': "call defx#call_action('remove_trash')"
        \  })<CR>
  nnoremap <buffer> <silent> i :call defx#call_async_action('toggle_ignored_files')<CR>
endfun

" Menu for action to execute
fun! <SID>defx_ex_menu(defs)
  let l:keys = sort(keys(a:defs))
  let l:nr = inputlist(l:keys)
  if l:nr
    execute(a:defs[l:keys[l:nr - 1]])
  endif
endfun

let g:vwm#layouts += [
      \  {
      \    'name': 'defx',
      \    'left':
      \    {
      \       'init': ['Defx -columns=mark:indent:icons:filename:type', function('s:defx_restore_mods'), function('s:defx_mods')],
      \       'set': ['buftype=nofile', 'bufhidden=hide', 'nobl', 'noswapfile', 'nowrap', 'nospell', 'cursorline', 'winfixwidth'],
      \       'restore': [function('s:defx_restore_mods')],
      \       'v_sz': 28,
      \       'focus': 1
      \    }
      \  }
      \]

let g:vwm#layouts += [
      \ {
      \  'name': 'dev_panel',
      \  'opnAftr': ['edit'],
      \  'left':
      \  {
      \    'v_sz': 33,
      \    'init': ['Defx -columns=mark:indent:icons:filename:type', function('s:defx_restore_mods'), function('s:defx_mods')],
      \    'bot': {
      \      'init': ['Vista', 'sleep 50ms']
      \    }
      \  }
      \}
      \]

" Configure visual keymap interface
let g:vkmap#col_width = 18
let g:vkmap#outer_padding = 1
let g:vkmap#inner_padding = 16
let g:vkmap#pos = 'float'
let g:vkmap#height = 6

let s:main = {
      \  'key': '<Space>',
      \  'mode': 'n',
      \  'maps':
      \  [
      \    {
      \      'key': 'l',
      \      'dscpt': 'lang-server',
      \      'leader': 1
      \    },
      \    {
      \      'key': 'o',
      \      'dscpt': 'toggle tree',
      \    },
      \    {
      \      'key': 't',
      \      'dscpt': 'toggle terms',
      \    },
      \    {
      \      'key': 'r',
      \      'dscpt': 'refresh',
      \    },
      \    {
      \      'key': 'rt',
      \      'dscpt': 'toggle rainbow',
      \    },
      \    {
      \      'key': 's',
      \      'dscpt': 'toggle tagbar',
      \    },
      \    {
      \      'key': 'f',
      \      'dscpt': 'flygrep'
      \    },
      \    {
      \      'key': 'p',
      \      'dscpt': 'livedown preview'
      \    }
      \  ]
      \}

let s:lsp = {
      \  'key':'<Space>l',
      \  'mode': 'n',
      \  'maps':
      \  [
      \    {
      \      'key': 'd',
      \      'dscpt': 'definition',
      \    },
      \    {
      \      'key': 'i',
      \      'dscpt': 'info',
      \    },
      \    {
      \      'key': 'n',
      \      'dscpt': 'next',
      \    },
      \    {
      \      'key': 'p',
      \      'dscpt': 'prev',
      \    },
      \    {
      \      'key': 'f',
      \      'dscpt': 'find refs',
      \    },
      \    {
      \      'key': 'r',
      \      'dscpt': 'rename',
      \    },
      \    {
      \      'key': 'a',
      \      'dscpt': 'action',
      \    },
      \  ]
      \}
let g:vkmap#menus = [s:main, s:lsp]

" let g:lightline = {
"       \ 'colorscheme': 'cosme',
"       \ }
"
" let g:lightline.enable = {
"             \ 'statusline': 1,
"             \ 'tabline': 1
"             \ }
