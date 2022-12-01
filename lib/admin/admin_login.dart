import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/admin/admin_upload_item.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/authentication/signup_screen.dart';
import 'package:flutter_ecommerce/users/fragments/dashboard_of_fragments.dart';
import 'package:flutter_ecommerce/users/model/user.dart';
import 'package:flutter_ecommerce/users/userPrefrences/user_prefrences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../users/authentication/login_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;
  loginAdminNow() async {
    try {
      var res = await http.post(Uri.parse(API.adminlogin), body: {
        "admin_email": emailController.text.trim(),
        "admin_password": passwordController.text.trim()
      });

      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(msg: "Login Successfully");

          Future.delayed(const Duration(milliseconds: 2000), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminUploadItemsScreen()),
            );
          });
        } else {
          Fluttertoast.showToast(
              msg:
                  "Incorrect Credentials.\nPlease write correct password or email, Try Again");
        }
      }
    } catch (e) {
      print("Error : " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: cons.maxHeight),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Login screen header
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 285,
                  child: Image.asset("images/admin.jpg"),
                ),
                // Login Screen Sign-in Form
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                    child: Column(
                      children: [
                        // Email-password-login btn
                        Form(
                            key: formKey,
                            child: Column(
                              children: [
                                // Email
                                TextFormField(
                                  controller: emailController,
                                  validator: (val) =>
                                      val == "" ? "Please Write Email" : null,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Color.fromARGB(255, 107, 103, 103),
                                    ),
                                    hintText: "Please Wirte Your Email",
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                // Password
                                TextFormField(
                                  obscureText: true,
                                  controller: passwordController,
                                  validator: (val) => val == ""
                                      ? "Please Write Password"
                                      : null,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.vpn_key_off_sharp,
                                      color: Color.fromARGB(255, 107, 103, 103),
                                    ),
                                    hintText: "Please Wirte Your Password",
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                // Button Login
                                Material(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        loginAdminNow();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 28),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 18,
                        ),
                        //  Register Here btn
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),

                        // I Am not an admin button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("I Am not an Admin  "),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                              child: const Text("Click Here"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
