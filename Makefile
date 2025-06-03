clean:
	rm -rf node_modules

generate-using-bun: clean
	bun install
	bunx --bun orval

generate-using-npm: clean
	npm install
	npx orval
