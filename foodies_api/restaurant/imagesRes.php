<?php
include '../connection.php';

$currentOnLineUserID = $_POST["id_restrauran"];

$sqlQuery = "SELECT * FROM restaurant WHERE restaurant.id_restrauran = '$currentOnLineUserID'";

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
