<script>
  import Auth from "./components/Auth.svelte";
  import Article from "./components/Article.svelte";

  import * as canisterIds from "./store/canisterIds";

  console.log(`loaded ${new Date().getTime()}`);
  setTimeout(() => console.log("."), 5000);
</script>

<main>
  <section>
    <h1>Your Forever Wiki</h1>
  </section>

  <section>
    <Article articleName="index" />
  </section>
</main>

<style>
  /*section {
    padding: var(--base-margin-size) var(--base-margin-size) 0rem var(--base-margin-size);
  }

  section:last-of-type {
    padding: var(--base-margin-size);
  }*/
  
  main {
    color: var(--ink-color);
    background-color: var(--paper-color);
    min-height: 100%;
  }

  main {
    display: flex;
    flex-direction: column;
    gap: var(--base-margin-size);
    padding: var(--base-margin-size);
  }

  /* set the text area off the background */
  main {
    box-shadow: 0px 0px 4px 4px var(--void-accent-color);
  }
</style>

