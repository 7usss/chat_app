// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/components/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final passwordController = TextEditingController();

  final emailController = TextEditingController();

  final double _sigmaX = 5;
  // from 0-10
  final double _sigmaY = 5;
  // from 0-10
  final double _opacity = 0.2;

  final double _width = 350;

  final double _height = 300;

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  // sign user in method
  void signUserIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final String loginEmail = emailController.text;
      final String loginPassword = passwordController.text;
      User? user = FirebaseAuth.instance.currentUser;
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: loginEmail, password: loginPassword);
        Navigator.pushNamed(context, 'HomePage');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ShowSnackBar().showSnakbar(context, 'Email not found');
        } else if (e.code == 'wrong-password') {
          ShowSnackBar().showSnakbar(context, 'Wrong password provided for that user');
        }
      }
      setState(() {
        isLoading = false;
      });
    } else {
      print('not valid');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://cdn.discordapp.com/attachments/679377927611351119/1110849982195568671/Rectangle_1.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.26),
                    const Text("Log in",
                        style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 1).withOpacity(_opacity),
                              borderRadius: const BorderRadius.all(Radius.circular(30))),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.52,
                          child: Form(
                            key: _formKey,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: Row(children: [
                                      const CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            'https://cdn.discordapp.com/attachments/679377927611351119/1110849982195568671/Rectangle_1.png'),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Text("Jane Dow",
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 5),
                                        ],
                                      )
                                    ]),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                                  MyTextField(
                                    controller: emailController,
                                    hintText: 'Email',
                                    obscureText: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  MyTextField(
                                    controller: passwordController,
                                    hintText: 'Password',
                                    obscureText: true,
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                                  MyButtonAgree(
                                    text: "Continue",
                                    onTap: () {
                                      signUserIn(context);
                                    },
                                  ),
                                  const SizedBox(height: 30),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, 'RegisterPage');
                                    },
                                    child: const Text('Dont have account? register here',
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 71, 233, 133),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        textAlign: TextAlign.start),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
