import 'dart:ui';

import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/components/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final double _sigmaX = 5;
  // from 0-10
  final double _sigmaY = 5;
  // from 0-10
  final double _opacity = 0.2;

  final double _width = 350;

  final double _height = 300;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // sign user in method
  void signUserIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final String loginEmail = emailController.text;
      final String loginPassword = passwordController.text;
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: loginEmail, password: loginPassword)
            .then((value) {
          FirebaseFirestore.instance.collection('UserData').doc(value.user!.uid).set({
            'id': value.user!.uid,
            'Email': value.user!.email,
          });
        });
        ShowSnackBar().showSnakbar(context, 'Succes');
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, 'LoginPage');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ShowSnackBar().showSnakbar(context, 'Weak password');
        } else if (e.code == 'email-already-in-use') {
          ShowSnackBar().showSnakbar(context, 'Already in use');
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
    passwordController.dispose();
    emailController.dispose();
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                    ////////////////////////////
                    const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    ////////////////////////////
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ////////////////////////////
                    ClipRrectWidgt(
                        sigmaX: _sigmaX,
                        sigmaY: _sigmaY,
                        onPressed12: signUserIn,
                        opacity: _opacity,
                        formKey: _formKey,
                        usernameController: emailController,
                        passwordController: passwordController),
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

class ClipRrectWidgt extends StatelessWidget {
  const ClipRrectWidgt({
    super.key,
    required double sigmaX,
    required double sigmaY,
    required this.onPressed12,
    required double opacity,
    required GlobalKey<FormState> formKey,
    required this.usernameController,
    required this.passwordController,
  })  : _sigmaX = sigmaX,
        _sigmaY = sigmaY,
        _opacity = opacity,
        _formKey = formKey;

  final double _sigmaX;
  final double _sigmaY;
  final double _opacity;
  final GlobalKey<FormState> _formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final void Function(BuildContext) onPressed12;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 1).withOpacity(_opacity),
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.64,
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Look like you don't have an account. Let's create a new account for",
                      // ignore: prefer_const_constructors
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.start),
                  // ignore: prefer_const_constructors
                  const Text(
                    "jane.doe@gmail.com",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 30),

                  MyTextField(
                    controller: usernameController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),
                  MyPasswordTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: '',
                          children: <TextSpan>[
                            TextSpan(
                              text: 'By selecting Agree & Continue below, I agree to our ',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            TextSpan(
                                text: 'Terms of Service and Privacy Policy',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 71, 233, 133),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      MyButtonAgree(
                          text: "Agree and Continue",
                          onTap: () {
                            onPressed12(context);
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text('have account? Log in here',
                            style: TextStyle(
                                color: Color.fromARGB(255, 71, 233, 133), fontWeight: FontWeight.bold, fontSize: 20)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
