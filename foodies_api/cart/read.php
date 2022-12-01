<?php
include '../connection.php';

$currentOnLineUserID = $_POST["currentOnLineUserId"];

$sqlQuery = "SELECT * FROM cart_table_temp CROSS JOIN items_table WHERE cart_table_temp.user_id = '$currentOnLineUserID' AND cart_table_temp.item_id = items_table.item_id";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) //allow user to login 
{
    $cartRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $cartRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "currentUserCartData" => $cartRecord,



        )
    );
} else {
    echo json_encode(array("success" => false));
}
