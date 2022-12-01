<?php
include '../connection.php';

$id_summary = $_POST['id_summary'];
$trans_total = $_POST['trans_total'];
$trans_date = $_POST['trans_date'];
$trans_time = $_POST['trans_time'];
$jumlah_orang = $_POST['jumlah_orang'];
$id_rekening = $_POST['id_rekening'];
$kode_unik = $_POST['kode_unik'];
$user_id = $_POST['user_id'];


$sqlQuery = "INSERT INTO transaksi SET id_summary = '$id_summary', trans_total = '$trans_total', trans_date = '$trans_date',trans_time = '$trans_time', jumlah_orang = '$jumlah_orang', id_rekening = '$id_rekening', kode_unik = '$kode_unik', user_id = '$user_id'";

$resultOfQuery = $connectNow->query($sqlQuery);

if ($resultOfQuery) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
