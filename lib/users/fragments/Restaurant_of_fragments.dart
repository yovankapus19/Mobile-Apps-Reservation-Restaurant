import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/controllers/categoryData.dart';
import 'package:flutter_ecommerce/users/controllers/restaurant_list_controller.dart';
import 'package:flutter_ecommerce/users/fragments/filterKategori.dart';
import 'package:flutter_ecommerce/users/fragments/home_fragments_screen.dart';
import 'package:flutter_ecommerce/users/fragments/showMore_screen.dart';
import 'package:flutter_ecommerce/users/model/categoryModel.dart';
import 'package:flutter_ecommerce/users/model/restaurant.dart';
import 'package:flutter_ecommerce/users/userPrefrences/current_user.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final List<String> imgList = [
  'images/iklan1.png',
  'images/iklan2.png',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    // Image.asset(item),
                    Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class Restaurant extends StatefulWidget {
  const Restaurant({super.key});
  // final CurrentUser _currentUser = Get.put(CurrentUser());

  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  // final CurrentUser _currentUser = Get.put(CurrentUser());
  final CurrentUser _currentUser = Get.put(CurrentUser());

  // Crousel
  int _current = 0;
  final CarouselController _controller = CarouselController();
  // get our categories list
  List<CategoryModel> categories = <CategoryModel>[];
  final cartListController = Get.put(RestaurantController());

  Future<List<Clothes2>> getTrendingRestaurantItems() async {
    List<Clothes2> trendingRestaurantList = [];
    try {
      var res = await http.get(Uri.parse(API.getAllRestaurant));
      if (res.statusCode == 200) {
        var responseBodyOfTrending = jsonDecode(res.body);
        if (responseBodyOfTrending["success"] == true) {
          (responseBodyOfTrending["clothItemsData"] as List)
              .forEach((eachRecord) {
            trendingRestaurantList.add(Clothes2.fromJson(eachRecord));
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
      body: ListView(
        children: [
          Container(
            color: Color.fromRGBO(118, 17, 28, 1),
            child: Column(
              children: [
                //Custom AppBar Widget
                appBarWidget(context),
                // Item Information
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(Get.context!).size.height * 0.73,
                    width: MediaQuery.of(Get.context!).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, -3),
                            blurRadius: 6,
                            color: Colors.grey,
                          )
                        ]),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 18,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 20, left: 10),
                                child: Text(
                                  "Categories",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              CategoryWidget(),
                              const SizedBox(
                                height: 20,
                              ),
                              CarouselSlider(
                                items: imageSliders,
                                carouselController: _controller,
                                options: CarouselOptions(
                                    viewportFraction: 1,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    aspectRatio: 2 / 1,
                                    onPageChanged: (index, reason) {
                                      // setState(() {
                                      //   _current = index;
                                      // });
                                    }),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 1, left: 10),
                                    child: Text(
                                      "Popular Restaurant",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 130,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(ListRestaurant());
                                    },
                                    child: const Text(
                                      "See More",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  )
                                ],
                              ),
                              trendingMostPopularClothItemWidget(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget appBarWidget(context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      color: Color.fromRGBO(118, 17, 28, 1),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        "Hi, " + _currentUser.user.user_name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  padding: EdgeInsets.all(8),
                  child: Transform.scale(
                    scale: 3,
                    child: IconButton(
                      icon: Image.asset(
                        'images/octo.png',
                      ),
                      onPressed: () {},
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget CategoryWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1),
                child: Container(
                  padding: EdgeInsets.all(8),
                  // decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //     boxShadow: [
                  //       BoxShadow(
                  //           color: Colors.grey.withOpacity(0.5),
                  //           spreadRadius: 2,
                  //           blurRadius: 10,
                  //           offset: Offset(0, 3))
                  //     ]),
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70.0,
                            padding: EdgeInsets.symmetric(horizontal: 17),
                            child: ListView.builder(
                              itemCount: categories.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return CategoryTile(
                                  imageUrl: categories[index].imageUrl,
                                  categoryName: categories[index].categoryName,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget trendingMostPopularClothItemWidget(context) {
    return FutureBuilder(
      future: getTrendingRestaurantItems(),
      builder: (context, AsyncSnapshot<List<Clothes2>> dataSnapShot) {
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
                Clothes2 eachClothItemData = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    // Get.to(HomeFragmentScreen(sitemInfo: eachClothItemData));
                    Get.to(() => HomeFragmentScreen(
                        itemInfo2: eachClothItemData.id_restrauran));
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
                                      eachClothItemData.name_res!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      eachClothItemData.jarak!.toString() +
                                          " Meters",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              // Rating Start & Rating numbers
                              Row(
                                children: [
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
                                    itemSize: 20,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "(${eachClothItemData.rating_rest!})",
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
}

class CategoryTile extends StatelessWidget {
  final String categoryName, imageUrl;
  CategoryTile({required this.categoryName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterCategory(
                categoryName: categoryName.toLowerCase(),
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: FadeInImage(
                width: 170,
                height: 90,
                fit: BoxFit.cover,
                placeholder: const AssetImage("images/place_holder.png"),
                image: NetworkImage(imageUrl),
                imageErrorBuilder: ((context, error, stackTraceError) {
                  return const Center(
                    child: Icon(Icons.broken_image_outlined),
                  );
                }),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 170,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
