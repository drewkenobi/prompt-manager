<template>
  <div class="py-12">
    <div class="max-w-4xl mx-auto sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="mb-6">
        <Link
          :href="route('dashboard.prompts')"
          class="inline-flex items-center text-indigo-600 hover:text-indigo-800 dark:text-indigo-400 dark:hover:text-indigo-300 mb-4"
        >
          <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
          </svg>
          {{ $t('dashboard.my_prompts') }}
        </Link>
        
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white">
          {{ $t('editor.edit_prompt') }}
        </h1>
      </div>

      <!-- Formulario -->
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-8">
          <PromptEditor
            v-model="form"
            @save="handleSave"
            @cancel="handleCancel"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import PromptEditor from '@/Components/PromptEditor.vue';

// Props del servidor
const props = defineProps({
  prompt: Object,
});

// Formulario con datos del prompt
const form = reactive({
  title: { ...props.prompt.title },
  description: { ...props.prompt.description },
  content: props.prompt.content,
  category: props.prompt.category || '',
  tags: [...(props.prompt.tags || [])],
  visibility: props.prompt.visibility,
});

// Actualizar prompt
const handleSave = (data) => {
  router.put(route('prompts.update', props.prompt.id), data);
};

// Cancelar y volver
const handleCancel = () => {
  router.visit(route('dashboard.prompts'));
};
</script>
