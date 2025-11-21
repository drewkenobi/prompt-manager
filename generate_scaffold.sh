#!/bin/bash

################################################################################
# Script de generación del scaffold completo de Prompts & Snippets Manager
# 
# Este script crea un proyecto Laravel completo con Breeze (Inertia + Vue),
# instala todas las dependencias, crea migraciones, modelos, controladores,
# políticas, seeders, recursos Vue y compila los assets.
#
# Autor: drewkenobi
# Fecha: 2025
################################################################################

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Prompts & Snippets Manager - Scaffold${NC}"
echo -e "${GREEN}========================================${NC}"

# Verificar que composer y npm estén instalados
if ! command -v composer &> /dev/null; then
    echo -e "${RED}Error: Composer no está instalado${NC}"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo -e "${RED}Error: npm no está instalado${NC}"
    exit 1
fi

# Nombre del proyecto
PROJECT_NAME="prompts-manager"

# Eliminar directorio si existe
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${YELLOW}Eliminando directorio existente $PROJECT_NAME...${NC}"
    rm -rf "$PROJECT_NAME"
fi

echo -e "${GREEN}[1/12] Creando nuevo proyecto Laravel...${NC}"
composer create-project laravel/laravel "$PROJECT_NAME"

cd "$PROJECT_NAME"

echo -e "${GREEN}[2/12] Instalando Laravel Breeze con Inertia + Vue...${NC}"
composer require laravel/breeze --dev
php artisan breeze:install vue --ssr

echo -e "${GREEN}[3/12] Instalando dependencias adicionales de Composer...${NC}"
composer require spatie/laravel-translatable
composer require spatie/laravel-permission

echo -e "${GREEN}[4/12] Instalando dependencias de npm...${NC}"
npm install
npm install highlight.js @vueuse/core

echo -e "${GREEN}[5/12] Creando estructura de directorios...${NC}"
mkdir -p database/migrations
mkdir -p app/Policies
mkdir -p database/seeders
mkdir -p resources/js/Pages/Prompts
mkdir -p resources/js/Pages/Dashboard/Prompts
mkdir -p resources/js/Components
mkdir -p resources/lang

echo -e "${GREEN}[6/12] Creando migración de prompts...${NC}"
cat > database/migrations/2025_11_20_000000_create_prompts_table.php << 'EOF'
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Ejecutar las migraciones.
     * Crea la tabla de prompts con soporte multiidioma.
     */
    public function up(): void
    {
        Schema::create('prompts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('slug')->unique();
            $table->json('title'); // Multiidioma: {es: "...", en: "..."}
            $table->json('description'); // Multiidioma
            $table->text('content');
            $table->string('category')->nullable();
            $table->json('tags')->nullable();
            $table->enum('visibility', ['public', 'private', 'unlisted'])->default('private');
            $table->boolean('is_featured')->default(false);
            $table->integer('views_count')->default(0);
            $table->integer('copies_count')->default(0);
            $table->timestamps();
            $table->softDeletes();

            $table->index(['visibility', 'is_featured']);
            $table->index('category');
            $table->index('created_at');
        });

        // Tabla de favoritos
        Schema::create('prompt_favorites', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('prompt_id')->constrained()->onDelete('cascade');
            $table->timestamps();

            $table->unique(['user_id', 'prompt_id']);
        });
    }

    /**
     * Revertir las migraciones.
     */
    public function down(): void
    {
        Schema::dropIfExists('prompt_favorites');
        Schema::dropIfExists('prompts');
    }
};
EOF

echo -e "${GREEN}[7/12] Creando modelo Prompt...${NC}"
cat > app/Models/Prompt.php << 'EOF'
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Translatable\HasTranslations;

/**
 * Modelo Prompt
 * 
 * Representa un prompt o snippet reutilizable para LLMs.
 * Soporta multiidioma en title y description.
 */
class Prompt extends Model
{
    use HasFactory, SoftDeletes, HasTranslations;

