import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/controllers/cart_list_controller.dart';
import 'package:flutter_ecommerce/users/fragments/booking_of_screen.dart';
import 'package:flutter_ecommerce/users/model/cart.dart';
import 'package:flutter_ecommerce/users/model/food.dart';
import 'package:flutter_ecommerce/users/userPrefrences/current_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:money_formatter/money_formatter.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({super.key});

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  final currentOnLineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrenUserCartList() async {
    List<Cart> cartListOfCurrentUser = [];
    try {
      var res = await http.post(
        Uri.parse(API.getCartList),
        body: {
          "currentOnLineUserId": currentOnLineUser.user.user_id.toString(),
        },
      );
      if (res.statusCode == 200) {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);
        if (responseBodyOfGetCurrentUserCartItems['success'] == true) {
          (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List)
              .forEach((eachCurrentUserCartItem) {
            cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItem));
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
    calculateTotalAmount();
  }

  addItemToSummary(cart_id, total) async {
    try {
      var res = await http.post(
        Uri.parse(API.addSummary),
        body: {"cart_id": cart_id, "total": total},
      );
      if (res.statusCode == 200) {
        var resBodyOfAddCart = jsonDecode(res.body);
        if (resBodyOfAddCart['success'] == true) {
          Get.to(BookingSummary());
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

  calculateTotalAmount() {
    cartListController.setTotal(0);
    if (cartListController.selectedItemList.length > 0) {
      print(cartListController.selectedItemList);
      cartListController.cartList.forEach((itemInCart) {
        if (cartListController.selectedItemList.contains(itemInCart.cart_id!)) {
          double eachitemtotalAmount = (itemInCart.price!) *
              (double.parse(itemInCart.quantity.toString()));
          cartListController
              .setTotal(cartListController.total + eachitemtotalAmount);
        }
      });
    }
  }

  deleteSelectedItemsFromUserCartList(int cartID) async {
    try {
      var res = await http
          .post(Uri.parse(API.deleteSelectedItemsFromCartList), body: {
        "cart_id": cartID.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyFromDeleteCart = jsonDecode(res.body);

        if (responseBodyFromDeleteCart["success"] == true) {
          getCurrenUserCartList();
        }
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    } catch (errorMessage) {
      print("Error: " + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrenUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        backgroundColor: Color.fromARGB(255, 106, 17, 17),
        title: const Text("Cart"),
        actions: [
          // To Selected All Item
          Obx(
            () => IconButton(
              onPressed: () {
                cartListController.setIsSelectedAllItems();
                cartListController.clearAllSelectedItems();

                if (cartListController.isSelectedAll) {
                  cartListController.cartList.forEach((eachItem) {
                    cartListController.addSelecteditem(eachItem.cart_id!);
                  });
                }
                calculateTotalAmount();
              },
              icon: Icon(cartListController.isSelectedAll
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              color: cartListController.isSelectedAll
                  ? Colors.white
                  : Colors.white,
            ),
          ),
          // To Delete selected All Item
          GetBuilder(
              init: CartListController(),
              builder: (c) {
                if (cartListController.selectedItemList.length > 0) {
                  return IconButton(
                    onPressed: () async {
                      var responseFromDialogBox = await Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.grey,
                          title: const Text("Delete"),
                          content: const Text(
                              "Are you sure to Delete selected items from your Cart List?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back(result: "yesDelete");
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (responseFromDialogBox == "yesDelete") {
                        cartListController.selectedItemList
                            .forEach((selectedItemUserCartID) {
                          //delete selected items now
                          deleteSelectedItemsFromUserCartList(
                              selectedItemUserCartID);
                        });
                      }

                      calculateTotalAmount();
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      size: 26,
                      color: Colors.redAccent,
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
      body: Obx(() => cartListController.cartList.length > 0
          ? ListView.builder(
              itemCount: cartListController.cartList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Cart cartModel = cartListController.cartList[index];
                cartListController.setCartId(cartModel.cart_id!);

                Clothes clothesModel = Clothes(
                  item_id: cartModel.item_id,
                  colors: cartModel.colors,
                  image: cartModel.image,
                  name: cartModel.name,
                  price: cartModel.price,
                  rating: cartModel.rating,
                  sizes: cartModel.sizes,
                  description: cartModel.description,
                  tags: cartModel.tags,
                );
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      //check box
                      GetBuilder(
                        init: CartListController(),
                        builder: (c) {
                          return IconButton(
                            onPressed: () {
                              if (cartListController.selectedItemList
                                  .contains(cartModel.cart_id)) {
                                cartListController
                                    .deleteSelected(cartModel.cart_id!);
                              } else {
                                cartListController
                                    .addSelecteditem(cartModel.cart_id!);

                                calculateTotalAmount();
                              }
                              calculateTotalAmount();
                            },
                            icon: Icon(
                              cartListController.selectedItemList
                                      .contains(cartModel.cart_id)
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: cartListController.isSelectedAll
                                  ? Colors.white
                                  : Colors.red[900],
                            ),
                          );
                        },
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              0,
                              index == 0 ? 16 : 8,
                              16,
                              index == cartListController.cartList.length - 1
                                  ? 16
                                  : 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 6,
                                  color: Colors.black,
                                ),
                              ]),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name
                                      Text(
                                        clothesModel.name.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      // Color size + price
                                      Row(
                                        children: [
                                          // Color size
                                          Expanded(
                                            child: Text(
                                              "Flavour : ${cartModel.color!.replaceAll('[', '').replaceAll(']', '')}" +
                                                  "\n" +
                                                  "Sizes : ${cartModel.size!.replaceAll('[', '').replaceAll(']', '')}",
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Qty : ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    cartModel.quantity
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0, right: 0),
                                                child: Text(
                                                    MoneyFormatter(
                                                            amount: clothesModel
                                                                .price!,
                                                            settings: MoneyFormatterSettings(
                                                                symbol: 'Rp',
                                                                thousandSeparator:
                                                                    '.',
                                                                decimalSeparator:
                                                                    ',',
                                                                symbolAndNumberSeparator:
                                                                    '',
                                                                fractionDigits:
                                                                    0,
                                                                compactFormatType:
                                                                    CompactFormatType
                                                                        .short))
                                                        .output
                                                        .symbolOnLeft,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      // Price

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // Increment & decrement
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  // borderRadius: const BorderRadius.only(
                                  //     bottomRight: Radius.circular(20),
                                  //     topRight: Radius.circular(20)),
                                  child: FadeInImage(
                                    height: 100,
                                    width: 130,
                                    fit: BoxFit.cover,
                                    placeholder: const AssetImage(
                                        "images/place_holder.png"),
                                    image: NetworkImage(
                                      clothesModel.image!,
                                    ),
                                    imageErrorBuilder:
                                        ((context, error, stackTraceError) {
                                      return const Center(
                                        child:
                                            Icon(Icons.broken_image_outlined),
                                      );
                                    }),
                                  ),
                                ),
                              )
                              // Image
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text("Cart Is Empty"),
            )),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (c) {
          return Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 106, 17, 17),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.white24,
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                // Total amount
                const Text(
                  "Total Amount : ",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white38,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(
                  width: 4,
                ),
                Obx(
                  () => Text(
                      MoneyFormatter(
                              amount: cartListController.total,
                              settings: MoneyFormatterSettings(
                                  symbol: 'Rp',
                                  thousandSeparator: '.',
                                  decimalSeparator: ',',
                                  symbolAndNumberSeparator: '',
                                  fractionDigits: 0,
                                  compactFormatType: CompactFormatType.short))
                          .output
                          .symbolOnLeft,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                //  Memberikan spasi
                const Spacer(),
                // Order Now Button
                Material(
                  color: cartListController.selectedItemList.length > 0
                      ? Color.fromARGB(255, 68, 9, 5)
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {
                      addItemToSummary(
                        cartListController.id_cart.toString(),
                        cartListController.total.toString(),
                      );
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        "Order Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
