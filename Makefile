clean:
	rm -rf node_modules npm bun

generate-using-bun: clean
	bun install
	bunx --bun orval

generate-using-npm: clean
	npm install
	npx orval

generate-diff: clean
	mkdir npm
	mkdir bun
	npm install
	mv node_modules npm/
	rm -rf node_modules
	bun install
	mv node_modules bun/
	diff -r npm/node_modules bun/node_modules > node_modules.diff ||:
