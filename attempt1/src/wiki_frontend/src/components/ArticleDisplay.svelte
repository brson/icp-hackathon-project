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

<article>
  {@html rendered}
</article>

