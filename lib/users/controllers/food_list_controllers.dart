import 'package:flutter_ecommerce/users/model/cart.dart';
import 'package:flutter_ecommerce/users/model/restFood.dart';
import 'package:get/get.dart';

class RestaurantListController extends GetxController {
  RxList<RestFood> _cartlist = <RestFood>[].obs;

  List<RestFood> get cartList => _cartlist.value;

  setList(List<RestFood> list) {
    _cartlist.value = list;
  }
}
