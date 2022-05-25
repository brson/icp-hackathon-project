<script>
  import Auth from "./components/Auth.svelte";
  import CanisterIds from "./components/CanisterIds.svelte";
  import LoadingView from "./components/LoadingView.svelte";
</script>

<main>
  <section>
    <h1>Your Forever Wiki</h1>
  </section>

  <section id="main-view">
    <LoadingView />
    <!--<ArticleView id="page-view"/>-->
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
