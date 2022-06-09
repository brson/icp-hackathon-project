<script>
  export let articleName;
  export let articleMarkup;

  import {EditorState} from "@codemirror/state";
  import {EditorView, keymap} from "@codemirror/view";
  import {defaultKeymap} from "@codemirror/commands";

  let editorContainer;
  let editorView

  // todo don't understand why editorContainer is sometimes undefined
  $: if (editorContainer) {
    let startState = EditorState.create({
      doc: articleMarkup,
      extensions: [keymap.of(defaultKeymap)]
    })

    editorView = new EditorView({
      state: startState,
      parent: editorContainer
    })
  }

  export function getMarkup() {
    console.assert(editorView);
    return editorView.state.doc.sliceString(0);
  }

</script>

<section>
  <header>
    <h1>{articleName}</h1>
  </header>

  <div bind:this={editorContainer}></div>
</section>
