import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/main.dart';
import 'package:flutter_ecommerce/users/fragments/Restaurant_of_fragments.dart';
import 'package:flutter_ecommerce/users/fragments/dashboard_of_fragments.dart';
import 'package:flutter_ecommerce/users/model/transaksi.dart';
import 'package:flutter_ecommerce/users/userPrefrences/current_user.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class Tiket extends StatelessWidget {
  Tiket({Key? key}) : super(key: key);
  final CurrentUser _currentUser = Get.put(CurrentUser());
  Future<List<Transaksi>> getCurrenUserCartList() async {
    List<Transaksi> cartListOfCurrentUser = [];
    try {
      var res = await http.post(
        Uri.parse(API.getTransaksi),
        body: {"user_id": _currentUser.user.user_id.toString()},
      );
      if (res.statusCode == 200) {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);
        if (responseBodyOfGetCurrentUserCartItems['success'] == true) {
          (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List)
              .forEach((eachCurrentUserCartItem) {
            cartListOfCurrentUser
                .add(Transaksi.fromJson(eachCurrentUserCartItem));
          });
        } else {
          Fluttertoast.showToast(msg: "Error Occurred While Executing Query");
        }
      } else {
        Fluttertoast.showToast(msg: "Status code is not 200");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: " + e.toString());
    }

    return cartListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(118, 17, 28, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Custom AppBar Widget
            data2(context),
          ],
        ),
      ),
    );
  }

  Widget data2(context) {
    return FutureBuilder(
        future: getCurrenUserCartList(),
        builder: (context, AsyncSnapshot<List<Transaksi>> dataSnapShot) {
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
                Transaksi eachClothItemRecord = dataSnapShot.data![index];
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.close_rounded),
                                  iconSize: 25,
                                  color: Colors.white30,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DashboardOfFragments()),
                                    );
                                  },
                                ),
                                const Text(
                                  'Close',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.share),
                                  iconSize: 20,
                                  color: Colors.white30,
                                  onPressed: () {
                                    FlutterShare.share(
                                        title: "Booking Code",
                                        text: "Kode Booking Anda : " +
                                            eachClothItemRecord.kode_unik
                                                .toString(),
                                        linkUrl: "");
                                  },
                                ),
                                const Text(
                                  'Share',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: TicketWidget(
                        width: 350,
                        height: 800,
                        isCornerRounded: true,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              child: Container(
                                height: 90,
                                width: 90,
                                child: Image.asset('images/octo.png'),
                              ),
                            ),
                            DottedLine(),
                            Container(
                              height: 110,
                              width: 110,
                              child: Image.network(
                                  'https://1.bp.blogspot.com/-zXiasUuw6Sc/YFDEyTTMR2I/AAAAAAAAEbM/NElK9ulVi4g5s_Sa4yCL96hzaajr_ST9wCLcBGAsYHQ/s1600/Logo%2BOCTO%2BMobile.png'),
                            ),
                            Text(
                              'Nominal',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 120, right: 90, top: 5),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                          MoneyFormatter(
                                              amount: eachClothItemRecord
                                                  .trans_total!,
                                              settings: MoneyFormatterSettings(
                                                symbol: 'Rp ',
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
                                )),
                            Container(
                              child: Text('Booking Code'),
                            ),
                            Container(
                                child: QrImage(
                              data: eachClothItemRecord.kode_unik.toString(),
                              version: QrVersions.auto,
                              size: 200.0,
                            )),
                            Container(
                              child: Text('Please scan this barcode'),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Pembayaran ke"),
                                  Flexible(
                                      child: Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        Text(eachClothItemRecord.name_res
                                            .toString())
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Waktu Transaksi'),
                                        Text(eachClothItemRecord.trans_date
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Text('Id transaksi'),
                                        Text(eachClothItemRecord.id_transaksi
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("No Referensi"),
                                        Text(eachClothItemRecord.kode_unik
                                            .toString())
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total Pembayaran'),
                                  Text(
                                      MoneyFormatter(
                                          amount:
                                              eachClothItemRecord.trans_total!,
                                          settings: MoneyFormatterSettings(
                                            symbol: 'Rp ',
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
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Detail Lainnya'),
                                  Text('MPAN 2891u39812u312'),
                                  Text('CPAN 2813u213123'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(
              child: Text("Empty, No Data."),
            );
          }
        });
  }
}
