<?php

// namespace Database\Seeders;

use App\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $data = [
            [
                'name' => 'Admin',
                'email' => 'punur@admin.id',
                'password' => Hash::make('1234'),
                'role' => 'admin',
                'status' => 'active'
            ],
            [
                'name' => 'User',
                'email' => 'user@user.id',
                'password' => Hash::make('1234'),
                'role' => 'user',
                'status' => 'active'
            ],
        ];

        foreach ($data as $value) {
            if (!User::where('email', $value['email'])->first()) {
                User::create($value);
            }
        }
    }
}
