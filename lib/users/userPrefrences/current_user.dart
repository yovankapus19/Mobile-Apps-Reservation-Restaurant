import 'package:flutter_ecommerce/users/model/user.dart';
import 'package:flutter_ecommerce/users/userPrefrences/user_prefrences.dart';
import 'package:get/get.dart';

class CurrentUser extends GetxController {
  Rx<User> _currentUser = User(
    1,
    "",
    "",
    "",
  ).obs;

  User get user => _currentUser.value;

  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}
