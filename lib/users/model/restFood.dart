class RestFood {
  int? id_restrauran;
  String? name_res;
  double? rating_rest;
  String? alamat;
  String? no_hp;
  String? images_res;
  int? latitude;
  int? longitude;
  int? kapasitas;
  String? filter;
  int? jarak;
  int? id_kategori;
  int? item_id;
  String? name;
  double? rating;
  List<String>? tags;
  double? price;
  List<String>? sizes;
  List<String>? colors;
  String? description;
  String? image;

  RestFood(
      {this.item_id,
      this.name,
      this.rating,
      this.tags,
      this.price,
      this.sizes,
      this.colors,
      this.description,
      this.image,
      this.id_restrauran,
      this.name_res,
      this.rating_rest,
      this.alamat,
      this.no_hp,
      this.images_res,
      this.latitude,
      this.longitude,
      this.kapasitas,
      this.filter,
      this.id_kategori,
      this.jarak});

  factory RestFood.fromJson(Map<String, dynamic> json) => RestFood(
        item_id: int.parse(json["item_id"]),
        name: json["name"],
        rating: double.parse(json["rating"]),
        tags: json["tags"].toString().split(", "),
        price: double.parse(json["price"]),
        sizes: json["sizes"].toString().split(", "),
        colors: json["colors"].toString().split(", "),
        description: json['description'],
        image: json['image'],
        id_restrauran: int.parse(json['id_restrauran']),
        name_res: json['name_res'],
        rating_rest: double.parse(json['rating_rest']),
        alamat: json['alamat'],
        no_hp: json['no_hp'],
        images_res: json['images_res'],
        latitude: int.parse(json['latitude']),
        longitude: int.parse(json['longitude']),
        kapasitas: int.parse(json['kapasitas']),
        filter: json['filter'],
        id_kategori: int.parse(json['id_kategori']),
        jarak: int.parse(json['jarak']),
      );
}