    protected $fillable = [
        'user_id',
        'slug',
        'title',
        'description',
        'content',
        'category',
        'tags',
        'visibility',
        'is_featured',
        'views_count',
        'copies_count',
    ];

    protected $casts = [
        'tags' => 'array',
        'is_featured' => 'boolean',
        'views_count' => 'integer',
        'copies_count' => 'integer',
    ];

    // Campos traducibles
    public $translatable = ['title', 'description'];

    /**
     * Relación con el usuario creador
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Usuarios que marcaron este prompt como favorito
     */
    public function favoritedBy(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'prompt_favorites')
            ->withTimestamps();
    }

    /**
     * Scope para prompts públicos
     */
    public function scopePublic($query)
    {
        return $query->where('visibility', 'public');
    }

    /**
     * Scope para prompts destacados
     */
    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    /**
     * Incrementar contador de vistas
     */
    public function incrementViews(): void
    {
        $this->increment('views_count');
    }

    /**
     * Incrementar contador de copias
     */
    public function incrementCopies(): void
    {
        $this->increment('copies_count');
    }
}
EOF

echo -e "${GREEN}[8/12] Creando modelo User con relaciones...${NC}"
# Crear modelo User completo en lugar de modificarlo con sed
cat > app/Models/User.php << 'EOF'
<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    /**
     * Prompts creados por el usuario
     */
    public function prompts(): HasMany
    {
        return $this->hasMany(Prompt::class);
    }

    /**
     * Prompts marcados como favoritos por el usuario
     */
    public function favorites(): BelongsToMany
    {
        return $this->belongsToMany(Prompt::class, 'prompt_favorites')
            ->withTimestamps();
    }
}
EOF

echo -e "${GREEN}[9/12] Creando PromptPolicy...${NC}"
cat > app/Policies/PromptPolicy.php << 'EOF'
<?php

namespace App\Policies;

use App\Models\Prompt;
use App\Models\User;

/**
 * Policy de autorización para Prompts
 * 
 * Define quién puede ver, crear, editar y eliminar prompts.
 */
class PromptPolicy
{
    /**
     * Determinar si el usuario puede ver cualquier prompt
     */
    public function viewAny(?User $user): bool
    {
        return true; // Todos pueden ver prompts públicos
    }

    /**
     * Determinar si el usuario puede ver este prompt
     */
    public function view(?User $user, Prompt $prompt): bool
    {
        // Público: todos pueden ver
        if ($prompt->visibility === 'public' || $prompt->visibility === 'unlisted') {
            return true;
        }

        // Privado: solo el dueño
        return $user && $user->id === $prompt->user_id;
    }

    /**
     * Determinar si el usuario puede crear prompts
     */
    public function create(User $user): bool
    {
        return true; // Usuarios autenticados pueden crear
    }

    /**
     * Determinar si el usuario puede editar este prompt
     */
    public function update(User $user, Prompt $prompt): bool
    {
        return $user->id === $prompt->user_id;
    }

    /**
     * Determinar si el usuario puede eliminar este prompt
     */
    public function delete(User $user, Prompt $prompt): bool
    {
        return $user->id === $prompt->user_id;
    }

    /**
     * Determinar si el usuario puede restaurar este prompt
     */
    public function restore(User $user, Prompt $prompt): bool
    {
        return $user->id === $prompt->user_id;
    }
}
EOF

echo -e "${GREEN}[10/12] Creando PromptController...${NC}"
cat > app/Http/Controllers/PromptController.php << 'EOF'
<?php

namespace App\Http\Controllers;

use App\Models\Prompt;
use Illuminate\Http\Request;
use Inertia\Inertia;

/**
 * Controlador de Prompts
 * 
 * Gestiona las operaciones CRUD y vistas de prompts.
 */
