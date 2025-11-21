<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::get('/dashboard', function () {
    return Inertia::render('Dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';

// Rutas públicas de prompts
Route::get('/prompts', [App\Http\Controllers\PromptController::class, 'index'])->name('prompts.index');
Route::get('/prompts/{prompt}', [App\Http\Controllers\PromptController::class, 'show'])->name('prompts.show');
Route::post('/prompts/{prompt}/copy', [App\Http\Controllers\PromptController::class, 'copy'])->name('prompts.copy');

// Rutas protegidas (requieren autenticación)
Route::middleware(['auth', 'verified'])->group(function () {
    // Dashboard de prompts del usuario
    Route::get('/dashboard/prompts', [App\Http\Controllers\PromptController::class, 'dashboard'])->name('dashboard.prompts');
    
    // Formularios (antes de las rutas con parámetros para evitar conflictos)
    Route::get('/dashboard/prompts/create', [App\Http\Controllers\PromptController::class, 'create'])->name('prompts.create');
    Route::get('/dashboard/prompts/{prompt}/edit', [App\Http\Controllers\PromptController::class, 'edit'])->name('prompts.edit');
    
    // CRUD de prompts
    Route::post('/prompts', [App\Http\Controllers\PromptController::class, 'store'])->name('prompts.store');
    Route::put('/prompts/{prompt}', [App\Http\Controllers\PromptController::class, 'update'])->name('prompts.update');
    Route::delete('/prompts/{prompt}', [App\Http\Controllers\PromptController::class, 'destroy'])->name('prompts.destroy');
    
    // Favoritos
    Route::post('/prompts/{prompt}/favorite', [App\Http\Controllers\PromptController::class, 'toggleFavorite'])->name('prompts.favorite');
});
