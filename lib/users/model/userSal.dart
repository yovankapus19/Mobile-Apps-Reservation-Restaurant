import 'package:flutter/foundation.dart';

class Tabungan {
  String? nama_tabungan;
  int? nomor_rekening;
  double? saldo;

  Tabungan({
    this.nama_tabungan,
    this.nomor_rekening,
    this.saldo,
  });

  factory Tabungan.fromJson(Map<String, dynamic> json) => Tabungan(
      nomor_rekening: int.parse(json['nomor_rekening']),
      nama_tabungan: json['nama_tabungan'],
      saldo: double.parse(json['saldo']));
}
