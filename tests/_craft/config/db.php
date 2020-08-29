<?php

use craft\helpers\App;

return [
    'dsn' => App::env('DB_DSN'),
    'user' => App::env('DB_USER'),
    'password' => App::env('DB_PASSWORD'),
    'tablePrefix' => App::env('DB_TABLE_PREFIX'),
];
