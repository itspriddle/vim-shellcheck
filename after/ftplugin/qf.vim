if &cp || exists("b:did_ftplugin_shellcheck")
  finish
else
  let b:did_ftplugin_shellcheck = 1
endif

let b:undo_ftplugin = get(b:, "undo_ftplugin", "exe") .
  \ "|unlet b:did_ftplugin_shellcheck"

function! s:gb() abort
  if w:quickfix_title !~# '^:\(shellcheck\|L\?ShellCheck\)'
    return
  end

  let id = matchstr(getline("."), ' \[\zsSC\d\+\ze\]$')

  if id =~# '^SC\d\+$'
    let url = "https://github.com/koalaman/shellcheck/wiki/" . id

    if !exists('g:loaded_netrw')
      runtime! autoload/netrw.vim
    endif

    call netrw#BrowseX(url, netrw#CheckIfRemote())

    echo url
  endif
endfunction

nnoremap <buffer> <silent> <Plug>(shellcheck-gb) :<C-U>call <SID>gb()<cr>
let b:undo_ftplugin .= "|sil! exe 'nunmap <buffer> <Plug>(shellcheck-gb)'"

if !get(g:, "shellcheck_disable_mappings", 0) && empty(mapcheck("gb", "n"))
  nmap <buffer> <silent> gb <Plug>(shellcheck-gb)
  let b:undo_ftplugin .= "|sil! exe 'nunmap <buffer> gb'"
endif

" vim:ft=vim:ts=2:sw=2:sts=2:et
