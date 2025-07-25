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

  let id = matchstr(getline("."), ' \(error\|warning\|note\) \zs\d\+\ze')

  if id =~# '^\d\+$'
    let url = "https://github.com/koalaman/shellcheck/wiki/SC" . id

    if !exists('g:loaded_netrw')
      runtime! autoload/netrw.vim
      runtime! autoload/netrw/os.vim
    endif

    if has('patch-9.1.1485') && exists('*netrw#os#Open')
      call netrw#os#Open(url)
    elseif exists('*netrw#BrowseX') && exists('*netrw#CheckIfRemote')
      call netrw#BrowseX(url, netrw#CheckIfRemote())
    endif

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
