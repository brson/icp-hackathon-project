# Another look at Dfinity (Internet Computer)

It's been more than a year since my [last look at programming on Dfinity].
With their May 2022 hackathon it was a good opportunity to try again.


## 2022/05/10

Day 1 of the hackathon.
We have a few ideas for the project we want to make,
but are not sure of the capabilities of ICP,
so the first thing we are going to do is go through the tutorials,
create and deploy a simple [canister] (ICP's smart contract / dapp bundles) with backend and frontend
that can read and write certified data.

[Certified data] seems to be the large-scale storage mechanism of ICP.
ICP is unique in existing blockchains in that it appears to incorprate
decentralized storage as a first-class feature &mdash; there should be
no need to leverage e.g. IPFS to store big blogs. In theory this
should open up new possibilities for the kinds of apps one might deploy,
but from perusing the documentation I don't understand how to use the feature.

ICP's other storage mechanism is [TODO], which is a kind of persistent RAM,
suitable for small state.

OK, let's do some tutorials.

### Hello world

I'm going to go through the [Hello World Quick Start][hwqs]
I hope this will get me a toolchain and teach me to deploy and run a canister.

[hwqs]: https://smartcontracts.org/docs/current/developer-docs/quickstart/hello10mins

First thing I learn:

- Dapps are at least two canister's: a backend and a frontend.

More learnings:

- "Cycles" are gas
- Each cannister has a cycles account and pays its own gas
- ICP can be converted to cycles
- There are cycles wallets - not clear on if every canister has one

### Installing tools

I run

```
sh -ci "$(curl -fsSL https://smartcontracts.org/install.sh)"
```

It says

```
Executing dfx install script, commit: edfe002ed7fcf06228a72cef959989d4b10f10f0
Version found: 0.9.3
Creating uninstall script in ~/.cache/dfinity
uninstall path=/home/brian/.cache/dfinity/uninstall.sh
Checking for latest release...
Will install in: /home/brian/bin
Installed /home/brian/bin/dfx
```

Seems ok.

This `/home/brian/bin` directory is not part of my path,
and `dfx` is the only thing in it.

I add

```bash
export PATH="/home/brian/bin:$PATH"
```

to my `~/.bashrc` file and restart my shell and I can run `dfx`.
My `~/.bashrc` is filled with these augmentations of `PATH` for custom tooling.

I run `dfx --version:`

```
$ dfx --version
dfx 0.9.3
```

ICP requires node.js 12, 14, and 16, and I have 16.5.

I run `dfx new hello` and the first lines it prints are:

```
Fetching manifest https://sdk.dfinity.org/manifest.json
You seem to be running an outdated version of dfx.

You are strongly encouraged to upgrade by running 'dfx upgrade'!
  Version v0.9.3 installed successfully.
```

It said my `dfx` was out of date and upgraded,
even though I just installed `dfx` and had the same version it upgraded to.

After the upgrade it continued to printed

```
Creating new project "hello"...
CREATE       hello/dfx.json (481B)...
CREATE       hello/README.md (2.25KiB)...
CREATE       hello/.gitignore (165B)...
CREATE       hello/src/hello_assets/assets/sample-asset.txt (24B)...
CREATE       hello/src/hello/main.mo (99B)...
CREATE       hello/package.json (1.14KiB)...
CREATE       hello/webpack.config.js (3.52KiB)...
CREATE       hello/src/hello_assets/assets/main.css (537B)...
CREATE       hello/src/hello_assets/assets/logo.png (24.80KiB)...
CREATE       hello/src/hello_assets/assets/favicon.ico (15.04KiB)...
CREATE       hello/src/hello_assets/src/index.html (625B)...
CREATE       hello/src/hello_assets/src/index.js (526B)...
⠄ Installing node dependencies...

added 407 packages, and audited 408 packages in 22s

85 packages are looking for funding
  run `npm fund` for details

  Done.
```

Then it printed

```
Creating git repository...
```

creating a git repository that I had to immediately delete because I am already in a git repository.
Cargo does this too and it is annoying.

Finally it printed a big Dfinity / ICP logo and some help info:

```
To learn more before you start coding, see the documentation available online:

- Quick Start: https://sdk.dfinity.org/docs/quickstart/quickstart-intro.html
- SDK Developer Tools: https://sdk.dfinity.org/docs/developers-guide/sdk-guide.html
- Motoko Language Guide: https://sdk.dfinity.org/docs/language-guide/motoko.html
- Motoko Quick Reference: https://sdk.dfinity.org/docs/language-guide/language-manual.html

If you want to work on programs right away, try the following commands to get started:

    cd hello
    dfx help
    dfx new --help
```


### Local deployment

In one window I run `dfx start` and in the other `npm install` then `dfx deploy`.

I see

```
$ dfx deploy
Creating the "default" identity.
  - generating new key at /home/brian/.config/dfx/identity/default/identity.pem
Created the "default" identity.
Creating a wallet canister on the local network.
The wallet canister on the "local" network for user "default" is "rwlgt-iiaaa-aaaaa-aaaaa-cai"
Deploying all canisters.
Creating canisters...
Creating canister "hello"...
"hello" canister created with canister id: "rrkah-fqaaa-aaaaa-aaaaq-cai"
Creating canister "hello_assets"...
"hello_assets" canister created with canister id: "ryjl3-tyaaa-aaaaa-aaaba-cai"
Building canisters...
Building frontend...
Installing canisters...
Creating UI canister on the local network.
The UI canister on the "local" network is "r7inp-6aaaa-aaaaa-aaabq-cai"
Installing code for canister hello, with canister_id rrkah-fqaaa-aaaaa-aaaaq-cai
Installing code for canister hello_assets, with canister_id ryjl3-tyaaa-aaaaa-aaaba-cai
Uploading assets to asset canister...
Starting batch.
Staging contents of new and changed assets:
  /main.css 1/1 (537 bytes)
  /main.css (gzip) 1/1 (297 bytes)
  /index.js 1/1 (613369 bytes)
  /index.js (gzip) 1/1 (146412 bytes)
  /index.js.map 1/1 (663443 bytes)
  /sample-asset.txt 1/1 (24 bytes)
  /favicon.ico 1/1 (15406 bytes)
  /index.html (gzip) 1/1 (382 bytes)
  /index.js.map (gzip) 1/1 (150713 bytes)
  /index.html 1/1 (663 bytes)
  /logo.png 1/1 (25397 bytes)
Committing batch.
Deployed canisters.
URLs:
  Frontend:
    hello_assets: http://127.0.0.1:8000/?canisterId=ryjl3-tyaaa-aaaaa-aaaba-cai
  Candid:
    hello: http://127.0.0.1:8000/?canisterId=r7inp-6aaaa-aaaaa-aaabq-cai&id=rrkah-fqaaa-aaaaa-aaaaq-cai
```

I learn:

- the path to my (I assume it's mine) identity is `~/.config/dfx/identity/default/identity.pem`

I open the web page for `hello_assets` and see
a page with a text entry box and a button that says `Click Me`.

I enter my name and click the button.

Nothing happens.

The web console shows errors:

```
POST http://127.0.0.1:8000/api/v2/canister/rrkah-fqaaa-aaaaa-aaaaq-cai/call 400 (Bad Request)
call @ index.js:458
await in call (async)
caller @ index.js:200
handler @ index.js:221
(anonymous) @ index.js:17881

Uncaught (in promise) Error: Server returned an error:
  Code: 400 (Bad Request)
  Body: Specified ingress_expiry not within expected range:
Minimum allowed expiry: 2022-05-10 09:03:31.088945300 UTC
Maximum allowed expiry: 2022-05-10 09:09:01.088945300 UTC
Provided expiry:        2022-05-10 16:00:29.709 UTC
Local replica time:     2022-05-10 09:03:31.088946700 UTC

    at HttpAgent.call (index.js:462:19)
    at async caller (index.js:200:45)
    at async HTMLFormElement.<anonymous> (index.js:17881:20)
```

I see errors about time and suspect this is a common WSL issue
where the WSL clock gets out of sync.

I run

```
sudo hwclock -s
```

kill and restart `dfx start` and try again, and the dapp works.

I learn:

- interacting with ICP requires an accurate clock


### Testing on the command line

I can interact with the canister on the command line:

```
$ dfx canister call hello greet everyone
("Hello, everyone!")
```

I visited the webpage before by visiting the dfx server,
but I can apparently also start node with `npm start`
and visit at `localhost:8080`.
I don't bother to do that for now.


### Deploying to the network (2022/05/11)

Still going through the quick start hello world tutorial.
I need to acquire _cycles_, gas.

I ping the internet computer:

```
$ dfx ping ic
{
  "ic_api_version": "0.18.0"  "impl_hash": "b1d54efe7bc5a93a707f64afdbe6d95d172dd976873d4a44989cfdf9fd8d1f45"  "impl_version": "3d6fc111c09d316b2ed28208e4a8202d9293ecb0"  "replica_health_status": "healthy"  "root_key": [48, 129, 130, 48, 29, 6, 13, 43, ... (many bytes)
}
```

It's just splatted debug formatting of some kind. Not even valid JSON that I can pipe through a pretty-printer. Look at that huge byte array...

At least it works though.

I am going to acquire cycles from the faucet.

### Claiming a cycles airdrop

Following the instructions here:

> [https://smartcontracts.org/docs/current/developer-docs/quickstart/cycles-faucet/](https://smartcontracts.org/docs/current/developer-docs/quickstart/cycles-faucet/)

I navigate to

> [https://faucet.dfinity.org](https://faucet.dfinity.org)

The instructions in the developer docs say I'll have to authenticate with GitHub,
but the faucet app says I have to authenticate with Twitter.
I was not enthusiastic about authenticating with GitHub,
and am even more turned off by having to link my Twitter account to this faucet.

Is there no devnet for IC where I can just get an airdrop for free?

I ask in the dfinity Supernova Hackathon #general channel:

> I am trying to follow the instructions to use the cycles faucet and the faucet
  app wants me to authenticate with twitter. Is there any other way to get an
  airdrop?

> These instructions and hoops make it seem like they are for the mainnet. Is
  there a devnet with free airdrops?

For now I am going to skip the step of deploying to a real network.
I can work with the localnet.


## Starting from an example

I decide that I want to just start writing something.
I know that for my dapp I will need to know how to store data on behalf of a user.
So I am going to look for an example that shows how to write data.

The [examples] repo contains an example called `svelte-motoko-starter` that sounds
exactly like what I want: Svelte on the frontend, Motoko on the backend, and
the description says it uses Internet Identity, ICP's authentication mechanism.

[examples]: https://github.com/dfinity/examples
