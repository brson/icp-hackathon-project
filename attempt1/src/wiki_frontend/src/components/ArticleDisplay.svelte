<script>
  export let articleMarkup;

  import * as commonmark from "commonmark";

  let parser = new commonmark.Parser();
  let writer = new commonmark.HtmlRenderer({
    safe: true
  });
  let parsed = parser.parse(articleMarkup);
  let rendered = writer.render(parsed);
</script>

<div id="container">
  {@html rendered}
</div>

<style>
  #container {
    display: flex;
    flex-direction: column;
    gap: 1em;
  }
</style>
