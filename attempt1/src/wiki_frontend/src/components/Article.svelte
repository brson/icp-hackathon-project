<script>

  // The name of the article.
  // We will look up the article's canister in the wiki
  // and load its markup from there.
  export let articleName;

  import { createEventDispatcher } from 'svelte';

  import Loading from "./Loading.svelte";
  import ArticleDisplay from "./ArticleDisplay.svelte";
  import ArticleEdit from "./ArticleEdit.svelte";

  import { Actor, HttpAgent } from "@dfinity/agent";

  import * as PageBackendDid from "../../../declarations/page_backend/page_backend.did.js";

  const dispatch = createEventDispatcher();

  let loaded = false;
  let editing = false;
  let articleEditComponent;

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

  function onEditButtonClick() {
    editing = true;
  }

  async function onSaveButtonClick() {
    console.assert(articleEditComponent);
    const newMarkup = articleEditComponent.getMarkup();
    console.log(newMarkup);
    articleMarkupPromise = Promise.resolve(newMarkup);
    editing = false;

    await saveMarkup(newMarkup);
  }

  function onCancelButtonClick() {
    editing = false;
  }

  async function saveMarkup(markup) {
    await articleActor.setFullPageMarkup(markup);
    console.log("saved");
  }

  function onHistoryButtonClick() {
    dispatch("loadHistory", {});
  }

</script>

<div id="container">

  {#await articleMarkupPromise}
    Loading article markup...
  {:then articleMarkup}
    {#if !editing}

  <menu>
    <li>
      <button type="button" on:click={onHistoryButtonClick}>
        History
      </button>
    </li>
    <li>
      <button type="button" on:click={onEditButtonClick}>
        Edit
      </button>
    </li>
  </menu>

  <article>
    <ArticleDisplay {articleMarkup} />
  </article>

    {:else}

  <menu>
    <li>
      <button type="button" on:click={onSaveButtonClick}>
        Save
      </button>
    </li>
    <li>
      <button type="button" on:click={onCancelButtonClick}>
        Cancel
      </button>
    </li>
  </menu>

  <div>
    <ArticleEdit {articleMarkup} bind:this={articleEditComponent}/>
  </div>

    {/if}
  {/await}

</div>

<style>
  #container {
    display: flex;
    flex-direction: column;
    gap: var(--base-margin-size);
  }

  menu {
    display: flex;
    justify-content: flex-end;
    gap: calc(var(--base-margin-size) / 2);
  }
</style>
