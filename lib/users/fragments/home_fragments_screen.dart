import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/cart/cart_list_screen.dart';
import 'package:flutter_ecommerce/users/controllers/cart_list_controller.dart';
import 'package:flutter_ecommerce/users/controllers/food_list_controllers.dart';
import 'package:flutter_ecommerce/users/item/item_detail_screen.dart';
import 'package:flutter_ecommerce/users/model/food.dart';
import 'package:flutter_ecommerce/users/model/imagesRestaurant.dart';
import 'package:flutter_ecommerce/users/model/restFood.dart';
import 'package:flutter_ecommerce/users/model/restaurant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:money_formatter/money_formatter.dart';
import 'package:map_launcher/map_launcher.dart';

class HomeFragmentScreen extends StatelessWidget {
  final Clothes2? itemInfo;
  final int? itemInfo2;
  final cartListController = Get.put(RestaurantListController());
  HomeFragmentScreen({super.key, this.itemInfo, this.itemInfo2});
  TextEditingController searchController = TextEditingController();

  Future<List<ImagesRes>> images() async {
    List<ImagesRes> cartListOfCurrentUser = [];
    try {
      var res = await http.post(
        Uri.parse(API.imagesRes),
        body: {
          "id_restrauran": itemInfo2.toString(),
        },
      );
      if (res.statusCode == 200) {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);
        if (responseBodyOfGetCurrentUserCartItems['success'] == true) {
          (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List)
              .forEach((eachCurrentUserCartItem) {
            cartListOfCurrentUser
                .add(ImagesRes.fromJson(eachCurrentUserCartItem));
          });
        } else {
          // Fluttertoast.showToast(msg: "Error Occurred While Executing Query");
        }
      } else {
        Fluttertoast.showToast(msg: "Status code is not 200");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: " + e.toString());
    }
    return cartListOfCurrentUser;
  }

  Future<List<RestFood>> getCurrenUserCartList() async {
    List<RestFood> cartListOfCurrentUser = [];
    try {
      var res = await http.post(
        Uri.parse(API.getRestauranFood),
        body: {
          "id_restrauran": itemInfo2.toString(),
        },
      );
      if (res.statusCode == 200) {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);
        if (responseBodyOfGetCurrentUserCartItems['success'] == true) {
          (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List)
              .forEach((eachCurrentUserCartItem) {
            cartListOfCurrentUser
                .add(RestFood.fromJson(eachCurrentUserCartItem));
          });
        } else {
          // Fluttertoast.showToast(msg: "Error Occurred While Executing Query");
        }
        // Memasukan data dari json ke dalam list menggunakan fungsi setList
        cartListController.setList(cartListOfCurrentUser);
      } else {
        Fluttertoast.showToast(msg: "Status code is not 200");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: " + e.toString());
    }
    return cartListOfCurrentUser;
  }

