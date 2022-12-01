import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/users/fragments/Restaurant_of_fragments.dart';
import 'package:flutter_ecommerce/users/fragments/Tiket_of_screen.dart';
import 'package:flutter_ecommerce/users/fragments/booking_of_screen.dart';

import 'package:flutter_ecommerce/users/fragments/home_fragments_screen.dart';

import 'package:flutter_ecommerce/users/fragments/profile_fragments_screen.dart';
import 'package:flutter_ecommerce/users/userPrefrences/current_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DashboardOfFragments extends StatelessWidget {
  // const DashboardOfFragments({super.key});
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  final List<Widget> _fragmentScreens = [
    Restaurant(),
    Tiket(),
    ProfileFragmentScreen()
  ];

  final List _navigationButtonsProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home"
    },
    {
      "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "Orders"
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline,
      "label": "Profile"
    },
  ];

  final RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (CurrentUser) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Obx(
              () => _fragmentScreens[_indexNumber.value],
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              backgroundColor: Color.fromRGBO(118, 17, 28, 1),
              currentIndex: _indexNumber.value,
              onTap: (value) {
                _indexNumber.value = value;
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.white24,
              unselectedItemColor: Colors.white,
              items: List.generate(3, (index) {
                var navBtnProperty = _navigationButtonsProperties[index];
                return BottomNavigationBarItem(
                    backgroundColor: Color.fromRGBO(118, 17, 28, 1),
                    icon: Icon(navBtnProperty["non_active_icon"]),
                    activeIcon: Icon(navBtnProperty["active_icon"]),
                    label: navBtnProperty["label"]);
              }),
            ),
          ),
        );
      },
    );
  }
}
