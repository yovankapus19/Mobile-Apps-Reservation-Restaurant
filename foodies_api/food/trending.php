<?php
include '../connection.php';

$currentOnLineUserID = $_POST["id_restrauran"];

$minRating = 4.4;
$limitClothItems = 4;

$sqlQuery = "SELECT * FROM items_table CROSS JOIN restaurant WHERE items_table.id_restrauran = '$currentOnLineUserID' AND items_table.id_restrauran = restaurant.id_restrauran AND rating>= '$minRating' ";

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
