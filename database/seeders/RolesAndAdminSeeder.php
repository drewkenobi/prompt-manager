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
