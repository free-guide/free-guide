.DEFAULT:generate-site
generate-site:
	pandoc -c style.css --from=markdown_github --to=html5 index.md > index.html
