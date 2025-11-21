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
