clean:
	rm -rf node_modules

generate-using-bun: clean
	bun install
	bunx --bun orval

generate-using-npm: clean
	npm install
	npx orval

generate-diff: clean
	make generate-using-npm
	rm -rf npm
	mkdir npm
	mv node_modules npm/
	make generate-using-bun ||:
	rm -rf bun
	mkdir bun
	mv node_modules bun/
	diff -r npm/node_modules bun/node_modules > node_modules.diff ||:
