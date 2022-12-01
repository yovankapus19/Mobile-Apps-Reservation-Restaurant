<?php
include '../connection.php';


$kategori = $_POST['nama_kategori'];

$sqlQuery = "SELECT * FROM restaurant INNER JOIN kategori ON kategori.id_kategori = restaurant.id_kategori AND kategori.nama_kategori = '$kategori'";


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
