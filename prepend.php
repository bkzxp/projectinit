<?php

error_reporting(7);
ini_set("display_errors", 1);
ini_set("display_startup_errors", 1);

if (array_key_exists('_opcache', $_REQUEST)) {
    require __DIR__ . '/opcache.php';
    exit;
}

if (array_key_exists('_env', $_REQUEST)) {
    echo "<pre>";
    print_r($_SERVER);
    print_r($_SESSION);
    print_r($_COOKIE);
    echo "</pre>";
    phpinfo();
    exit;
}

if (is_file('/tb/domain.php')) {
    require '/tb/domain.php';
}

if (array_key_exists('_domain', $_REQUEST)) {
?>
<ul>
    <li><a target="_blank" href="//<?php echo DOMAIN_CY; ?>"><?php echo DOMAIN_CY; ?></a></li>
    <li><a target="_blank" href="//<?php echo DOMAIN_HT; ?>"><?php echo DOMAIN_HT; ?></a></li>
</ul>
<?php
    exit;
}
