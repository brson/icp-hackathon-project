<script>
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
      parent: editorContainer,
      extensions: EditorView.theme({
        "&.cm-editor.cm-focused": { "outline-width": "0px" }
      })
    })
  }

  export function getMarkup() {
    console.assert(editorView);
    return editorView.state.doc.sliceString(0);
  }

</script>

<div id="container">
  <div bind:this={editorContainer}></div>
</div>

<style>
  #container {
    outline: var(--ink-color) solid var(--outline-size);
    border-radius: var(--border-radius);
    border: 2px solid rgba(0, 0, 0, 0);
  }
</style>
