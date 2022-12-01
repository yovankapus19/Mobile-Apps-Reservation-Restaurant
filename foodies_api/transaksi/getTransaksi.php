<?php
include '../connection.php';

$currentOnLineUserID = $_POST["user_id"];

$sqlQuery = "SELECT transaksi.id_transaksi, transaksi.id_summary, cart_table.cart_id, transaksi.trans_total, transaksi.trans_date, transaksi.jumlah_orang, transaksi.kode_unik, cart_table.quantity,restaurant.name_res,items_table.name FROM cart_table CROSS JOIN items_table ON cart_table.item_id = items_table.item_id CROSS JOIN restaurant ON restaurant.id_restrauran = items_table.id_restrauran CROSS JOIN transaksi ON transaksi.user_id = cart_table.user_id WHERE transaksi.user_id= '$currentOnLineUserID' ORDER BY id_transaksi desc, cart_id desc limit 1;";

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
