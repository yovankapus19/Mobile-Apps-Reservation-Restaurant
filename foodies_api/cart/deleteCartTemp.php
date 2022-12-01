<?php
include '../connection.php';



$sqlQuery = "DELETE FROM cart_table_temp";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
