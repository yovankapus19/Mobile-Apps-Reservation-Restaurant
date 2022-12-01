import 'dart:convert';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/fragments/Tiket_of_screen.dart';
import 'package:flutter_ecommerce/users/model/summary.dart';
import 'package:flutter_ecommerce/users/userPrefrences/current_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class BookingSummary extends StatefulWidget {
  const BookingSummary({super.key});

  @override
  State<BookingSummary> createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  // Random Booking Number
  int randomNumber = Random().nextInt(9000) + 1000;
  TextEditingController dateinput = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController oranginput = TextEditingController();
  // TextEditingController pininput = TextEditingController();
  int? bayar;
  bool isSwitched = false;
  final CurrentUser _currentUser = Get.put(CurrentUser());

  Future<List<Summary>> getSummaryForPay() async {
    List<Summary> cartListOfCurrentUser = [];
    try {
      var res = await http.post(
        Uri.parse(API.getSummary),
      );
      if (res.statusCode == 200) {
        var responseBodyOfTrending = jsonDecode(res.body);
        if (responseBodyOfTrending["success"] == true) {
          (responseBodyOfTrending["clothItemsData"] as List)
              .forEach((eachRecord) {
            cartListOfCurrentUser.add(Summary.fromJson(eachRecord));
          });
        }
        print(cartListOfCurrentUser);
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is Not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return cartListOfCurrentUser;
  }

  // Add Transaksi
  addTransaksiRecord(id_summary, trans_total, saldo, saldocek) async {
    try {
      var res = await http.post(
        Uri.parse(API.addTransaksi),
        body: {
          "id_summary": id_summary.toString(),
          "trans_total": trans_total.toString(),
          "trans_date": dateinput.text.trim(),
          "trans_time": timeinput.text.trim(),
          "jumlah_orang": oranginput.text.trim(),
          "id_rekening": bayar.toString(),
          "kode_unik": randomNumber.toString(),
          "user_id": _currentUser.user.user_id.toString()
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfAddCart = jsonDecode(res.body);
        if (resBodyOfAddCart['success'] == true) {
          try {
            if (saldocek < trans_total) {
              Fluttertoast.showToast(
                  msg:
                      "Maaf Saldo Anda Tidak Mencukupi Untuk Melakukan Transaksi Ini");
            } else {
              var res = await http.post(Uri.parse(API.updateSaldo), body: {
                'saldo': saldo.toString(),
                'user_id': _currentUser.user.user_id.toString(),
              });
              if (res.statusCode == 200) {
                var resBodyOfAddCart = jsonDecode(res.body);
                if (resBodyOfAddCart['success'] == true) {
                  Fluttertoast.showToast(msg: "Berhasil Melakukan Pembayaran");
                  try {
                    var res = await http.post(
                        Uri.parse(API.deleteSelectedItemsFromCartListTemp));
                    if (res.statusCode == 200) {
                      var resBodyOfDelete = jsonDecode(res.body);
                      if (resBodyOfDelete['success'] == true) {
                        Get.to(Tiket());
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Status is not 200");
                    }
                  } catch (e) {
                    print("Error : " + e.toString());
                  }
                }
              } else {
                Fluttertoast.showToast(msg: "Status is not 200");
              }
            }
          } catch (e) {
            print("Error : " + e.toString());
          }
        } else {
          Fluttertoast.showToast(msg: "Transaksi Gagal");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (e) {
      print("Error : " + e.toString());
    }
  }

  @override
  void initState() {
    dateinput.text = "";
    timeinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSummaryForPay(),
      builder: (context, AsyncSnapshot<List<Summary>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text(
              "No Data found",
            ),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Summary'),
              centerTitle: true,
              elevation: 0.0,
              leading: IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'images/octo.png',
                  width: 300,
                  height: 300,
                ),
              ),
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                  color: Color.fromRGBO(118, 17, 28, 1),
                ),
              ),
            ),
            body: ListView.builder(
                itemCount: dataSnapShot.data!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Summary eachClothItemData = dataSnapShot.data![index];
                  double number = eachClothItemData.total!.toDouble();
                  double servicefee = 8000;
                  double total = number + servicefee;
                  double saldo = eachClothItemData.saldo!.toDouble();
                  double saldoNasabah = saldo - total;

                  // double decimalDigit = 2;
                  return SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(Get.context!).size.width,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10, left: 20),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Detail Pembayaran ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Container(
                              height: 130,
                              width: MediaQuery.of(Get.context!).size.width,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  color: Colors.white70,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 7,
                                      spreadRadius: 5,
                                      offset: const Offset(0, 2),
                                    )
                                  ]),
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Harga',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                              MoneyFormatter(
                                                  amount: number,
                                                  settings:
                                                      MoneyFormatterSettings(
                                                    symbol: 'Rp',
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
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Service Fee (Flat)',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                              MoneyFormatter(
                                                  amount: servicefee,
                                                  settings:
                                                      MoneyFormatterSettings(
                                                    symbol: 'Rp',
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
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                      height: 20,
                                      thickness: 2,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Total Harga',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                              MoneyFormatter(
                                                  amount: total,
                                                  settings:
                                                      MoneyFormatterSettings(
                                                    symbol: 'Rp',
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, left: 20),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Detail Pemesanan ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Container(
                              height: 250,
                              width: MediaQuery.of(Get.context!).size.width,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  color: Colors.white70,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 7,
                                      spreadRadius: 5,
                                      offset: Offset(0, 2),
                                    )
                                  ]),
                              alignment: Alignment.center,
                              child: Flexible(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 13, left: 10, right: 20),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            controller:
                                                dateinput, //editing controller of this TextField
                                            decoration: const InputDecoration(
                                                icon: Icon(Icons
                                                    .calendar_today), //icon of text field
                                                labelText:
                                                    "Input Date" //label text of field
                                                ),
                                            readOnly:
                                                true, //set it true, so that user will not able to edit text
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(
                                                          2000), //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime(2101));

                                              if (pickedDate != null) {
                                                print(
                                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                String formattedDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(pickedDate);
                                                print(
                                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                                //you can implement different kind of Date Format here according to your requirement

                                                setState(() {
                                                  dateinput.text =
                                                      formattedDate; //set output date to TextField value.
                                                });
                                              } else {
                                                print("Date is not selected");
                                              }
                                            },
                                          )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 13, left: 10, right: 20),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            controller:
                                                timeinput, //editing controller of this TextField
                                            decoration: const InputDecoration(
                                                icon: Icon(Icons
                                                    .timer), //icon of text field
                                                labelText:
                                                    "Input Time" //label text of field
                                                ),
                                            readOnly:
                                                true, //set it true, so that user will not able to edit text
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                              );

                                              if (pickedTime != null) {
                                                print(pickedTime.format(
                                                    context)); //output 10:51 PM
                                                DateTime parsedTime =
                                                    DateFormat.jm().parse(
                                                        pickedTime
                                                            .format(context)
                                                            .toString());
                                                //converting to DateTime so that we can further format on different pattern.
                                                print(
                                                    parsedTime); //output 1970-01-01 22:53:00.000
                                                String formattedTime =
                                                    DateFormat('HH:mm:ss')
                                                        .format(parsedTime);
                                                print(
                                                    formattedTime); //output 14:59:00
                                                //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                setState(() {
                                                  timeinput.text =
                                                      formattedTime; //set the value of text field.
                                                });
                                              } else {
                                                print("Time is not selected");
                                              }
                                            },
                                          )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 13, left: 10, right: 20),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            controller:
                                                oranginput, //editing controller of this TextField
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ], // Only numbers can be entered
                                            decoration: const InputDecoration(
                                                icon: Icon(Icons
                                                    .people), //icon of text field
                                                labelText:
                                                    "How Many People" //label text of field
                                                ),
                                            readOnly:
                                                false, //set it true, so that user will not able to edit text
                                          )),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10, left: 20),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Pembayaran ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Container(
                              height: 150,
                              width: MediaQuery.of(Get.context!).size.width,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.white70,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 7,
                                      spreadRadius: 5,
                                      offset: Offset(0, 2),
                                    )
                                  ]),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  RadioListTile(
                                    title: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.credit_card,
                                            size: 40.0,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Xtra Savers",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                          // Text("(***459)", style: TextStyle(
                                          //     fontWeight: FontWeight.bold,
                                          //     fontSize: 13
                                          // ),)
                                        ],
                                      ),
                                    ),
                                    value: 1,
                                    groupValue: bayar,
                                    onChanged: (value) {
                                      setState(() {
                                        bayar = value;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: Container(
                                      margin: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.credit_card,
                                            size: 40.0,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Rekening Ponsel.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                          // Text("(***459)", style: TextStyle(
                                          //     fontWeight: FontWeight.bold,
                                          //     fontSize: 13
                                          // ),)
                                        ],
                                      ),
                                    ),
                                    value: 2,
                                    groupValue: bayar,
                                    onChanged: (value) {
                                      setState(() {
                                        bayar = value;
                                      });
                                    },
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [],
                                    ),
                                  ),
                                ],
                              )),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 40),
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(118, 17, 28, 1),
                                  ),
                                  child: const Text('Lanjutkan',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  onPressed: () => {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: Container(
                                              height: 300,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(40),
                                                  //bottom: Radius.circular(30),
                                                ), //BorderRadius.verticalBorderRadius.Only
                                              ),
                                              child: Column(
                                                //mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
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
                                                          icon: const Icon(Icons
                                                              .close_rounded)),
                                                      const Text(
                                                        "Konfirmasi Transaksi Anda?",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      )
                                                    ],
                                                  ),
                                                  const Text(
                                                      "Masukan Pin Octo Mobile Anda"),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  PinCodeTextField(
                                                    // controller: pininput,
                                                    length: 6,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    obscureText: true,
                                                    obscuringCharacter: '⚫',
                                                    validator: (v) {
                                                      if (v!.length == 6) {
                                                        return "";
                                                      } else {
                                                        return "Silahkan Inputkan Pin";
                                                      }
                                                    },
                                                    appContext: context,
                                                    onChanged:
                                                        (String value) {},
                                                    onCompleted: (value) {
                                                      if (value == "124424") {
                                                        addTransaksiRecord(
                                                            eachClothItemData
                                                                .cart_id!
                                                                .toString(),
                                                            total,
                                                            saldoNasabah,
                                                            saldo);
                                                        // Navigator.push(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //       builder:
                                                        //           (context) =>
                                                        //               Tiket()),
                                                        // );
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "PIN Anda Salah");
                                                      }
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                ],
                                              ),
                                            ));
                                      },
                                    )
                                  },
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                }),
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
