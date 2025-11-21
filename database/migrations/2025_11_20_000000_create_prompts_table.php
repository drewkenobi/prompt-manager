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
