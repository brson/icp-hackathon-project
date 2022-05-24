git submodule update --init

pushd internet-identity
npm install
II_FETCH_ROOT_KEY=1 II_DUMMY_CAPTCHA=1 II_DUMMY_AUTH=1 dfx deploy --no-wallet --argument '(null)'
popd

pushd src/wiki_frontend
npm install
popd

dfx deploy
