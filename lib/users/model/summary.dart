class Summary {
  int? cart_id;
  double? total;
  double? saldo;

  Summary({
    this.cart_id,
    this.total,
    this.saldo,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        cart_id: int.parse(json['cart_id']),
        total: double.parse(
          json['total'],
        ),
        saldo: double.parse(json['saldo']),
      );
}
