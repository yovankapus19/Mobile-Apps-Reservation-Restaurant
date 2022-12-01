<?php
include '../connection.php';

// $currentOnLineUserID = $_POST["cart_id"];



// $sqlQuery = "SELECT * FROM cart_table CROSS JOIN summary WHERE cart_table.cart_id = summary.cart_id ORDER BY summary.id_summary DESC LIMIT 1";

$sqlQuery = "SELECT saldo, cart_table_temp.cart_id, total FROM cart_table_temp INNER JOIN users_table ON cart_table_temp.user_id = users_table.user_id INNER JOIN summary ON cart_table_temp.cart_id = summary.cart_id INNER JOIN rekening ON users_table.user_id = rekening.user_id ORDER BY summary.id_summary DESC LIMIT 1";



$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) {
    $clothItemsRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $clothItemsRecord[] = $rowFound;
    }

    echo json_encode(
        array(
            "success" => true,
            "clothItemsData" => $clothItemsRecord,
        )
    );
} else {
    echo json_encode(array("success" => false));
}
