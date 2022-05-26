<script>
  // The name of the article.
  // We will look up the article's canister in the wiki
  // and load its markup from there.
  export let articleName;

  import Loading from "./Loading.svelte";
  import ArticleDisplay from "./ArticleDisplay.svelte";

  import { Actor, HttpAgent } from "@dfinity/agent";

  import * as PageBackendDid from "../../../declarations/page_backend/page_backend.did.js";

  let loaded = false;

  let icHost = "http://localhost:8000"; // todo
  let agentOptions = {
    host: icHost
  };

  let articleCanisterId = process.env.PAGE_BACKEND_CANISTER_ID; // todo
  let articleAgent = new HttpAgent({ ...agentOptions });

  // todo put this somewhere more sensible
  // Fetch root key for certificate validation during development
  if (process.env.NODE_ENV !== "production") {
    articleAgent.fetchRootKey().catch((err) => {
      console.warn(
        "Unable to fetch root key. Check to ensure that your local replica is running"
      );
      console.error(err);
    });
  }

  let articleActor = Actor.createActor(PageBackendDid.idlFactory, {
    agent: articleAgent,
    canisterId: articleCanisterId
  });

  let articleMarkupPromise = articleActor.getFullPageMarkup();

</script>

<div id="article-container">
  {#await articleMarkupPromise}
    Loading article markup...
  {:then articleMarkup}
    <ArticleView {articleMarkup} />
  {/await}
</div>
