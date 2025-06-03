# Bun Install + Orval Bug Reproduction

## Steps to Reproduce

Refer [Makefile](./Makefile) for actual steps

- run `make generate-using-bun` -> fails
- run `generate-using-npm` -> works (tested with node v20.18.0)

## Observed Error in Case of Bun

```shell
bunx --bun orval
Error compiling schema, function code: const schema16 = scope.schema[10];return function validate14(data, {instancePath="", parentData, parentDataProperty, rootData=data}={}){let vErrors = null;let errors = 0;if((!(data && typeof data == "object" && !Array.isArray(data))) && (data !== null)){const err0 = {instancePath,schemaPath:"#/type",keyword:"type",params:{type: schema16.type},message:"must be object,null"};if(vErrors === null){vErrors = [err0];}else {vErrors.push(err0);}errors++;}if(data && typeof data == "object" && !Array.isArray(data)){for(const key0 in data){if(!(key0 === "keyedBy")){const err1 = {instancePath,schemaPath:"#/additionalProperties",keyword:"additionalProperties",params:{additionalProperty: key0},message:"must NOT have additional properties"};if(vErrors === null){vErrors = [err1];}else {vErrors.push(err1);}errors++;}}if(data.keyedBy !== undefined){if(typeof data.keyedBy !== "string"){const err2 = {instancePath:instancePath+"/keyedBy",schemaPath:"#/properties/keyedBy/type",keyword:"type",params:{type: "string"},message:"must be string"};if(vErrors === null){vErrors = [err2];}else {vErrors.push(err2);}errors++;}}}if(errors > 0){const emErrors0 = {"type":[]};for(const err3 of vErrors){if(((((({"str":"err3"}.keyword !== "errorMessage") && (!{"str":"err3"}.emUsed)) && ({"str":"err3"}.instancePath === instancePath)) && ({"str":"err3"}.keyword in {"str":"emErrors0"})) && ({"str":"err3"}.schemaPath.indexOf("#") === 0)) && (/^\/[^\/]*$/.test({"str":"err3"}.schemaPath.slice(1)))){{"str":"emErrors0"}[{"str":"err3"}.keyword].push({"str":"err3"});{"str":"err3"}.emUsed = true;}}for(const key1 in emErrors0){if({"str":"emErrors0"}[{"str":"key1"}].length){if(vErrors === null){vErrors = [{"str":"err4"}];}else {vErrors.push({"str":"err4"});}errors++;}}const emErrs0 = [];for(const err5 of vErrors){if(!{"str":"err5"}.emUsed){{"str":"emErrs0"}.push({"str":"err5"});}}vErrors = emErrs0;errors = {"str":"emErrs0"}.length;}validate14.errors = vErrors;return errors === 0;}
84 |         sourceCode = `${gen.scopeRefs(names_1.default.scope)}return ${validateCode}`;
85 |         // console.log((codeSize += sourceCode.length), (nodeCount += gen.nodeCount))
86 |         if (this.opts.code.process)
87 |             sourceCode = this.opts.code.process(sourceCode, sch);
88 |         // console.log("\n\n\n *** \n", sourceCode)
89 |         const makeValidate = new Function(`${names_1.default.self}`, `${names_1.default.scope}`, sourceCode);
                                      ^
SyntaxError: Unexpected token ':'
      at <parse> (/private/tmp/orval-example/custom-fetch/node_modules/@stoplight/spectral-core/node_modules/ajv/dist/compile/index.js:89:34)
```
