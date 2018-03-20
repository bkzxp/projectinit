<?php

if (PHP_SAPI != 'cli') {
    exit;
}

$constants = get_defined_constants(true);

array_walk($constants['user'], function($value, $key) {
    if (strpos($key, 'DOMAIN_') === 0) {
        printf("sed -i \"s/%s/%s/g\" \$conf_file\n", $key, $value);
    }
});
