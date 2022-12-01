import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/admin/admin_login.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/authentication/signup_screen.dart';
import 'package:flutter_ecommerce/users/fragments/dashboard_of_fragments.dart';
import 'package:flutter_ecommerce/users/model/user.dart';
import 'package:flutter_ecommerce/users/userPrefrences/user_prefrences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;
  loginUserNow() async {
    try {
      var res = await http.post(Uri.parse(API.login), body: {
        "user_email": emailController.text.trim(),
        "user_password": passwordController.text.trim()
      });

      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(msg: "Login Successfully");
          // Mengambil data data login dari database
          User userInfo = User.fromJson(resBodyOfLogin['userData']);
          // save userinfo to local storage using shared prefrences
          await RememberUserPrefs.saveRememberUser(userInfo);
          print(userInfo);

          Future.delayed(Duration(milliseconds: 2000), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardOfFragments()),
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
      // appBar: AppBar(
      //   backgroundColor: Color.fromRGBO(132, 0, 0, 1),
      //   elevation: 0.0,
      //   title: Text(
      //     'Login',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       decoration: TextDecoration.underline,
      //     ),
      //   ),
      //   centerTitle: true,

      //   // actions: [
      //   //   IconButton(onPressed: (){}, icon: Icon(Icons.lightbulb_rounded))
      //   // ],
      // ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: cons.maxHeight),
          child: SingleChildScrollView(
              child: Container(
            color: Color.fromRGBO(132, 0, 0, 1),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 18),
                  ),
                ),
                // Login screen header
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: 285,
                //   child: Image.asset("images/login.jpg"),
                // ),
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
                                  style: const TextStyle(color: Colors.white),
                                  validator: (val) =>
                                      val == "" ? "Please Write Email" : null,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    hintText: "Please Write Your Email",
                                    hintStyle: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                // Password
                                TextFormField(
                                  obscureText: true,
                                  controller: passwordController,
                                  style: const TextStyle(color: Colors.white),
                                  validator: (val) => val == ""
                                      ? "Please Write Password"
                                      : null,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.vpn_key_off_sharp,
                                      color: Colors.white,
                                    ),
                                    hintText: "Please Write Your Password",
                                    hintStyle: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Text(
                                    "I have an account but no user ID",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                                // Button Login
                                Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        loginUserNow();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 120),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                //  Register Here btn
                                Container(
                                  margin: EdgeInsets.only(top: 25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "I Don't have any Account",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignupScreen()),
                                          );
                                        },
                                        child: const Text(
                                          "Open an account now",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10),
                                          child: Image.asset(
                                            'images/haku.jpeg',
                                            height: 200,
                                            width: 200,
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
        );
      }),
    );
  }
}
