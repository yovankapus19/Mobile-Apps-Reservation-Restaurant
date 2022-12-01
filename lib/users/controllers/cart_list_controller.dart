import 'package:flutter_ecommerce/users/model/cart.dart';
import 'package:get/get.dart';

class CartListController extends GetxController {
  RxList<Cart> _cartlist = <Cart>[].obs;
  RxList<int> _selectedItemList = <int>[].obs;
  RxBool _isSelectedAll = false.obs;
  RxDouble _total = 0.0.obs;
  RxInt _cartId = 0.obs;

  List<Cart> get cartList => _cartlist.value;
  List<int> get selectedItemList => _selectedItemList.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;
  int get id_cart => _cartId.value;

  setList(List<Cart> list) {
    _cartlist.value = list;
  }

  addSelecteditem(int selectedItemCartID) {
    _selectedItemList.value.add(selectedItemCartID);
    update();
  }

  deleteSelected(int selectedItemCartID) {
    _selectedItemList.value.remove(selectedItemCartID);
    update();
  }

  setIsSelectedAllItems() {
    _isSelectedAll.value = !_isSelectedAll.value;
  }

  clearAllSelectedItems() {
    _selectedItemList.value.clear();
    update();
  }

  setTotal(double overallTotal) {
    _total.value = overallTotal;
  }

  setCartId(int cart) {
    _cartId.value = cart;
  }
}
