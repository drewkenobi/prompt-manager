<template>
  <div class="prompt-editor">
    <div class="mb-4">
      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
        {{ $t('editor.title') }}
      </label>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <input
          v-model="form.title.es"
          type="text"
          :placeholder="$t('editor.title_es')"
          class="rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        />
        <input
          v-model="form.title.en"
          type="text"
          :placeholder="$t('editor.title_en')"
          class="rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        />
      </div>
    </div>

    <div class="mb-4">
      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
        {{ $t('editor.description') }}
      </label>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <textarea
          v-model="form.description.es"
          :placeholder="$t('editor.description_es')"
          rows="3"
          class="rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        ></textarea>
        <textarea
          v-model="form.description.en"
          :placeholder="$t('editor.description_en')"
          rows="3"
          class="rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        ></textarea>
      </div>
    </div>

    <div class="mb-4">
      <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
        {{ $t('editor.content') }}
      </label>
      <textarea
        v-model="form.content"
        :placeholder="$t('editor.content_placeholder')"
        rows="12"
        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white font-mono"
      ></textarea>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          {{ $t('editor.category') }}
        </label>
        <select
          v-model="form.category"
          class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        >
          <option value="">{{ $t('editor.select_category') }}</option>
          <option value="general">{{ $t('prompts.categories.general') }}</option>
          <option value="code">{{ $t('prompts.categories.code') }}</option>
          <option value="writing">{{ $t('prompts.categories.writing') }}</option>
          <option value="analysis">{{ $t('prompts.categories.analysis') }}</option>
        </select>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          {{ $t('editor.visibility') }}
        </label>
        <select
          v-model="form.visibility"
          class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        >
          <option value="public">{{ $t('prompts.visibility.public') }}</option>
          <option value="private">{{ $t('prompts.visibility.private') }}</option>
          <option value="unlisted">{{ $t('prompts.visibility.unlisted') }}</option>
        </select>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          {{ $t('editor.tags') }}
        </label>
        <input
          v-model="tagsInput"
          type="text"
          :placeholder="$t('editor.tags_placeholder')"
          class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
          @blur="parseTags"
        />
      </div>
    </div>

    <div v-if="form.tags.length > 0" class="mb-4">
      <div class="flex flex-wrap gap-2">
        <span
          v-for="(tag, index) in form.tags"
          :key="index"
          class="inline-flex items-center gap-1 px-3 py-1 bg-indigo-100 dark:bg-indigo-900 text-indigo-800 dark:text-indigo-200 rounded-full text-sm"
        >
          #{{ tag }}
          <button
            @click="removeTag(index)"
            class="hover:text-indigo-600 dark:hover:text-indigo-400"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </span>
      </div>
    </div>

    <div class="flex justify-end gap-4">
      <button
        type="button"
        @click="$emit('cancel')"
        class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-200"
      >
        {{ $t('editor.cancel') }}
      </button>
      <button
        type="button"
        @click="save"
        class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md transition-colors duration-200"
      >
        {{ $t('editor.save') }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, watch } from 'vue';

// Props
const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({
      title: { es: '', en: '' },
      description: { es: '', en: '' },
      content: '',
      category: '',
      tags: [],
      visibility: 'private',
    }),
  },
});

// Emits
const emit = defineEmits(['update:modelValue', 'save', 'cancel']);

// Formulario reactivo
const form = reactive({
  title: { ...props.modelValue.title },
  description: { ...props.modelValue.description },
  content: props.modelValue.content || '',
  category: props.modelValue.category || '',
  tags: [...(props.modelValue.tags || [])],
  visibility: props.modelValue.visibility || 'private',
});

// Input de tags (separados por coma)
const tagsInput = ref(form.tags.join(', '));

// Parsear tags desde el input
const parseTags = () => {
  if (tagsInput.value) {
    form.tags = tagsInput.value
      .split(',')
      .map(tag => tag.trim())
      .filter(tag => tag.length > 0);
  }
};

// Eliminar tag
const removeTag = (index) => {
  form.tags.splice(index, 1);
  tagsInput.value = form.tags.join(', ');
};

// Guardar
const save = () => {
  emit('save', form);
};

// Sincronizar cambios con v-model
watch(form, (newValue) => {
  emit('update:modelValue', newValue);
}, { deep: true });
</script>

<style scoped>
.prompt-editor {
  @apply space-y-4;
}
</style>
