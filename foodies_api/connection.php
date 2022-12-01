<?php
$serverHost = "localhost";
$user = "root";
$password = "";
$database = "backupfoodies";

$connectNow = new mysqli($serverHost, $user, $password, $database);

if ($connectNow) {
    # code...
    // echo "Connected";
}
