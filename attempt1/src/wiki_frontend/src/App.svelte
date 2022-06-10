<script>
  import Auth from "./components/Auth.svelte";
  import Article from "./components/Article.svelte";

  import * as canisterIds from "./store/canisterIds";

  console.log(`loaded ${new Date().getTime()}`);
  setTimeout(() => console.log("."), 5000);
</script>

<main>
  <Article articleName="index" />
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

