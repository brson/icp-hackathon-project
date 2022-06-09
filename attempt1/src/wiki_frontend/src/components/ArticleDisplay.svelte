<script>
  export let articleName;
  export let articleMarkup;

  import * as commonmark from "commonmark";

  let parser = new commonmark.Parser();
  let writer = new commonmark.HtmlRenderer({
    safe: true
  });
  let parsed = parser.parse(articleMarkup);
  let rendered = writer.render(parsed);
</script>

<article>
  <header>
    <h1>{articleName}</h1>
  </header>

  <div>
    {@html rendered}
  </div>
</article>

