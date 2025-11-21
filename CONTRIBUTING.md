# Guía de Contribución / Contributing Guide

[🇪🇸 Español](#español) | [🇬🇧 English](#english)

---

## Español

### 🤝 Cómo Contribuir

¡Gracias por tu interés en contribuir a Prompts & Snippets Manager! Este proyecto da la bienvenida a contribuciones de todo tipo.

### Proceso de Contribución

1. **Fork el repositorio**
   ```bash
   # Haz fork del repositorio en GitHub
   git clone https://github.com/TU_USUARIO/prompt-manager.git
   cd prompt-manager
   ```

2. **Crea una rama para tu feature**
   ```bash
   git checkout -b feat/mi-nueva-caracteristica
   # o
   git checkout -b fix/arreglar-bug
   ```

3. **Realiza tus cambios**
   - Escribe código limpio y bien documentado
   - Añade tests si es posible
   - Sigue las convenciones de código del proyecto

4. **Commit tus cambios**
   ```bash
   git add .
   git commit -m "feat: añadir nueva característica"
   ```

   Usa prefijos convencionales:
   - `feat:` para nuevas características
   - `fix:` para correcciones de bugs
   - `docs:` para cambios en documentación
   - `style:` para cambios de formato
   - `refactor:` para refactorizaciones
   - `test:` para añadir tests
   - `chore:` para tareas de mantenimiento

5. **Push a tu fork**
   ```bash
   git push origin feat/mi-nueva-caracteristica
   ```

6. **Abre un Pull Request**
   - Ve a GitHub y abre un PR desde tu fork
   - Describe claramente qué cambios realizaste y por qué
   - Referencia cualquier issue relacionado

### Convenciones de Código

#### PHP/Laravel
- Sigue PSR-12 para estilo de código
- Usa tipos estrictos cuando sea posible
- Documenta métodos públicos con PHPDoc
- Los comentarios deben estar en español
- Los nombres de variables, clases y métodos en inglés

```php
<?php

namespace App\Models;

/**
 * Modelo para gestionar prompts
 * 
 * Este modelo representa un prompt con soporte multiidioma.
 */
class Prompt extends Model
{
    /**
     * Obtener prompts públicos
     */
    public function scopePublic($query)
    {
        return $query->where('visibility', 'public');
    }
}
```

#### Vue/JavaScript
- Usa Composition API de Vue 3
- Componentes en PascalCase
- Props y eventos bien documentados
- Los comentarios deben estar en español
- Los nombres de variables y funciones en inglés

```vue
<script setup>
/**
 * Componente para mostrar un prompt
 * 
 * @props {Object} prompt - El objeto prompt a mostrar
 */
const props = defineProps({
  prompt: Object,
});
</script>
```

#### CSS/Tailwind
- Usa clases de Tailwind cuando sea posible
- Evita CSS custom a menos que sea necesario
- Usa dark mode con clases dark:

```vue
<div class="bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
  <!-- contenido -->
</div>
```

### Tests

Añade tests para nuevas características:

```php
<?php

namespace Tests\Feature;

use Tests\TestCase;

class PromptTest extends TestCase
{
    /**
     * Test que verifica la creación de un prompt
     */
    public function test_user_can_create_prompt()
    {
        // ...
    }
}
```

Ejecuta tests con:
```bash
php artisan test
```

### Reportar Bugs

Usa el sistema de issues de GitHub:

1. Verifica que el bug no haya sido reportado
2. Crea un nuevo issue con:
   - Título descriptivo
   - Pasos para reproducir
   - Comportamiento esperado vs actual
   - Screenshots si aplica
   - Versión de PHP, Laravel, navegador, etc.

### Solicitar Features

1. Verifica que no exista una solicitud similar
2. Crea un issue describiendo:
   - El problema que resuelve
   - Cómo lo usarías
   - Alternativas consideradas

### Código de Conducta

- Sé respetuoso y profesional
- Acepta críticas constructivas
- Enfócate en lo mejor para el proyecto
- Ayuda a otros contribuidores

---

## English

### 🤝 How to Contribute

Thank you for your interest in contributing to Prompts & Snippets Manager! This project welcomes contributions of all kinds.

### Contribution Process

1. **Fork the repository**
   ```bash
   # Fork the repository on GitHub
   git clone https://github.com/YOUR_USERNAME/prompt-manager.git
   cd prompt-manager
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feat/my-new-feature
   # or
   git checkout -b fix/fix-bug
   ```

3. **Make your changes**
   - Write clean, well-documented code
   - Add tests if possible
   - Follow project code conventions

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

   Use conventional prefixes:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation changes
   - `style:` for formatting changes
   - `refactor:` for refactoring
   - `test:` for adding tests
   - `chore:` for maintenance tasks

5. **Push to your fork**
   ```bash
   git push origin feat/my-new-feature
   ```

6. **Open a Pull Request**
   - Go to GitHub and open a PR from your fork
   - Clearly describe what changes you made and why
   - Reference any related issues

### Code Conventions

#### PHP/Laravel
- Follow PSR-12 for code style
- Use strict types when possible
- Document public methods with PHPDoc
- Comments should be in Spanish
- Variable, class, and method names in English

```php
<?php

namespace App\Models;

/**
 * Model to manage prompts
 * 
 * This model represents a prompt with multi-language support.
 */
class Prompt extends Model
{
    /**
     * Get public prompts
     */
    public function scopePublic($query)
    {
        return $query->where('visibility', 'public');
    }
}
```

#### Vue/JavaScript
- Use Vue 3 Composition API
- Components in PascalCase
- Well-documented props and events
- Comments should be in Spanish
- Variable and function names in English

```vue
<script setup>
/**
 * Component to display a prompt
 * 
 * @props {Object} prompt - The prompt object to display
 */
const props = defineProps({
  prompt: Object,
});
</script>
```

#### CSS/Tailwind
- Use Tailwind classes when possible
- Avoid custom CSS unless necessary
- Use dark mode with dark: classes

```vue
<div class="bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
  <!-- content -->
</div>
```

### Tests

Add tests for new features:

```php
<?php

namespace Tests\Feature;

use Tests\TestCase;

class PromptTest extends TestCase
{
    /**
     * Test that verifies prompt creation
     */
    public function test_user_can_create_prompt()
    {
        // ...
    }
}
```

Run tests with:
```bash
php artisan test
```

### Reporting Bugs

Use GitHub's issue system:

1. Check if the bug hasn't been reported
2. Create a new issue with:
   - Descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - PHP, Laravel, browser version, etc.

### Requesting Features

1. Check that a similar request doesn't exist
2. Create an issue describing:
   - The problem it solves
   - How you would use it
   - Alternatives considered

### Code of Conduct

- Be respectful and professional
- Accept constructive criticism
- Focus on what's best for the project
- Help other contributors
