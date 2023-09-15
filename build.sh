#!/usr/bin/env bash

set -e
set -x

if docker info > /dev/null 2>& 1; then
    echo "docker is running"
else
    echo "build failed; docker needs to be installed and running"
    exit 1
fi

# Clear the output
rm -rf out/
mkdir out/

# Build the wasm
for lang in python javascript go ruby; do
  npx tree-sitter build-wasm --docker node_modules/tree-sitter-${lang}
done

# These two have irregular paths
npx tree-sitter build-wasm --docker node_modules/tree-sitter-typescript/typescript
npx tree-sitter build-wasm --docker node_modules/tree-sitter-typescript/tsx

# Copy the wasm files to the output directory
cp *.wasm out/
