# vim-shellcheck

Vim wrapper for [ShellCheck][], a static analysis tool for shell scripts.

[ShellCheck]: https://github.com/koalaman/shellcheck

## Commands

These commands are available in buffers with `'filetype'` of `sh`.

```
:[range]ShellCheck[!] [args]
```

Run `shellcheck` for the current buffer using optional `[args]` and send any
errors to the quickfix-window. Specify a `[range]` or use a visual selection
to check only those lines, otherwise the entire buffer is checked. Call with a
bang to automatically open the quickfix-window when errors are found.

```
:[range]LShellCheck[!] [args]
```

Run `shellcheck` for the current buffer using optional `[args]` and send any
errors to a location-list-window. Specify a `[range]` or use a visual
selection to check only those lines, otherwise the entire buffer is checked.
Call with a bang to automatically open the location-list-window when errors
are found.

## QF Mappings

**Open ShellCheck error definition on GitHub - gb**

The `gb` command can be used quickfix or location list windows to open the
ShellCheck error definition on GitHub. This functionality is enabled when the
window's `w:quickfix_title` attribute starts with one of the following:

- `:shellcheck` -- created by `compiler shellcheck | :make` or some other
  program
- `:ShellCheck` -- created by the `:ShellCheck` command
- `:LShellCheck` -- created by the `:LShellCheck` command

To disable this mapping:

```viml
let g:shellcheck_disable_mappings = 1
```

To setup a different map:

```viml
let g:shellcheck_disable_mappings = 1
autocmd FileType qf nmap <buffer> <silent> gB <Plug>(shellcheck-gb)
```

Note: The `gb` map will not be defined if one already exists.

## Compiler

A ShellCheck `:compiler` is provided for use as a `'makeprg'`:

```
:compiler shellcheck
:make!
```

## Configuration

**`g:shellcheck_qf_open`**

Specifies how the quickfix-window is opened when `:ShellCheck!` is used. The
default value is `"botright copen 10"`.

**`g:shellcheck_ll_open`**

Specifies how the location-list-window is opened when `:LShellCheck!` is used.
The default value is `"lopen 10"`.

## Installation

Use your favorite plugin manager, or use Vim's built-in package support:

```
mkdir -p ~/.vim/pack/shellcheck/start
cd ~/.vim/pack/shellcheck/start
git clone https://github.com/itspriddle/vim-shellcheck.git
vim -u NONE -c "helptags vim-shellcheck/doc" -c q
```

## License

MIT License - see [`LICENSE`](./LICENSE) in this repo.
