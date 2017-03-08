.DEFAULT:generate-site
generate-site:
	cd santa-cruz && pandoc -c ../style.css --from=markdown_github --to=html5 index.md -o index.html
