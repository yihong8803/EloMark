<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    public function saveImage($image, $path = 'public')
    {
        if (!$image) {
            return null;
        }

        $filename = time() . '.png';

        // Store the image in the storage/app/public folder
        Storage::disk('public')->put($filename, base64_decode($image));

        // Return full URL to the stored image (ensure you run `php artisan storage:link`)
        return URL::to('/') . '/storage/' . $filename;
    }
}
