<?php
include '../connection.php';
$userEmail = $_POST['user_email'];
// Checking if email is exist in db

$sqlQuery = "SELECT * FROM users_table WHERE user_email='$userEmail'";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) {
    # code...
    // num rows length == 1 --  email already in someone else use ---error
    echo json_encode(array("emailFound" => true));
} else {
    // num rows length == 0
    echo json_encode(array("emailFound" => false));
}
