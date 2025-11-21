<template>
  <div class="code-block-wrapper">
    <div class="code-block-header">
      <span class="code-language">{{ language }}</span>
      <button
        @click="copyCode"
        class="copy-button"
        :title="copied ? 'Copiado!' : 'Copiar código'"
      >
        <svg v-if="!copied" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
        </svg>
        <svg v-else class="w-5 h-5 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
        </svg>
      </button>
    </div>
    <pre class="code-block"><code ref="codeElement" :class="`language-${language}`">{{ code }}</code></pre>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue';
import hljs from 'highlight.js';
import 'highlight.js/styles/github-dark.css';

// Props
const props = defineProps({
  code: {
    type: String,
    required: true,
  },
  language: {
    type: String,
    default: 'plaintext',
  },
});

// Refs
const codeElement = ref(null);
const copied = ref(false);

// Resaltar código cuando se monta el componente
onMounted(() => {
  highlightCode();
});

// Resaltar código cuando cambia
watch(() => props.code, () => {
  highlightCode();
});

// Función para resaltar código
const highlightCode = () => {
  if (codeElement.value) {
    hljs.highlightElement(codeElement.value);
  }
};

// Copiar código al portapapeles
const copyCode = async () => {
  try {
    await navigator.clipboard.writeText(props.code);
    copied.value = true;
    setTimeout(() => {
      copied.value = false;
    }, 2000);
  } catch (err) {
    console.error('Error al copiar código:', err);
  }
};
</script>

<style scoped>
.code-block-wrapper {
  @apply rounded-lg overflow-hidden border border-gray-200 dark:border-gray-700 bg-gray-900;
}

.code-block-header {
  @apply flex justify-between items-center px-4 py-2 bg-gray-800 border-b border-gray-700;
}

.code-language {
  @apply text-sm font-mono text-gray-400 uppercase;
}

.copy-button {
  @apply p-1 text-gray-400 hover:text-white transition-colors duration-200;
}

.code-block {
  @apply m-0 p-4 overflow-x-auto text-sm;
}

.code-block code {
  @apply font-mono;
}
</style>
