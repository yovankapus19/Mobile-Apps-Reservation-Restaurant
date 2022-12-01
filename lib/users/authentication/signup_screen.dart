import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/api_connection/api_connection.dart';
import 'package:flutter_ecommerce/users/authentication/login_screen.dart';
import 'package:flutter_ecommerce/users/model/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;
  validateUserEmail() async {
    try {
      var res = await http.post(
        Uri.parse(API.checkEmail),
        body: {
          'user_email': emailController.text.trim(),
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfValidateEmail = jsonDecode(res.body);
        if (resBodyOfValidateEmail['emailFound'] == true) {
          Fluttertoast.showToast(
              msg: "Email is already in someone else use. Try another email");
        } else {
          // register & save new user record to database
          registerAndUserRecord();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  registerAndUserRecord() async {
    // User userModel = User(1, nameController.text.trim(),
    //     emailController.text.trim(), passwordController.text.trim());
    User userModel = User(
      1,
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    try {
      var res = await http.post(
        Uri.parse(API.signUpNew),
        body: userModel.toJson(),
      );
      if (res.statusCode == 200) {
        var resBodyOfSignUp = jsonDecode(res.body);
        if (resBodyOfSignUp['success'] == true) {
          // Fluttertoast.showToast(msg: "Congratulations, SignUp Successfully");
          // setState(() {
          //   emailController.clear();
          //   nameController.clear();
          //   passwordController.clear();
          // });
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          Fluttertoast.showToast(msg: "Error Occurred, Try Again");
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color.fromRGBO(132, 0, 0, 1),
      //   elevation: 0.0,
      //   title: Text(
      //     'SignUp',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       decoration: TextDecoration.underline,
      //     ),
      //   ),
      //   centerTitle: true,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const LoginScreen()),
      //         );
      //       },
      //       icon: Icon(Icons.arrow_back_ios)),
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
                    'Register',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 18),
                  ),
                ),
                // Signup screen header
                // Signup Screen Sign-up Form
                Container(
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                    child: Column(
                      children: [
                        // Email-password-login btn
                        Form(
                            key: formKey,
                            child: Column(
                              children: [
                                // Name
                                TextFormField(
                                  controller: nameController,
                                  style: const TextStyle(color: Colors.white),
                                  validator: (val) =>
                                      val == "" ? "Please Write Name" : null,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    hintText: "Please Write Your Name",
                                    hintStyle: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
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
                                // Button Login
                                Container(
                                    margin: EdgeInsets.only(top: 30),
                                    child: Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            // Validasi Email
                                            validateUserEmail();
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 120),
                                          child: Text(
                                            "SignUp",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            )),
                        const SizedBox(
                          height: 18,
                        ),
                        //  Login Already Account  btn
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an Account ? ",
                              style: TextStyle(color: Colors.white),
                            ),
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
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                right:
                                    MediaQuery.of(context).size.width * 0.10),
                            child: Image.asset(
                              'images/haku.jpeg',
                              height: 200,
                              width: 200,
                            ))
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
