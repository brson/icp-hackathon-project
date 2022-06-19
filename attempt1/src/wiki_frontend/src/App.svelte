<script>
  import Auth from "./components/Auth.svelte";
  import Article from "./components/Article.svelte";

  import * as canisterIds from "./modules/canisterIds";
  import * as pageModes from "./modules/pageModes";

  let url = document.location.href;

  $: mode = pageModes.parseUrl(url);
  $: articleName = mode.articleName;
  $: articleMode = mode.articleMode;

  $: {
    console.log(`articleName: ${articleName}` + articleName);
    console.log(`articleMode: ${articleMode}`);
  }

  console.log(`loaded ${new Date().getTime()}`);
  setTimeout(() => console.log("."), 5000);

  // Set up SPA navigation handling.

  window.addEventListener("popstate", () => {
    url = document.location.href;
  });

  function navigate(newUrl) {
    document.location.assign(newUrl);
    url = document.location.href;
  }

  function onLoadHistory() {
    console.log("load history");
    navigate("#/{articleName}?history");
  }

</script>

<main>
  <Article {articleName} on:loadHistory={onLoadHistory} />
</main>

<style>
  main {
    color: var(--ink-color);
    background-color: var(--paper-color);
    min-height: 100%;
  }

  main {
    padding: var(--base-margin-size);
  }

  /* set the text area off the background */
  main {
    box-shadow: 0px 0px 4px 4px var(--void-accent-color);
  }
</style>

