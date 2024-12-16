<?php

// namespace Database\Seeders;

use App\Models\Coupon;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class CouponSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $data = [
            [
                'code' => 'abc123',
                'type' => 'fixed',
                'value' => '300',
                'status' => 'active'
            ],
            [
                'code' => '111111',
                'type' => 'percent',
                'value' => '10',
                'status' => 'active'
            ],
        ];

        foreach ($data as $value) {
            if (!Coupon::where('code', $value['code'])->first()) {
                Coupon::create($value);
            }
        }
    }
}
