<script>
  import Auth from "./components/Auth.svelte";
  import Article from "./components/Article.svelte";

  import * as canisterIds from "./store/canisterIds";
  import * as pageModes from "./store/pageModes";

  let url = document.location.href;

  let {
    articleName,
    articleMode,
  } = pageModes.parseUrl(url);

  console.log(`loaded ${new Date().getTime()}`);
  setTimeout(() => console.log("."), 5000);

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