  Future<List<RestFood>> getTrendingClothItems() async {
    List<RestFood> cartListOfCurrentUser = [];
    try {
      var res = await http.post(
        Uri.parse(API.getTrendingMostPopularClothes),
        body: {
          "id_restrauran": itemInfo2.toString(),
        },
      );
      if (res.statusCode == 200) {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);
        if (responseBodyOfGetCurrentUserCartItems['success'] == true) {
          (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List)
              .forEach((eachCurrentUserCartItem) {
            cartListOfCurrentUser
                .add(RestFood.fromJson(eachCurrentUserCartItem));
          });
        } else {
          // Fluttertoast.showToast(msg: "Error Occurred While Executing Query");
        }
        // Memasukan data dari json ke dalam list menggunakan fungsi setList
        cartListController.setList(cartListOfCurrentUser);
      } else {
        Fluttertoast.showToast(msg: "Status code is not 200");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: " + e.toString());
    }
    return cartListOfCurrentUser;
  }

// Maps Function
  openMapsSheet(context, title_res) async {
    try {
      final coords = Coords(-6.2157695, 106.8161829);
      final title = title_res;
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                          onTap: () => map.showMarker(
                                coords: coords,
                                title: title,
                              ),
                          title: Text(map.mapName),
                          leading: Icon(Icons.launch_rounded)),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        backgroundColor: Color.fromRGBO(118, 17, 28, 1),
        title: const Text("Restaurant"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Custom AppBar Widget

            imagesres2(context),

            const SizedBox(
              height: 16,
            ),
            // Search Bar Widget
            showSearchBarWidget(),
            const SizedBox(
              height: 24,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Trending Food",
                style: TextStyle(
                  color: Color.fromRGBO(118, 17, 28, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            // Trending Popular Item
            trendingMostPopularClothItemWidget(context),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Recommendation For You",
                style: TextStyle(
                  color: Color.fromRGBO(118, 17, 28, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            allFoodByRestaurant(context)
            //
          ],
        ),
      ),
    );
  }

  Widget showSearchBarWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: () {
          Get.to(CartListScreen());
        },
        icon: const Icon(
          Icons.shopping_cart,
          color: Color.fromRGBO(118, 17, 28, 1),
        ),
      ),
    );
  }

  Widget trendingMostPopularClothItemWidget(context) {
    return FutureBuilder(
      future: getTrendingClothItems(),
      builder: (context, AsyncSnapshot<List<RestFood>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text(
              "No item found",
            ),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return SizedBox(
            height: 260,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                RestFood eachClothItemData = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    Get.to(ItemDetailsScreen(itemInfo: eachClothItemData));
                  },
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.fromLTRB(
                      index == 0 ? 16 : 8,
                      10,
                      index == dataSnapShot.data!.length - 1 ? 16 : 8,
                      10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 6,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // item image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22)),
                          child: FadeInImage(
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder:
                                const AssetImage("images/place_holder.png"),
                            image: NetworkImage(
                              eachClothItemData.image!,
                            ),
                            imageErrorBuilder:
                                ((context, error, stackTraceError) {
                              return const Center(
                                child: Icon(Icons.broken_image_outlined),
                              );
                            }),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Item name & price
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      eachClothItemData.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      MoneyFormatter(
                                          amount: eachClothItemData.price!,
                                          settings: MoneyFormatterSettings(
                                            symbol: 'Rp',
                                            thousandSeparator: '.',
                                            decimalSeparator: ',',
                                            symbolAndNumberSeparator: '',
                                            fractionDigits: 0,
                                          )).output.symbolOnLeft,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              // Rating Start & Rating numbers
                              Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: eachClothItemData.rating!,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemBuilder: (context, c) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (UpdateRating) {},
                                    ignoreGestures: true,
                                    unratedColor: Colors.grey,
                                    itemSize: 20,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "(${eachClothItemData.rating!})",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }

  Widget allFoodByRestaurant(context) {
    return FutureBuilder(
      future: getCurrenUserCartList(),
      builder: (context, AsyncSnapshot<List<RestFood>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text(
              "No Item Found",
            ),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (contex, index) {
                RestFood eachClothItemRecord = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                        index == dataSnapShot.data!.length - 1 ? 16 : 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 6,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Container(
                      // padding: EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Image
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              // borderRadius: const BorderRadius.only(
                              //     bottomRight: Radius.circular(20),
                              //     topRight: Radius.circular(20)),
                              child: FadeInImage(
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                                placeholder:
                                    const AssetImage("images/place_holder.png"),
                                image: NetworkImage(
                                  eachClothItemRecord.image!,
                                ),
                                imageErrorBuilder:
                                    ((context, error, stackTraceError) {
                                  return const Center(
                                    child: Icon(Icons.broken_image_outlined),
                                  );
                                }),
                              ),
                            ),
                          ),
                          // name + price + tags
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    width: 70,
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: RatingBar.builder(
                                            initialRating: 1,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 1,
                                            itemBuilder: (context, c) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (UpdateRating) {},
                                            ignoreGestures: true,
                                            unratedColor: Colors.grey,
                                            itemSize: 20,
                                          ),
                                        ),
                                        Text(
                                          '(4.7)',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),

                                  // Name and Price
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Row(
                                      children: [
                                        // Name
                                        Expanded(
                                          child: Text(
                                            eachClothItemRecord.name!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 0),
                                            child: Text(
                                                MoneyFormatter(
                                                    amount: eachClothItemRecord
                                                        .price!,
                                                    settings:
                                                        MoneyFormatterSettings(
                                                      symbol: 'Rp ',
                                                      thousandSeparator: '.',
                                                      decimalSeparator: ',',
                                                      symbolAndNumberSeparator:
                                                          '',
                                                      fractionDigits: 0,
                                                    )).output.symbolOnLeft,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ),
                                        // Price
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 16,
                                  ),
                                  // Tags
                                  Text(
                                    "${eachClothItemRecord.tags.toString().replaceAll("[", "").replaceAll("]", "")}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        } else {
          return const Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }

  Widget imagesres2(context) {
    return FutureBuilder(
      future: images(),
      builder: (context, AsyncSnapshot<List<ImagesRes>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text(
              "No Item Found",
            ),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (contex, index) {
                ImagesRes eachClothItemRecord = dataSnapShot.data![index];
                return GestureDetector(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(eachClothItemRecord.images_res!),
                          fit: BoxFit.cover),
                      color: Color.fromRGBO(118, 17, 28, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    height: 240,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30)),
                                alignment: Alignment.center,
                                child: Text(
                                  eachClothItemRecord.rating_rest!.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 80,
                            width: double.infinity,
                            alignment: Alignment.bottomCenter,
                            // color: Colors.green,
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      color: Color.fromRGBO(118, 17, 28, 1)
                                          .withOpacity(0.9),
                                    ),
                                    margin: EdgeInsets.only(
                                        top: 10, bottom: 0, left: 0),
                                    height: 80,
                                    width: 140,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                eachClothItemRecord.filter!,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              margin: EdgeInsets.only(left: 7),
                                              child: Text(
                                                  eachClothItemRecord.alamat!,
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 220,
                                    // color: Colors.yellow,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return Padding(
                                                    padding:
                                                        MediaQuery.of(context)
                                                            .viewInsets,
                                                    child: Container(
                                                      height: 350,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                          top: Radius.circular(
                                                              40),
                                                          //bottom: Radius.circular(30),
                                                        ), //BorderRadius.verticalBorderRadius.Only
                                                      ),
                                                      child: Column(
                                                        //mainAxisAlignment: MainAxisAlignment.center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              IconButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  icon: Icon(Icons
                                                                      .close_rounded)),
                                                              const Text(
                                                                "Review Pelanggan",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(''),
                                                              Text(''),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          const Divider(
                                                            color: Colors.black,
                                                            height: 20,
                                                            thickness: 2,
                                                            indent: 10,
                                                            endIndent: 10,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    right: 10),
                                                            width:
                                                                double.infinity,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .white54),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                      'Dimas'),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                      'Harganya Murah Kualitas Baik'),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                      '4.2'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 10),
                                                            width:
                                                                double.infinity,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .grey),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                      'Dwi'),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                      'Pelayanannya Memuaskan'),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                      '4.9'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 10),
                                                            width:
                                                                double.infinity,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .white54),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                      'Heri'),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                      'Tempatnya Bagus'),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                      '4.0'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ));
                                              },
                                            )
                                          },
                                          child: Text("Review"),
                                          style: ElevatedButton.styleFrom(
                                            elevation: 5,
                                            primary:
                                                Color.fromRGBO(118, 17, 28, 1)
                                                    .withOpacity(0.8),
                                            shadowColor: Colors.transparent
                                                .withOpacity(0.1),
                                            side: BorderSide(
                                              width: 0.5,
                                              color: Colors.black,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => openMapsSheet(
                                              context,
                                              eachClothItemRecord.name_res
                                                  .toString()),
                                          child: Text("Maps"),
                                          style: ElevatedButton.styleFrom(
                                            elevation: 5,
                                            primary:
                                                Color.fromRGBO(118, 17, 28, 1)
                                                    .withOpacity(0.8),
                                            shadowColor: Colors.transparent
                                                .withOpacity(0.1),
                                            side: BorderSide(
                                              width: 0.5,
                                              color: Colors.black,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        } else {
          return const Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }
}
