.DEFAULT:generate-site
WD:=$(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
RELPATH:=perl -e 'use File::Spec;print File::Spec->abs2rel(@ARGV)'
SHELL:=/bin/bash -eo pipefail
generate-site:
	@echo '## building ./index.md'; pandoc -c ./style.css --from=markdown_github --to=html5 index.md -o index.html
	@for f in $$(find -name 'index.md' | fgrep -v './index.md'); do \
		echo "## building $$f" ;\
		cd $$(dirname $$f) ;\
		relpath="$$($(RELPATH) $(WD) $$(pwd))" ;\
		pandoc -c $$relpath/style.css \
		       --from=markdown_github \
	               --to=html5 \
		       --columns 5 \
		       index.md -o index.html ;\
		cd - > /dev/null ;\
	done

release:
	git config user.name 'Travis-CI'
	git config user.email 'kirklloyd@gmail.com'
	git config --global push.default simple
	@echo "https://$(GH_TOKEN):@github.com" > .git/credentials
	git config credential.helper 'store --file=.git/credentials'
	git checkout master
	git pull
	git commit -m "Travis Build #$(TRAVIS_BUILD_NUMBER) [ci skip]" $$(find -name '*.html')
	git push
