import './bootstrap';
import '../css/app.css';

import { createApp, h } from 'vue';
import { createInertiaApp } from '@inertiajs/vue3';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { ZiggyVue } from '../../vendor/tightenco/ziggy/dist/vue.m';

const appName = window.document.getElementsByTagName('title')[0]?.innerText || 'Prompts Manager';

createInertiaApp({
    title: (title) => `${title} - ${appName}`,
    resolve: (name) => resolvePageComponent(`./Pages/${name}.vue`, import.meta.glob('./Pages/**/*.vue')),
    setup({ el, App, props, plugin }) {
        const app = createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(ZiggyVue, Ziggy);
        
        // TODO: Configurar Vue i18n para soporte multiidioma completo
        // Esta es una implementación temporal básica.
        // Para producción, instalar y configurar vue-i18n:
        // npm install vue-i18n@9
        // import { createI18n } from 'vue-i18n';
        // const i18n = createI18n({ locale: 'en', messages: { es, en } });
        // app.use(i18n);
        
        // Función $t temporal para las vistas (reemplazar con vue-i18n real)
        app.config.globalProperties.$t = (key) => {
            // Implementación básica - reemplazar con vue-i18n real
            const translations = {
                'prompts.title': 'Public Prompts',
                'prompts.search_placeholder': 'Search prompts...',
                'prompts.all_categories': 'All categories',
                'prompts.categories.general': 'General',
                'prompts.categories.code': 'Code',
                'prompts.categories.writing': 'Writing',
                'prompts.categories.analysis': 'Analysis',
                'prompts.view_details': 'View details',
                'prompts.no_prompts_found': 'No prompts found',
                'prompts.views': 'views',
                'prompts.copies': 'copies',
                'prompts.content': 'Prompt Content',
                'prompts.back_to_list': 'Back to list',
                'prompts.copy': 'Copy',
                'prompts.copied': 'Copied!',
                'prompts.visibility.public': 'Public',
                'prompts.visibility.private': 'Private',
                'prompts.visibility.unlisted': 'Unlisted',
                'dashboard.my_prompts': 'My Prompts',
                'dashboard.create_prompt': 'Create Prompt',
                'dashboard.no_prompts_yet': 'You haven\'t created any prompts yet',
                'dashboard.create_first_prompt': 'Create my first prompt',
                'dashboard.edit': 'Edit',
                'dashboard.delete': 'Delete',
                'editor.title': 'Title',
                'editor.title_es': 'Title in Spanish',
                'editor.title_en': 'Title in English',
                'editor.description': 'Description',
                'editor.description_es': 'Description in Spanish',
                'editor.description_en': 'Description in English',
                'editor.content': 'Content',
                'editor.content_placeholder': 'Write your prompt here...',
                'editor.category': 'Category',
                'editor.select_category': 'Select a category',
                'editor.visibility': 'Visibility',
                'editor.tags': 'Tags',
                'editor.tags_placeholder': 'Tags separated by comma',
                'editor.save': 'Save',
                'editor.cancel': 'Cancel',
                'editor.create_prompt': 'Create New Prompt',
                'editor.edit_prompt': 'Edit Prompt',
                'code.copied': 'Copied!',
                'code.copy_code': 'Copy code',
                'dashboard.confirm_delete': 'Are you sure you want to delete this prompt?',
            };
            return translations[key] || key;
        };
        
        return app.mount(el);
    },
    progress: {
        color: '#4F46E5',
    },
});
