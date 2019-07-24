if &cp || exists("b:did_ftplugin_shellcheck")
  finish
else
  let b:did_ftplugin_shellcheck = 1
endif

let b:undo_ftplugin = get(b:, "undo_ftplugin", "exe") .
  \ "|unlet b:did_ftplugin_shellcheck"

let s:shellcheck_efm =
  \ '%f:%l:%c: %trror: %m,' .
  \ '%f:%l:%c: %tarning: %m,' .
  \ '%I%f:%l:%c: note: %m'

function! s:warn(message) abort
  echohl WarningMsg
  echo a:message
  echohl None
endfunction

function! s:format_line(index, val, line1, line2) abort
  if (a:index == 0 && a:val =~ '^#!.*') || (a:index >= (a:line1 - 1)) && (a:index <= (a:line2 - 1))
    return a:val
  else
    return ''
  end
endfunction

function! s:update_error(val, temp, current)
  return extend(a:val, a:val.bufnr == a:temp ? { 'bufnr': a:current } : {})
endfunction

function! s:shellcheck(args, open, qf, line1, line2) abort
  if !executable("shellcheck")
    return s:warn("shellcheck not in PATH!")
  endif

  try
    let program = a:qf ? ":ShellCheck" : ":LShellCheck"
    let old_errorformat = &errorformat
    let current_file = expand("%")
    let current_bufnr = bufnr("%")
    let temp_file = printf("%s-%s", tempname(), fnamemodify(current_file, ":t"))
    let lines = map(getline(1, "$"), "s:format_line(v:key, v:val, a:line1, a:line2)")
    let title = join(filter([program, a:args, current_file], "len(v:val)"))
    let cmd = join(filter(["shellcheck -f gcc", a:args, shellescape(temp_file)], "len(v:val)"))
    let &errorformat = s:shellcheck_efm

    call writefile(lines, temp_file)

    execute "silent" (a:qf ? "cgetexpr" : "lgetexpr") "system(cmd)"

    let temp_bufnr = bufnr(temp_file)

    if a:qf
      let errors = map(getqflist(), "s:update_error(v:val, temp_bufnr, current_bufnr)")
      call setqflist([], "r", { "items": errors, "title": title })
    else
      let errors = map(getloclist(0), "s:update_error(v:val, temp_bufnr, current_bufnr)")
      call setloclist(0, [], "r", { "items": errors, "title": title })
    endif

    let error_count = len(errors)

    if error_count > 0
      if a:open
        execute a:qf ?
          \ get(g:, "shellcheck_qf_open", "botright copen 10") :
          \ get(g:, "shellcheck_ll_open", "lopen 10")
      endif

      call s:warn(printf("Found %d ".(error_count == 1 ? "error!" : "errors!"), error_count))
    else
      echo "No errors!"
    endif

    redraw
  finally
    let &errorformat = old_errorformat
  endtry
endfunction

command! -buffer -bang -range=% -nargs=* ShellCheck
  \ call s:shellcheck(<q-args>, <bang>0, 1, <line1>, <line2>)

command! -buffer -bang -range=% -nargs=* LShellCheck
  \ call s:shellcheck(<q-args>, <bang>0, 0, <line1>, <line2>)

let b:undo_ftplugin .= "|delc ShellCheck |delc LShellCheck"

" vim:ft=vim:ts=2:sw=2:sts=2:et
