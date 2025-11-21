<?php

namespace App\Http\Controllers;

use App\Models\Prompt;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
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
     * Mostrar formulario de creación
     */
    public function create()
    {
        $this->authorize('create', Prompt::class);

        return Inertia::render('Dashboard/Prompts/Create');
    }

    /**
     * Mostrar formulario de edición
     */
    public function edit(Prompt $prompt)
    {
        $this->authorize('update', $prompt);

        return Inertia::render('Dashboard/Prompts/Edit', [
            'prompt' => $prompt,
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

        $validated['slug'] = Str::slug($validated['title']['en'] ?: $validated['title']['es']) . '-' . Str::random(6);
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
