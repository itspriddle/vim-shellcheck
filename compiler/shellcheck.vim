if exists("current_compiler")
  finish
endif
let current_compiler = "shellcheck"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:save_cpo = &cpo
set cpo-=C

CompilerSet makeprg=shellcheck\ -f\ gcc\ $*\ %:S

CompilerSet errorformat=
  \%f:%l:%c:\ %trror:\ %m,
  \%f:%l:%c:\ %tarning:\ %m,
  \%I%f:%l:%c:\ note:\ %m

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:ft=vim:ts=2:sw=2:sts=2:et
