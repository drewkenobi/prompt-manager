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
