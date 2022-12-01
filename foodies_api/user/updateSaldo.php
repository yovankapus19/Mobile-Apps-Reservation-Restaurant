<?php
include '../connection.php';

$saldo = $_POST['saldo'];
$user_id = $_POST['user_id'];



$sqlQuery = "UPDATE rekening SET saldo='$saldo' WHERE user_id = '$user_id'";

$resultOfQuery = $connectNow->query($sqlQuery);


if ($resultOfQuery) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
