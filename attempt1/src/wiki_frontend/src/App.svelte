<script>
  import Auth from "./components/Auth.svelte";
  import CanisterIds from "./components/CanisterIds.svelte";
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

  <section>
    <CanisterIds />
  </section>
</main>

<style>
  section {
    padding: 2rem 2rem 0rem 2rem;
  }
</style>
