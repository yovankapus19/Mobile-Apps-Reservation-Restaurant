<?php
include '../connection.php';

$cart_id = $_POST['cart_id'];
$total = $_POST['total'];


$sqlQuery = "INSERT INTO summary SET cart_id = '$cart_id', total = '$total'";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
