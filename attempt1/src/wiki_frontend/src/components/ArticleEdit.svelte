<script>
  export let articleMarkup;

  import {EditorState} from "@codemirror/state";
  import {EditorView, keymap} from "@codemirror/view";
  import {defaultKeymap} from "@codemirror/commands";

  let editorContainer;

  // todo don't understand why editorContainer is sometimes null
  $: if (editorContainer) {
    let startState = EditorState.create({
      doc: articleMarkup,
      extensions: [keymap.of(defaultKeymap)]
    })

    let view = new EditorView({
      state: startState,
      parent: editorContainer
    })
  }

</script>

<div bind:this={editorContainer}>

</div>

