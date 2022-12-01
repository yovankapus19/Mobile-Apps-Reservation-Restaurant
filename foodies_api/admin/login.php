<?php
include '../connection.php';


$adminEmail = $_POST['admin_email'];
$adminPassword = $_POST['admin_password'];

$sqlQuery = "SELECT * FROM admins_table WHERE admin_email = '$adminEmail' AND admin_password = '$adminPassword'";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) //allow admin to login 
{
    $adminRecord = array();
    while ($rowFound = $resultOfQuery->fetch_assoc()) {
        $adminRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success" => true,
            "userData" => $adminRecord[0],



        )
    );
} else {
    echo json_encode(array("success" => false));
}
