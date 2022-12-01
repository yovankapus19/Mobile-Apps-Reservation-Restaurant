import 'package:flutter_ecommerce/users/model/cart.dart';
import 'package:flutter_ecommerce/users/model/restaurant.dart';
import 'package:get/get.dart';

class RestaurantController extends GetxController {
  RxList<Clothes2> _cartlist = <Clothes2>[].obs;

  List<Clothes2> get cartList => _cartlist.value;

  setList(List<Clothes2> list) {
    _cartlist.value = list;
  }
}
