<?php

use Illuminate\Support\Facades\Route;
use OpenApi\Generator;

Route::view('/', 'home');

Route::get('/docs', fn() => Generator::scan([app_path()])->toYaml());
