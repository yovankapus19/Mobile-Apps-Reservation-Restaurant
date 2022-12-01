import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/controllers/item_details_controllers.dart';
import 'package:flutter_ecommerce/users/model/food.dart';
import 'package:flutter_ecommerce/users/model/restFood.dart';
import 'package:flutter_ecommerce/users/userPrefrences/current_user.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

class ItemDetailsScreen extends StatefulWidget {
  final RestFood? itemInfo;
  const ItemDetailsScreen({super.key, this.itemInfo});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final itemDetailsController = Get.put(ItemDetailsController());
  final currentOnLineUser = Get.put(CurrentUser());
  var tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());
  addItemToCart() async {
    print(tanggal);
    try {
      var res = await http.post(
        Uri.parse(API.addToCartTemp),
        body: {
          "id_kategori": widget.itemInfo!.id_kategori!.toString(),
          "user_id": currentOnLineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id!.toString(),
          "quantity": itemDetailsController.quantity.toString(),
          "color": widget.itemInfo!.colors![itemDetailsController.color],
          "size": widget.itemInfo!.sizes![itemDetailsController.size],
          "date": tanggal
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfAddCart = jsonDecode(res.body);
        if (resBodyOfAddCart['success'] == true) {
          Fluttertoast.showToast(msg: "Item added to cart");
          try {
            var res = await http.post(
              Uri.parse(API.addToCart),
              body: {
                "id_kategori": widget.itemInfo!.id_kategori!.toString(),
                "user_id": currentOnLineUser.user.user_id.toString(),
                "item_id": widget.itemInfo!.item_id!.toString(),
                "quantity": itemDetailsController.quantity.toString(),
                "color": widget.itemInfo!.colors![itemDetailsController.color],
                "size": widget.itemInfo!.sizes![itemDetailsController.size],
                "date": tanggal
              },
            );
            if (res.statusCode == 200) {
              var resBodyOfAddCart = jsonDecode(res.body);
              if (resBodyOfAddCart['success'] == true) {
              } else {
                Fluttertoast.showToast(
                    msg: "Error Occur.\nItem not saved to cart and Try Again");
              }
            } else {
              Fluttertoast.showToast(msg: "Status is not 200");
            }
          } catch (e) {
            print("Error : " + e.toString());
          }
        } else {
          Fluttertoast.showToast(
              msg: "Error Occur.\nItem not saved to cart and Try Again");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (e) {
      print("Error : " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Item Image
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage("images/place_holder.png"),
            image: NetworkImage(
              widget.itemInfo!.image!,
            ),
            imageErrorBuilder: ((context, error, stackTraceError) {
              return const Center(
                child: Icon(Icons.broken_image_outlined),
              );
            }),
          ),
          // Item Information
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          )
        ],
      ),
    );
  }

  Widget itemInfoWidget() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),
            Center(
              child: Container(
                height: 8,
                width: 140,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            // Name
            Text(
              widget.itemInfo!.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),

            // Tags
            Text(
              widget.itemInfo!.tags
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", ""),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating + Rating Num
                      Row(
                        children: [
                          // Rating
                          RatingBar.builder(
                            initialRating: widget.itemInfo!.rating!,
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
                          // Rating Num

                          Text(
                            "(${widget.itemInfo!.rating!})",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      // Price
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                          MoneyFormatter(
                              amount: widget.itemInfo!.price!,
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
                      const SizedBox(
                        height: 10,
                      ),

                      const SizedBox(
                        height: 16,
                      ),
                      // Description
                      const Text(
                        "Description :",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        widget.itemInfo!.description!,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
                ),
                // Quantity item Counter
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // +
                      IconButton(
                        onPressed: () {
                          itemDetailsController.setQuantityItem(
                              itemDetailsController.quantity + 1);
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        itemDetailsController.quantity.toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      // -
                      IconButton(
                        onPressed: () {
                          // kondisi Jika counter sudah kurang dari 1 maka tetap diangka 1 tidak 0
                          if (itemDetailsController.quantity - 1 >= 1) {
                            itemDetailsController.setQuantityItem(
                                itemDetailsController.quantity - 1);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Quantity must be 1 or greeter than 1");
                          }
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Size
            const Text(
              "Sizes",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(
                widget.itemInfo!.sizes!.length,
                (index) {
                  return Obx(
                    () => GestureDetector(
                      onTap: () {
                        itemDetailsController.setSizeItem(index);
                      },
                      child: Container(
                        height: 35,
                        width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: itemDetailsController.size == index
                                    ? Colors.transparent
                                    : Colors.grey),
                            color: itemDetailsController.size == index
                                ? Color.fromRGBO(118, 17, 28, 1)
                                : Colors.white),
                        alignment: Alignment.center,
                        child: Text(
                          widget.itemInfo!.sizes![index]
                              .replaceAll("[", "")
                              .replaceAll("]", ""),
                          style: TextStyle(
                              fontSize: 16,
                              color: itemDetailsController.size == index
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Colors
            const Text(
              "Flavour :",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(
                widget.itemInfo!.colors!.length,
                (index) {
                  return Obx(
                    () => GestureDetector(
                      onTap: () {
                        itemDetailsController.setColorItem(index);
                      },
                      child: Container(
                        height: 35,
                        width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: itemDetailsController.color == index
                                    ? Colors.transparent
                                    : Colors.grey),
                            color: itemDetailsController.color == index
                                ? Color.fromRGBO(118, 17, 28, 1)
                                : Colors.white),
                        alignment: Alignment.center,
                        child: Text(
                          widget.itemInfo!.colors![index]
                              .replaceAll("[", "")
                              .replaceAll("]", ""),
                          style: TextStyle(
                              fontSize: 13,
                              color: itemDetailsController.color == index
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Add to cart button
            Material(
              elevation: 4,
              color: Color.fromRGBO(118, 17, 28, 1),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  addItemToCart();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
