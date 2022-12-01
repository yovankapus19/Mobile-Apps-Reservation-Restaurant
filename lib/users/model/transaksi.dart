class Transaksi {
  int? id_transaksi;
  int? id_summary;
  double? trans_total;
  String? trans_date;
  int? jumlah_orang;
  int? kode_unik;
  int? quantity;
  String? name_res;
  String? name;

  Transaksi({
    this.id_summary,
    this.id_transaksi,
    this.jumlah_orang,
    this.kode_unik,
    this.name_res,
    this.name,
    this.quantity,
    this.trans_date,
    this.trans_total,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
        id_transaksi: int.parse(json["id_transaksi"]),
        id_summary: int.parse(json["id_summary"]),
        jumlah_orang: int.parse(json["jumlah_orang"]),
        kode_unik: int.parse(json["kode_unik"]),
        quantity: int.parse(json["quantity"]),
        name: json["name"],
        name_res: json["name_res"],
        trans_total: double.parse(json["trans_total"]),
        trans_date: json['trans_date'],
      );
}