class PromptController extends Controller
{
    /**
     * Mostrar listado de prompts públicos
     */
    public function index(Request $request)
    {
        $query = Prompt::with('user')
            ->public()
            ->latest();

        // Filtrar por categoría si se proporciona
        if ($request->has('category')) {
            $query->where('category', $request->category);
        }

        // Búsqueda por texto
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->whereRaw("JSON_EXTRACT(title, '$.es') LIKE ?", ["%$search%"])
                  ->orWhereRaw("JSON_EXTRACT(title, '$.en') LIKE ?", ["%$search%"])
                  ->orWhere('content', 'like', "%$search%");
            });
        }

        $prompts = $query->paginate(12);

        return Inertia::render('Prompts/Index', [
            'prompts' => $prompts,
            'filters' => $request->only(['category', 'search']),
        ]);
    }

    /**
     * Mostrar un prompt específico
     */
    public function show(Prompt $prompt)
    {
        $this->authorize('view', $prompt);

        $prompt->load('user');
        $prompt->incrementViews();

        return Inertia::render('Prompts/Show', [
            'prompt' => $prompt,
        ]);
    }

    /**
     * Dashboard: listado de prompts del usuario
     */
    public function dashboard(Request $request)
    {
        $prompts = $request->user()
            ->prompts()
            ->latest()
            ->paginate(10);

        return Inertia::render('Dashboard/Prompts/Index', [
            'prompts' => $prompts,
        ]);
    }

    /**
     * Crear nuevo prompt
     */
    public function store(Request $request)
    {
        $this->authorize('create', Prompt::class);

        $validated = $request->validate([
            'title' => 'required|array',
            'title.es' => 'required|string|max:255',
            'title.en' => 'required|string|max:255',
            'description' => 'required|array',
            'description.es' => 'required|string',
            'description.en' => 'required|string',
            'content' => 'required|string',
            'category' => 'nullable|string|max:100',
            'tags' => 'nullable|array',
            'visibility' => 'required|in:public,private,unlisted',
        ]);

        $validated['slug'] = \Str::slug($validated['title']['en']) . '-' . \Str::random(6);
        $validated['user_id'] = $request->user()->id;

        $prompt = Prompt::create($validated);

        return redirect()->route('prompts.show', $prompt)
            ->with('success', 'Prompt creado exitosamente');
    }

    /**
     * Actualizar prompt existente
     */
    public function update(Request $request, Prompt $prompt)
    {
        $this->authorize('update', $prompt);

        $validated = $request->validate([
            'title' => 'required|array',
            'title.es' => 'required|string|max:255',
            'title.en' => 'required|string|max:255',
            'description' => 'required|array',
            'description.es' => 'required|string',
            'description.en' => 'required|string',
            'content' => 'required|string',
            'category' => 'nullable|string|max:100',
            'tags' => 'nullable|array',
            'visibility' => 'required|in:public,private,unlisted',
        ]);

        $prompt->update($validated);

        return redirect()->route('prompts.show', $prompt)
            ->with('success', 'Prompt actualizado exitosamente');
    }

    /**
     * Eliminar prompt
     */
    public function destroy(Prompt $prompt)
    {
        $this->authorize('delete', $prompt);

        $prompt->delete();

        return redirect()->route('dashboard.prompts')
            ->with('success', 'Prompt eliminado exitosamente');
    }

    /**
     * Copiar prompt (incrementar contador)
     */
    public function copy(Prompt $prompt)
    {
        $this->authorize('view', $prompt);

        $prompt->incrementCopies();

        return response()->json(['success' => true]);
    }

    /**
     * Marcar/desmarcar como favorito
     */
    public function toggleFavorite(Request $request, Prompt $prompt)
    {
        $user = $request->user();

        if ($user->favorites()->where('prompt_id', $prompt->id)->exists()) {
            $user->favorites()->detach($prompt->id);
            $favorited = false;
        } else {
            $user->favorites()->attach($prompt->id);
            $favorited = true;
        }

        return response()->json(['favorited' => $favorited]);
    }
}
EOF

echo -e "${GREEN}[11/12] Creando Seeder de roles y admin...${NC}"
cat > database/seeders/RolesAndAdminSeeder.php << 'EOF'
<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

