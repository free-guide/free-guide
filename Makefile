.DEFAULT:generate-site
WD:=$(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
RELPATH:=perl -e 'use File::Spec;print File::Spec->abs2rel(@ARGV)'
SHELL:=/bin/bash -eo pipefail
generate-site:
	@for f in $$(find -name '*.md'); do \
		echo "## building $$f" ;\
		cd $$(dirname $$f) ;\
		relpath="$$($(RELPATH) $(WD) $$(pwd))" ;\
		pandoc -c $$relpath/style.css \
		       --from=markdown_github \
	               --to=html5 \
		       index.md -o index.html ;\
		cd - ;\
	done

release:
	git config user.name 'Travis-CI'
	git config user.email 'kirklloyd@gmail.com'
	git config credential.helper 'store --file=.git/credentials'
	@echo "https://$(GH_TOKEN):@github.com" > .git/credentials
	git commit -m "Travis Build #$(TRAVIS_BUILD_NUMBER) [ci skip]" $$(find -name '*.html')
