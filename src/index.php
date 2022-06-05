<?php

$memcached = new Memcached();
$memcached->addServer("memcached", 11211);
$r = $memcached->get("test");

if ($r) {
    echo $r;
} else {
    echo "No result. Refresh..";
    $r->set("test", "Test! Test! Test!") or die("Couldn't save anything to memcached...");
}

phpinfo();