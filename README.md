# Prompts & Snippets Manager 🚀

> Gestor y librería de snippets y prompts para LLM's con Laravel + Inertia + Vue
> 
> Manager and library of snippets and prompts for LLMs with Laravel + Inertia + Vue

[🇪🇸 Español](#español) | [🇬🇧 English](#english)

---

## Español

### 📋 Descripción

**Prompts & Snippets Manager** es una aplicación web full-stack que permite a los usuarios crear, gestionar y compartir prompts y snippets reutilizables para modelos de lenguaje (LLMs). La aplicación está construida con:

- **Backend**: Laravel 10+ (PHP 8.2+)
- **Frontend**: Vue 3 + Inertia.js + Tailwind CSS
- **Base de datos**: MySQL 8.0+
- **Características**:
  - Soporte multiidioma (español e inglés)
  - Autenticación y autorización con Laravel Breeze
  - Gestión de prompts con visibilidad pública/privada/no listada
  - Sistema de favoritos
  - Categorización y etiquetado
  - Resaltado de sintaxis con Highlight.js
  - Editor de código integrado
  - Docker para desarrollo local

### 🎯 Características Principales

- ✅ CRUD completo de prompts
- ✅ Soporte multiidioma con spatie/laravel-translatable
- ✅ Sistema de autorización con políticas
- ✅ Interfaz moderna con Vue 3 + Inertia
- ✅ Modo oscuro
- ✅ Búsqueda y filtros
- ✅ Sistema de favoritos
- ✅ Estadísticas (vistas y copias)
- ✅ Docker Compose para desarrollo
- ✅ GitHub Actions CI/CD

### 📦 Requisitos

- PHP >= 8.2
- Composer >= 2.x
- Node.js >= 18.x
- npm >= 9.x
- MySQL >= 8.0 (o compatible)
- Redis (opcional, para caché y colas)

### 🚀 Inicio Rápido

#### Opción 1: Usar el Script de Generación

Este método genera un proyecto Laravel completo desde cero:

```bash
# 1. Clonar el repositorio
git clone https://github.com/drewkenobi/prompt-manager.git
cd prompt-manager

# 2. Ejecutar el script de generación
./generate_scaffold.sh

# 3. El script creará una carpeta 'prompts-manager' con todo el proyecto
# y un archivo 'prompts-manager.zip'

# 4. Entrar al directorio del proyecto generado
cd prompts-manager

# 5. Configurar la base de datos en .env
nano .env

# 6. Ejecutar migraciones y seeders (si no lo hizo el script)
php artisan migrate
php artisan db:seed --class=RolesAndAdminSeeder

# 7. Iniciar el servidor de desarrollo
php artisan serve

# En otra terminal, compilar assets en modo desarrollo
npm run dev
```

#### Opción 2: Usar Docker Compose

```bash
# 1. Clonar el repositorio
git clone https://github.com/drewkenobi/prompt-manager.git
cd prompt-manager

# 2. Copiar .env.example a .env y configurar
cp .env.example .env

# 3. Construir e iniciar contenedores
docker-compose up -d --build

# 4. Instalar dependencias dentro del contenedor
docker-compose exec app composer install
docker-compose exec app npm install

# 5. Generar clave de aplicación
docker-compose exec app php artisan key:generate

# 6. Ejecutar migraciones y seeders
docker-compose exec app php artisan migrate
docker-compose exec app php artisan db:seed --class=RolesAndAdminSeeder

# 7. Compilar assets
docker-compose exec app npm run build

# La aplicación estará disponible en http://localhost:8080
```

### 🔧 Instalación Manual (Sin Script)

Si prefieres instalar manualmente sin usar el script de generación:

```bash
# 1. Clonar repositorio
git clone https://github.com/drewkenobi/prompt-manager.git
cd prompt-manager

# 2. Instalar dependencias PHP
composer install

# 3. Instalar dependencias JavaScript
npm install

# 4. Configurar entorno
cp .env.example .env
php artisan key:generate

# 5. Configurar base de datos en .env
# Editar DB_CONNECTION, DB_DATABASE, DB_USERNAME, DB_PASSWORD

# 6. Ejecutar migraciones
php artisan migrate

# 7. Ejecutar seeders
php artisan db:seed --class=RolesAndAdminSeeder

# 8. Compilar assets
npm run build

# 9. Iniciar servidor
php artisan serve
```

### 👤 Credenciales por Defecto

Después de ejecutar los seeders, puedes iniciar sesión con:

- **Email**: admin@prompts-manager.test
- **Password**: password

**⚠️ IMPORTANTE**: Cambia estas credenciales en producción.

### 🧪 Testing

```bash
# Ejecutar tests con PHPUnit
php artisan test

# O con composer
composer test

# Tests con coverage
php artisan test --coverage
```

### 🌐 Variables de Entorno Importantes

```env
APP_NAME="Prompts Manager"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=prompts_manager
DB_USERNAME=root
DB_PASSWORD=

CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```

### 🐳 Comandos Docker Útiles

```bash
# Ver logs
docker-compose logs -f

# Parar contenedores
docker-compose down

# Reconstruir contenedores
docker-compose up -d --build

# Ejecutar comandos artisan
docker-compose exec app php artisan [comando]

# Acceder al shell del contenedor
docker-compose exec app bash

# Limpiar todo (¡cuidado! elimina volúmenes)
docker-compose down -v
```

### 📁 Estructura del Proyecto

```
prompt-manager/
├── app/
│   ├── Http/Controllers/
│   │   └── PromptController.php
│   ├── Models/
│   │   ├── Prompt.php
│   │   └── User.php
│   └── Policies/
│       └── PromptPolicy.php
├── database/
│   ├── migrations/
│   │   └── 2025_11_20_000000_create_prompts_table.php
│   └── seeders/
│       └── RolesAndAdminSeeder.php
├── resources/
│   ├── js/
│   │   ├── Components/
│   │   │   ├── CodeBlock.vue
│   │   │   └── PromptEditor.vue
│   │   ├── Pages/
│   │   │   ├── Prompts/
│   │   │   │   ├── Index.vue
│   │   │   │   └── Show.vue
│   │   │   └── Dashboard/Prompts/
│   │   │       └── Index.vue
│   │   └── app.js
│   └── lang/
│       ├── es.json
│       └── en.json
├── routes/
│   └── web.php
├── docker-compose.yml
├── Dockerfile
├── generate_scaffold.sh
└── README.md
```

### 🤖 Uso con GitHub Copilot

Este proyecto está diseñado para ser extendido con GitHub Copilot:

1. **Autocompletado**: Copilot puede sugerir código basado en los patrones existentes
2. **Tests**: Genera tests automáticamente basándose en las clases y métodos
3. **Componentes**: Crea nuevos componentes Vue siguiendo el estilo del proyecto
4. **Refactoring**: Mejora el código existente con sugerencias inteligentes

#### Ejemplos de prompts para Copilot:

```
// Añadir autenticación de dos factores
// Implementar búsqueda avanzada con Elasticsearch
// Crear API REST para prompts
// Añadir exportación a PDF
```

### 🔒 Seguridad

- ✅ Autenticación con Laravel Breeze
- ✅ Autorización basada en políticas
- ✅ Protección CSRF
- ✅ Validación de datos
- ✅ Sanitización de entradas
- ✅ SQL injection protection (Eloquent ORM)
- ✅ XSS protection

**Nota de seguridad**: Este es un scaffold inicial. Antes de desplegar a producción:
- Cambia todas las credenciales por defecto
- Revisa las políticas de autorización
- Configura HTTPS
- Implementa rate limiting
- Configura backups de base de datos

### 🚧 Roadmap

- [ ] API REST completa
- [ ] Sistema de versiones de prompts
- [ ] Colaboración en tiempo real
- [ ] Exportación/importación de prompts
- [ ] Integración con servicios de LLM (OpenAI, Anthropic, etc.)
- [ ] Sistema de plantillas
- [ ] Análisis de uso y estadísticas avanzadas

### 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

### 👨‍💻 Autor

**drewkenobi** - [GitHub](https://github.com/drewkenobi)

---

## English

### 📋 Description

**Prompts & Snippets Manager** is a full-stack web application that allows users to create, manage, and share reusable prompts and snippets for language models (LLMs). The application is built with:

- **Backend**: Laravel 10+ (PHP 8.2+)
- **Frontend**: Vue 3 + Inertia.js + Tailwind CSS
- **Database**: MySQL 8.0+
- **Features**:
  - Multi-language support (Spanish and English)
  - Authentication and authorization with Laravel Breeze
  - Prompt management with public/private/unlisted visibility
  - Favorites system
  - Categorization and tagging
  - Syntax highlighting with Highlight.js
  - Integrated code editor
  - Docker for local development

### 🎯 Key Features

- ✅ Complete CRUD for prompts
- ✅ Multi-language support with spatie/laravel-translatable
- ✅ Authorization system with policies
- ✅ Modern interface with Vue 3 + Inertia
- ✅ Dark mode
- ✅ Search and filters
- ✅ Favorites system
- ✅ Statistics (views and copies)
- ✅ Docker Compose for development
- ✅ GitHub Actions CI/CD

### 📦 Requirements

- PHP >= 8.2
- Composer >= 2.x
- Node.js >= 18.x
- npm >= 9.x
- MySQL >= 8.0 (or compatible)
- Redis (optional, for cache and queues)

### 🚀 Quick Start

#### Option 1: Use the Generation Script

This method generates a complete Laravel project from scratch:

```bash
# 1. Clone the repository
git clone https://github.com/drewkenobi/prompt-manager.git
cd prompt-manager

# 2. Run the generation script
./generate_scaffold.sh

# 3. The script will create a 'prompts-manager' folder with the entire project
# and a 'prompts-manager.zip' file

# 4. Enter the generated project directory
cd prompts-manager

# 5. Configure the database in .env
nano .env

# 6. Run migrations and seeders (if the script didn't)
php artisan migrate
php artisan db:seed --class=RolesAndAdminSeeder

# 7. Start the development server
php artisan serve

# In another terminal, compile assets in development mode
npm run dev
```

#### Option 2: Use Docker Compose

```bash
# 1. Clone the repository
git clone https://github.com/drewkenobi/prompt-manager.git
cd prompt-manager

# 2. Copy .env.example to .env and configure
cp .env.example .env

# 3. Build and start containers
docker-compose up -d --build

# 4. Install dependencies inside the container
docker-compose exec app composer install
docker-compose exec app npm install

# 5. Generate application key
docker-compose exec app php artisan key:generate

# 6. Run migrations and seeders
docker-compose exec app php artisan migrate
docker-compose exec app php artisan db:seed --class=RolesAndAdminSeeder

# 7. Compile assets
docker-compose exec app npm run build

# The application will be available at http://localhost:8080
```

### 🔧 Manual Installation (Without Script)

If you prefer to install manually without using the generation script:

```bash
# 1. Clone repository
git clone https://github.com/drewkenobi/prompt-manager.git
cd prompt-manager

# 2. Install PHP dependencies
composer install

# 3. Install JavaScript dependencies
npm install

# 4. Configure environment
cp .env.example .env
php artisan key:generate

# 5. Configure database in .env
# Edit DB_CONNECTION, DB_DATABASE, DB_USERNAME, DB_PASSWORD

# 6. Run migrations
php artisan migrate

# 7. Run seeders
php artisan db:seed --class=RolesAndAdminSeeder

# 8. Compile assets
npm run build

# 9. Start server
php artisan serve
```

### 👤 Default Credentials

After running the seeders, you can log in with:

- **Email**: admin@prompts-manager.test
- **Password**: password

**⚠️ IMPORTANT**: Change these credentials in production.

### 🧪 Testing

```bash
# Run tests with PHPUnit
php artisan test

# Or with composer
composer test

# Tests with coverage
php artisan test --coverage
```

### 🌐 Important Environment Variables

```env
APP_NAME="Prompts Manager"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=prompts_manager
DB_USERNAME=root
DB_PASSWORD=

CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```

### 🐳 Useful Docker Commands

```bash
# View logs
docker-compose logs -f

# Stop containers
docker-compose down

# Rebuild containers
docker-compose up -d --build

# Run artisan commands
docker-compose exec app php artisan [command]

# Access container shell
docker-compose exec app bash

# Clean everything (warning! removes volumes)
docker-compose down -v
```

### 📁 Project Structure

```
prompt-manager/
├── app/
│   ├── Http/Controllers/
│   │   └── PromptController.php
│   ├── Models/
│   │   ├── Prompt.php
│   │   └── User.php
│   └── Policies/
│       └── PromptPolicy.php
├── database/
│   ├── migrations/
│   │   └── 2025_11_20_000000_create_prompts_table.php
│   └── seeders/
│       └── RolesAndAdminSeeder.php
├── resources/
│   ├── js/
│   │   ├── Components/
│   │   │   ├── CodeBlock.vue
│   │   │   └── PromptEditor.vue
│   │   ├── Pages/
│   │   │   ├── Prompts/
│   │   │   │   ├── Index.vue
│   │   │   │   └── Show.vue
│   │   │   └── Dashboard/Prompts/
│   │   │       └── Index.vue
│   │   └── app.js
│   └── lang/
│       ├── es.json
│       └── en.json
├── routes/
│   └── web.php
├── docker-compose.yml
├── Dockerfile
├── generate_scaffold.sh
└── README.md
```

### 🤖 Usage with GitHub Copilot

This project is designed to be extended with GitHub Copilot:

1. **Autocomplete**: Copilot can suggest code based on existing patterns
2. **Tests**: Automatically generate tests based on classes and methods
3. **Components**: Create new Vue components following the project style
4. **Refactoring**: Improve existing code with intelligent suggestions

#### Example prompts for Copilot:

```
// Add two-factor authentication
// Implement advanced search with Elasticsearch
// Create REST API for prompts
// Add PDF export
```

### 🔒 Security

- ✅ Authentication with Laravel Breeze
- ✅ Policy-based authorization
- ✅ CSRF protection
- ✅ Data validation
- ✅ Input sanitization
- ✅ SQL injection protection (Eloquent ORM)
- ✅ XSS protection

**Security note**: This is an initial scaffold. Before deploying to production:
- Change all default credentials
- Review authorization policies
- Configure HTTPS
- Implement rate limiting
- Configure database backups

### 🚧 Roadmap

- [ ] Complete REST API
- [ ] Prompt versioning system
- [ ] Real-time collaboration
- [ ] Prompt export/import
- [ ] Integration with LLM services (OpenAI, Anthropic, etc.)
- [ ] Template system
- [ ] Usage analysis and advanced statistics

### 🤝 Contributing

Contributions are welcome. Please:

1. Fork the project
2. Create a branch for your feature (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

### 👨‍💻 Author

**drewkenobi** - [GitHub](https://github.com/drewkenobi)
