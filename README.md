TODO

# Useful commands

```
cargo install ic-cdk-optimizer
```

```
pushd attempt1/internet-identity
`II_FETCH_ROOT_KEY=1 II_DUMMY_CAPTCHA=1 II_DUMMY_AUTH=1 dfx deploy --no-wallet --argument '(null)'`
popd
```

``
pushd attempt1
dfx deploy
popd
```

```
cd attempt1
dfx start
```

```
cd attempt1
npm run dev
```

Convert `page_backend.wasm` to WasmBlob format:

```
od -An -tx1 -v .dfx/local/canisters/page_backend/page_backend.wasm | sed -E "s/[[:space:]]+/\\\/g" | tr -d "\n" | sed '$ s/\\$//' > page_backend.wasmblob
```

Call `dfx` to send and initialize the WasmBlob in the wiki_backend:

```
dfx canister call <canister_id> initWasmBlob "blob \"$(cat page_backend.wasmblob)\""
```
