import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/controllers/categoryData.dart';
import 'package:flutter_ecommerce/users/controllers/restaurant_list_controller.dart';
import 'package:flutter_ecommerce/users/fragments/home_fragments_screen.dart';
import 'package:flutter_ecommerce/users/fragments/showMore_screen.dart';
import 'package:flutter_ecommerce/users/model/categoryFilter.dart';
import 'package:flutter_ecommerce/users/model/categoryModel.dart';
import 'package:flutter_ecommerce/users/model/restaurant.dart';
import 'package:flutter_ecommerce/users/userPrefrences/current_user.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FilterCategory extends StatefulWidget {
  final String? categoryName;
  const FilterCategory({super.key, this.categoryName});
  // final CurrentUser _currentUser = Get.put(CurrentUser());

  @override
  State<FilterCategory> createState() => _FilterCategoryState();
}

class _FilterCategoryState extends State<FilterCategory> {
  // final CurrentUser _currentUser = Get.put(CurrentUser());
  final CurrentUser _currentUser = Get.put(CurrentUser());

  // Crousel
  int _current = 0;
  final CarouselController _controller = CarouselController();
  // get our categories list
  List<CategoryModel> categories = <CategoryModel>[];
  final cartListController = Get.put(RestaurantController());

  Future<List<CategoryFilter>> getTrendingRestaurantItems() async {
    List<CategoryFilter> trendingRestaurantList = [];
    try {
      var res = await http.post(Uri.parse(API.kategoriFilter), body: {
        "nama_kategori": widget.categoryName!.toString(),
      });
      if (res.statusCode == 200) {
        var responseBodyOfTrending = jsonDecode(res.body);
        if (responseBodyOfTrending["success"] == true) {
          (responseBodyOfTrending["currentUserCartData"] as List)
              .forEach((eachRecord) {
            trendingRestaurantList.add(CategoryFilter.fromJson(eachRecord));
          });
        }
        print(trendingRestaurantList);
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is Not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return trendingRestaurantList;
  }

  @override
  void initState() {
    super.initState();
    categories = getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("List Restaurant"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),
          backgroundColor: Color.fromRGBO(118, 17, 28, 1),
        ),
        body: Container(
          child: ListView(
            children: [
              // Show All Restaurant
              trendingMostPopularClothItemWidget(context)
            ],
          ),
        ));
  }

  Widget trendingMostPopularClothItemWidget(context) {
    return FutureBuilder(
      future: getTrendingRestaurantItems(),
      builder: (context, AsyncSnapshot<List<CategoryFilter>> dataSnapShot) {
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
            height: 1000,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                CategoryFilter eachClothItemData = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    // Get.to(HomeFragmentScreen(sitemInfo: eachClothItemData));
                    Get.to(HomeFragmentScreen(
                      itemInfo: null,
                      itemInfo2: eachClothItemData.id_restrauran,
                    ));
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