/**
 * Seeder de roles y usuario administrador
 * 
 * Crea el usuario admin por defecto.
 */
class RolesAndAdminSeeder extends Seeder
{
    /**
     * Ejecutar el seeder
     */
    public function run(): void
    {
        // Crear usuario admin
        User::create([
            'name' => 'Admin',
            'email' => 'admin@prompts-manager.test',
            'password' => Hash::make('password'),
            'email_verified_at' => now(),
        ]);

        // Crear usuario de ejemplo
        User::create([
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => Hash::make('password'),
            'email_verified_at' => now(),
        ]);

        $this->command->info('Usuarios creados exitosamente');
    }
}
EOF

echo -e "${GREEN}[12/12] Configurando rutas...${NC}"
# Agregar rutas al archivo web.php
cat >> routes/web.php << 'EOF'

// Rutas públicas de prompts
Route::get('/prompts', [App\Http\Controllers\PromptController::class, 'index'])->name('prompts.index');
Route::get('/prompts/{prompt}', [App\Http\Controllers\PromptController::class, 'show'])->name('prompts.show');
Route::post('/prompts/{prompt}/copy', [App\Http\Controllers\PromptController::class, 'copy'])->name('prompts.copy');

// Rutas protegidas (requieren autenticación)
Route::middleware(['auth', 'verified'])->group(function () {
    // Dashboard de prompts del usuario
    Route::get('/dashboard/prompts', [App\Http\Controllers\PromptController::class, 'dashboard'])->name('dashboard.prompts');
    
    // CRUD de prompts
    Route::post('/prompts', [App\Http\Controllers\PromptController::class, 'store'])->name('prompts.store');
    Route::put('/prompts/{prompt}', [App\Http\Controllers\PromptController::class, 'update'])->name('prompts.update');
    Route::delete('/prompts/{prompt}', [App\Http\Controllers\PromptController::class, 'destroy'])->name('prompts.destroy');
    
    // Favoritos
    Route::post('/prompts/{prompt}/favorite', [App\Http\Controllers\PromptController::class, 'toggleFavorite'])->name('prompts.favorite');
});
EOF

echo -e "${GREEN}Configurando base de datos y ejecutando migraciones...${NC}"
# Crear archivo .env si no existe
if [ ! -f .env ]; then
    cp .env.example .env
    php artisan key:generate
fi

# Ejecutar migraciones
php artisan migrate --force || echo -e "${YELLOW}Advertencia: Las migraciones fallaron. Configura tu base de datos en .env${NC}"

# Ejecutar seeders
php artisan db:seed --class=RolesAndAdminSeeder --force || echo -e "${YELLOW}Advertencia: Los seeders fallaron${NC}"

echo -e "${GREEN}Compilando assets...${NC}"
npm run build || echo -e "${YELLOW}Advertencia: La compilación de assets falló${NC}"

echo -e "${GREEN}Creando archivo ZIP del proyecto...${NC}"
cd ..
zip -r "${PROJECT_NAME}.zip" "$PROJECT_NAME" -x "*/node_modules/*" "*/vendor/*" "*/.git/*"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}¡Scaffold completado exitosamente!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Directorio del proyecto: ${YELLOW}$PROJECT_NAME${NC}"
echo -e "Archivo ZIP: ${YELLOW}${PROJECT_NAME}.zip${NC}"
echo ""
echo -e "Próximos pasos:"
echo -e "1. cd $PROJECT_NAME"
echo -e "2. Configura tu base de datos en .env"
echo -e "3. php artisan migrate"
echo -e "4. php artisan db:seed --class=RolesAndAdminSeeder"
echo -e "5. npm run dev (para desarrollo) o npm run build (para producción)"
echo -e "6. php artisan serve"
echo ""
echo -e "Credenciales de admin:"
echo -e "  Email: ${YELLOW}admin@prompts-manager.test${NC}"
echo -e "  Password: ${YELLOW}password${NC}"
