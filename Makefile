.PHONY: default package

default:
	@echo 'Run `make package` to package for vim.org' && false

package:
	mkdir -p pkg
	git archive --format=zip HEAD after doc > pkg/vim-shellcheck-`git tag --list | sort -r | head -1`.zip
