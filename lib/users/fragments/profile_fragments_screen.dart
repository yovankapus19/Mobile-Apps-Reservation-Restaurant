import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/authentication/login_screen.dart';
import 'package:flutter_ecommerce/users/model/userSal.dart';
import 'package:flutter_ecommerce/users/userPrefrences/current_user.dart';
import 'package:flutter_ecommerce/users/userPrefrences/user_prefrences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:money_formatter/money_formatter.dart';

class ProfileFragmentScreen extends StatelessWidget {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  Future<List<Tabungan>> getSaldoUser() async {
    List<Tabungan> userSaldo = [];
    try {
      var res = await http.post(Uri.parse(API.saldo),
          body: {"user_id": _currentUser.user.user_id.toString()});
      if (res.statusCode == 200) {
        var responseBodyOfTrending = jsonDecode(res.body);
        if (responseBodyOfTrending["success"] == true) {
          (responseBodyOfTrending["currentUserCartData"] as List)
              .forEach((eachRecord) {
            userSaldo.add(Tabungan.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is Not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return userSaldo;
  }

  Widget userInfoItemProfile(IconData iconData, String userData, String email) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/octo.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8), BlendMode.dstATop),
        ),
        color: Color.fromRGBO(118, 17, 28, 1),
        borderRadius: BorderRadius.circular(30), //border corner radius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Xtra Savers',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(
                  height: 60,
                  width: 60,
                  child: Image.asset('images/octoduit.png'),
                )
              ],
            ),
          ),
          Container(
              alignment: Alignment.center,
              // margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(''),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      userData,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    // color: Colors.white,
                    child: Icon(
                      Icons.arrow_circle_right_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  email,
                  style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Container(
                  height: 80,
                  width: 80,
                  child: Image.asset('images/simbe.jpg'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget userSaldo(context) {
    return FutureBuilder(
        future: getSaldoUser(),
        builder: (context, AsyncSnapshot<List<Tabungan>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text(
                "Data Not Found",
              ),
            );
          }

          if (dataSnapShot.data!.length > 0) {
            return ListView.builder(
                itemCount: dataSnapShot.data!.length,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Tabungan eachClothItemData = dataSnapShot.data![index];

                  return Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/jkt.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.8), BlendMode.dstATop),
                      ),
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(30), //border corner radius
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                eachClothItemData.nama_tabungan.toString(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 60,
                                child: Image.asset('images/octoduit.png'),
                              )
                            ],
                          ),
                        ),
                        Container(
                            alignment: Alignment.center,
                            // margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(''),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    MoneyFormatter(
                                        amount:
                                            eachClothItemData.saldo!.toDouble(),
                                        settings: MoneyFormatterSettings(
                                          symbol: 'Rp ',
                                          thousandSeparator: '.',
                                          decimalSeparator: ',',
                                          symbolAndNumberSeparator: '',
                                          fractionDigits: 0,
                                        )).output.symbolOnLeft,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  // color: Colors.white,
                                  child: Icon(
                                    Icons.arrow_circle_right_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                eachClothItemData.nomor_rekening.toString(),
                                style: GoogleFonts.notoSans(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                height: 80,
                                width: 80,
                                child: Image.asset('images/simbe.jpg'),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text("Empty, No Data."),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(118, 17, 28, 1),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(118, 17, 28, 1),
          title: Text("My Accounts"),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60),
              topRight: Radius.circular(60),
            ),
            color: Colors.white,
          ),
          child: ListView(
            children: [
              CarouselSlider(
                items: [
                  userSaldo(context),
                  userInfoItemProfile(Icons.person, _currentUser.user.user_name,
                      _currentUser.user.user_email)
                ],

                //Slider Container properties
                options: CarouselOptions(
                  height: 180.0,
                  // enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 18 / 11,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 1000),
                  viewportFraction: 1,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Material(
                  color: Color.fromRGBO(118, 17, 28, 1),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () async {
                      var responResult = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                              'Are you sure?\nyou want to logout from app?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );

                      if (responResult == "OK") {
                        RememberUserPrefs.removeUserInfo().then(
                          (value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(32),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
