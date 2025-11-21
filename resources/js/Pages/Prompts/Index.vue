<template>
  <div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
      <!-- Header con búsqueda y filtros -->
      <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg mb-6">
        <div class="p-6">
          <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-4">
            {{ $t('prompts.title') }}
          </h1>
          
          <!-- Búsqueda y filtros -->
          <div class="flex flex-col md:flex-row gap-4 mt-4">
            <div class="flex-1">
              <input
                v-model="searchQuery"
                type="text"
                :placeholder="$t('prompts.search_placeholder')"
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                @input="debouncedSearch"
              />
            </div>
            <div class="w-full md:w-48">
              <select
                v-model="selectedCategory"
                class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                @change="filterByCategory"
              >
                <option value="">{{ $t('prompts.all_categories') }}</option>
                <option value="general">{{ $t('prompts.categories.general') }}</option>
                <option value="code">{{ $t('prompts.categories.code') }}</option>
                <option value="writing">{{ $t('prompts.categories.writing') }}</option>
                <option value="analysis">{{ $t('prompts.categories.analysis') }}</option>
              </select>
            </div>
          </div>
        </div>
      </div>

      <!-- Grid de prompts -->
      <div v-if="prompts.data.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="prompt in prompts.data"
          :key="prompt.id"
          class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg hover:shadow-lg transition-shadow duration-200"
        >
          <div class="p-6">
            <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-2">
              {{ prompt.title.es || prompt.title.en }}
            </h3>
            <p class="text-gray-600 dark:text-gray-400 mb-4 line-clamp-3">
              {{ prompt.description.es || prompt.description.en }}
            </p>
            
            <!-- Metadatos -->
            <div class="flex items-center gap-4 text-sm text-gray-500 dark:text-gray-400 mb-4">
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
            </div>

            <!-- Tags -->
            <div v-if="prompt.tags && prompt.tags.length > 0" class="flex flex-wrap gap-2 mb-4">
              <span
                v-for="tag in prompt.tags.slice(0, 3)"
                :key="tag"
                class="px-2 py-1 text-xs bg-indigo-100 dark:bg-indigo-900 text-indigo-800 dark:text-indigo-200 rounded"
              >
                {{ tag }}
              </span>
            </div>

            <!-- Botón ver más -->
            <Link
              :href="route('prompts.show', prompt.id)"
              class="inline-flex items-center px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-md transition-colors duration-200"
            >
              {{ $t('prompts.view_details') }}
            </Link>
          </div>
        </div>
      </div>

      <!-- Mensaje si no hay prompts -->
      <div v-else class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
        <div class="p-12 text-center">
          <p class="text-gray-600 dark:text-gray-400 text-lg">
            {{ $t('prompts.no_prompts_found') }}
          </p>
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
import { ref } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import { useDebounceFn } from '@vueuse/core';

// Props recibidos del controller
const props = defineProps({
  prompts: Object,
  filters: Object,
});

// Estado local
const searchQuery = ref(props.filters?.search || '');
const selectedCategory = ref(props.filters?.category || '');

// Búsqueda con debounce
const debouncedSearch = useDebounceFn(() => {
  router.get(
    route('prompts.index'),
    {
      search: searchQuery.value,
      category: selectedCategory.value,
    },
    {
      preserveState: true,
      preserveScroll: true,
    }
  );
}, 500);

// Filtrar por categoría
const filterByCategory = () => {
  router.get(
    route('prompts.index'),
    {
      search: searchQuery.value,
      category: selectedCategory.value,
    },
    {
      preserveState: true,
      preserveScroll: true,
    }
  );
};
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
