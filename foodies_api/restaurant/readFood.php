<?php
include '../connection.php';

$currentOnLineUserID = $_POST["id_restrauran"];


$sqlQuery = "SELECT * FROM items_table JOIN restaurant WHERE
items_table.id_restrauran = '$currentOnLineUserID' AND items_table.id_restrauran = restaurant.id_restrauran
order by case when items_table.kategori = 'makanan' then 1
              when items_table.kategori = 'minuman' then 2
              when items_table.kategori = 'dessert' then 3
              when items_table.kategori = 'snack' then 4
              else 5
         end asc";

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
