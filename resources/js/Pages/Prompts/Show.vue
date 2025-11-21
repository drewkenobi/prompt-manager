<template>
  <div class="py-12">
    <div class="max-w-4xl mx-auto sm:px-6 lg:px-8">
      <!-- Header del prompt -->
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg mb-6">
        <div class="p-8">
          <div class="flex justify-between items-start mb-4">
            <h1 class="text-4xl font-bold text-gray-900 dark:text-white">
              {{ prompt.title[$i18n.locale] || prompt.title.en }}
            </h1>
            
            <!-- Botones de acción -->
            <div class="flex gap-2">
              <button
                v-if="$page.props.auth.user"
                @click="toggleFavorite"
                class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                :class="{ 'text-red-500': isFavorited }"
              >
                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                </svg>
              </button>
              
              <button
                @click="copyPrompt"
                class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-md transition-colors duration-200 flex items-center gap-2"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                </svg>
                {{ copied ? $t('prompts.copied') : $t('prompts.copy') }}
              </button>
            </div>
          </div>

          <!-- Descripción -->
          <p class="text-lg text-gray-600 dark:text-gray-400 mb-6">
            {{ prompt.description[$i18n.locale] || prompt.description.en }}
          </p>

          <!-- Metadatos -->
          <div class="flex flex-wrap gap-6 text-sm text-gray-500 dark:text-gray-400 mb-6">
            <div class="flex items-center gap-2">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
              <span>{{ prompt.user.name }}</span>
            </div>
            
            <div class="flex items-center gap-2">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
              <span>{{ prompt.views_count }} {{ $t('prompts.views') }}</span>
            </div>

            <div class="flex items-center gap-2">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
              </svg>
              <span>{{ prompt.copies_count }} {{ $t('prompts.copies') }}</span>
            </div>

            <div v-if="prompt.category" class="flex items-center gap-2">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
              </svg>
              <span>{{ $t(`prompts.categories.${prompt.category}`) }}</span>
            </div>
          </div>

          <!-- Tags -->
          <div v-if="prompt.tags && prompt.tags.length > 0" class="flex flex-wrap gap-2">
            <span
              v-for="tag in prompt.tags"
              :key="tag"
              class="px-3 py-1 text-sm bg-indigo-100 dark:bg-indigo-900 text-indigo-800 dark:text-indigo-200 rounded-full"
            >
              #{{ tag }}
            </span>
          </div>
        </div>
      </div>

      <!-- Contenido del prompt -->
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-8">
          <h2 class="text-2xl font-semibold text-gray-900 dark:text-white mb-4">
            {{ $t('prompts.content') }}
          </h2>
          <CodeBlock :code="prompt.content" language="markdown" />
        </div>
      </div>

      <!-- Botón volver -->
      <div class="mt-6">
        <Link
          :href="route('prompts.index')"
          class="inline-flex items-center text-indigo-600 hover:text-indigo-800 dark:text-indigo-400 dark:hover:text-indigo-300"
        >
          <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
          </svg>
          {{ $t('prompts.back_to_list') }}
        </Link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import CodeBlock from '@/Components/CodeBlock.vue';

// Props
const props = defineProps({
  prompt: Object,
});

// Estado local
const copied = ref(false);
const isFavorited = ref(false);

// Copiar prompt al portapapeles
const copyPrompt = async () => {
  try {
    await navigator.clipboard.writeText(props.prompt.content);
    copied.value = true;
    
    // Notificar al backend del copiado
    router.post(route('prompts.copy', props.prompt.id), {}, {
      preserveState: true,
      preserveScroll: true,
    });

    setTimeout(() => {
      copied.value = false;
    }, 2000);
  } catch (err) {
    console.error('Error al copiar:', err);
  }
};

// Toggle favorito
const toggleFavorite = () => {
  router.post(
    route('prompts.favorite', props.prompt.id),
    {},
    {
      preserveState: true,
      preserveScroll: true,
      onSuccess: (page) => {
        isFavorited.value = !isFavorited.value;
      },
    }
  );
};
</script>
