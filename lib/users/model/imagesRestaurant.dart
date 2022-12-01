import 'package:flutter/foundation.dart';

class ImagesRes {
  String? images_res;
  String? filter;
  String? alamat;
  double? rating_rest;
  String? name_res;

  ImagesRes({
    this.images_res,
    this.filter,
    this.alamat,
    this.rating_rest,
    this.name_res,
  });
  factory ImagesRes.fromJson(Map<String, dynamic> json) => ImagesRes(
      images_res: json['images_res'],
      filter: json['filter'],
      alamat: json['alamat'],
      rating_rest: double.parse(json['rating_rest']),
      name_res: json['name_res']);
}
