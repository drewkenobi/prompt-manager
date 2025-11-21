<template>
  <div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <!-- Header con botón crear -->
      <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-900 dark:text-white">
          {{ $t('dashboard.my_prompts') }}
        </h1>
        <Link
          :href="route('prompts.create')"
          class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-md transition-colors duration-200"
        >
          {{ $t('dashboard.create_prompt') }}
        </Link>
      </div>

      <!-- Lista de prompts -->
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div v-if="prompts.data.length > 0" class="divide-y divide-gray-200 dark:divide-gray-700">
          <div
            v-for="prompt in prompts.data"
            :key="prompt.id"
            class="p-6 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors duration-150"
          >
            <div class="flex justify-between items-start">
              <div class="flex-1">
                <Link
                  :href="route('prompts.show', prompt.id)"
                  class="text-xl font-semibold text-gray-900 dark:text-white hover:text-indigo-600 dark:hover:text-indigo-400"
                >
                  {{ prompt.title.es || prompt.title.en }}
                </Link>
                
                <p class="mt-2 text-gray-600 dark:text-gray-400 line-clamp-2">
                  {{ prompt.description.es || prompt.description.en }}
                </p>

                <!-- Metadatos -->
                <div class="mt-3 flex flex-wrap gap-4 text-sm text-gray-500 dark:text-gray-400">
                  <span class="flex items-center gap-1">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                    {{ prompt.views_count }}
                  </span>
                  
                  <span class="flex items-center gap-1">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
                    </svg>
                    {{ prompt.copies_count }}
                  </span>

                  <span
                    class="px-2 py-1 rounded-full text-xs font-semibold"
                    :class="{
                      'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200': prompt.visibility === 'public',
                      'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200': prompt.visibility === 'private',
                      'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200': prompt.visibility === 'unlisted',
                    }"
                  >
                    {{ $t(`prompts.visibility.${prompt.visibility}`) }}
                  </span>

                  <span class="text-gray-400">
                    {{ formatDate(prompt.created_at) }}
                  </span>
                </div>
              </div>

              <!-- Acciones -->
              <div class="flex gap-2 ml-4">
                <Link
                  :href="route('prompts.edit', prompt.id)"
                  class="p-2 text-indigo-600 hover:text-indigo-800 dark:text-indigo-400 dark:hover:text-indigo-300"
                  :title="$t('dashboard.edit')"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                  </svg>
                </Link>

                <button
                  @click="confirmDelete(prompt)"
                  class="p-2 text-red-600 hover:text-red-800 dark:text-red-400 dark:hover:text-red-300"
                  :title="$t('dashboard.delete')"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Mensaje si no hay prompts -->
        <div v-else class="p-12 text-center">
          <svg class="w-16 h-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <p class="text-gray-600 dark:text-gray-400 text-lg mb-4">
            {{ $t('dashboard.no_prompts_yet') }}
          </p>
          <Link
            :href="route('prompts.create')"
            class="inline-block px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-md transition-colors duration-200"
          >
            {{ $t('dashboard.create_first_prompt') }}
          </Link>
        </div>
      </div>

      <!-- Paginación -->
      <div v-if="prompts.data.length > 0" class="mt-6">
        <div class="flex justify-center">
          <nav class="inline-flex rounded-md shadow">
            <Link
              v-for="link in prompts.links"
              :key="link.label"
              :href="link.url"
              :class="[
                'px-4 py-2 text-sm font-medium',
                link.active
                  ? 'bg-indigo-600 text-white'
                  : 'bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700',
                'border border-gray-300 dark:border-gray-600',
              ]"
              :disabled="!link.url"
              v-html="link.label"
            />
          </nav>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Link, router } from '@inertiajs/vue3';

// Props
const props = defineProps({
  prompts: Object,
});

// Formatear fecha
const formatDate = (date) => {
  return new Date(date).toLocaleDateString(undefined, {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
};

// Confirmar eliminación
const confirmDelete = (prompt) => {
  const title = prompt.title.es || prompt.title.en;
  if (confirm(`Are you sure you want to delete "${title}"?`)) {
    router.delete(route('prompts.destroy', prompt.id));
  }
};
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
