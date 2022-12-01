<?php
include '../connection.php';


$typedKeyWords = $_POST['typedKeyWords'];


$sqlQuery = "SELECT * FROM restaurant WHERE restaurant.name_res LIKE '%$typedKeyWords%' ";




// $sqlQuery = "SELECT * FROM restaurant WHERE name_res LIKE '%$typedKeyWords%'";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) //allow user to login 
{
    $foundItemsRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $foundItemsRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "itemsFoundData" => $foundItemsRecord,



        )
    );
} else {
    echo json_encode(array("success" => false));
}
