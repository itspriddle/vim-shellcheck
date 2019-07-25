.PHONY: default package

default:
	@echo 'Run `make package` to package for vim.org' && false

package:
	mkdir -p pkg
	git archive --format=zip HEAD after compiler doc > pkg/vim-shellcheck-`git tag --list | head -1`.zip
