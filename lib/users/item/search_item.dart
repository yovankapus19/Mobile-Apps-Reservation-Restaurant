import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/fragments/home_fragments_screen.dart';
import 'package:flutter_ecommerce/users/item/item_detail_screen.dart';
import 'package:flutter_ecommerce/users/model/restFood.dart';
import 'package:flutter_ecommerce/users/model/restaurant.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:money_formatter/money_formatter.dart';

class SearchItem extends StatefulWidget {
  final String? typedKeyWords;

  const SearchItem({super.key, this.typedKeyWords});

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  TextEditingController searchController = TextEditingController();
  Future<List<Clothes2>> readSearchRecordsFound() async {
    List<Clothes2> restaurantSearchList = [];
    if (searchController.text != "") {
      try {
        var res = await http.post(
          Uri.parse(API.searchItems),
          body: {
            "typedKeyWords": searchController.text,
          },
        );
        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);
          if (responseBodyOfSearchItems['success'] == true) {
            (responseBodyOfSearchItems['itemsFoundData'] as List)
                .forEach((eachItemData) {
              restaurantSearchList.add(Clothes2.fromJson(eachItemData));
            });
          } else {
            // Fluttertoast.showToast(msg: "Error Occurred While Executing Query");
          }
        } else {
          Fluttertoast.showToast(msg: "Status Code Is Not 200");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Error: " + e.toString());
      }
    }
    return restaurantSearchList;
  }

  @override
  void initState() {
    // Membuat tulisan pencarian tetap ada ketika button search di click
    searchController.text = widget.typedKeyWords!;
    // searchController.text = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: showSearchBarWidget(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        backgroundColor: Color.fromRGBO(118, 17, 28, 1),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: allFoodByRestaurant(context),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 1,
      ),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 300,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: IconButton(
                        onPressed: () {
                          // Untuk mengganti keadaan pencarian ketika ada objek yang berubah, kemudian akan melakukan build ulang pada widget tersebut
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Color.fromRGBO(118, 17, 28, 1),
                        ),
                      ),
                      suffix: IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                        icon: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: const Icon(
                            Icons.close,
                            color: Color.fromRGBO(118, 17, 28, 1),
                          ),
                        ),
                      ),
                      hintText: "Search With Your Own Style",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget allFoodByRestaurant(context) {
    return FutureBuilder(
      future: readSearchRecordsFound(),
      builder: (context, AsyncSnapshot<List<Clothes2>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text(
              "No Trending item found",
            ),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return SizedBox(
            height: 1000,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Clothes2 eachClothItemData = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    // Get.to(HomeFragmentScreen(sitemInfo: eachClothItemData));
                    Get.to(() => HomeFragmentScreen(
                        itemInfo2: eachClothItemData.id_restrauran));
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
                    child: Row(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                          child: FadeInImage(
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder:
                                const AssetImage("images/place_holder.png"),
                            image: NetworkImage(
                              eachClothItemData.images_res!,
                            ),
                            imageErrorBuilder:
                                ((context, error, stackTraceError) {
                              return const Center(
                                child: Icon(Icons.broken_image_outlined),
                              );
                            }),
                          ),
                        ),
                        // name + price + tags
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15, bottom: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name and Price
                                Row(
                                  children: [
                                    // Name
                                    Expanded(
                                      child: Text(
                                        eachClothItemData.name_res!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    RatingBar.builder(
                                      initialRating:
                                          eachClothItemData.rating_rest!,
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
                                      itemSize: 12,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "(${eachClothItemData.rating_rest!})",
                                      style: TextStyle(color: Colors.grey),
                                    ),

                                    // Price
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: const Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "2000 Ulasan",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                                // Tags
                              ],
                            ),
                          ),
                        ),
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
}
