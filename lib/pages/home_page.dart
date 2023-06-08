import 'package:chat_app/components/text.dart';
import 'package:chat_app/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cr = TextEditingController();
  final scrollcontroler = ScrollController();

  CollectionReference collection = FirebaseFirestore.instance.collection('messages');
  String email(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return email;
  }

  @override
  void dispose() {
    cr.dispose();
    super.dispose();
  }

  Onsubmet() {
    collection.add({'message': cr.text, 'time': DateTime.now(), 'id': email(context)});
    cr.clear();
    scrollcontroler.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 59, 59, 59),
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'My chat',
              style: TextStyle(color: Colors.white, fontFamily: 'BreeSerif', fontSize: 18),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Kmaincolor,
            actions: [
              IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, 'LoginPage');
                  },
                  icon: const Icon(Icons.logout))
            ]),
        body: StreamBuilder<QuerySnapshot>(
          stream: collection.orderBy('time', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return Column(
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    const Text(
                      'Start Chating ',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    textfield(),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          controller: scrollcontroler,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return email(context) == snapshot.data!.docs[index]['id']
                                ? ChatPuble(
                                    message: snapshot.data!.docs[index]['message'],
                                  )
                                : ChatPuble2(
                                    message: snapshot.data!.docs[index]['message'],
                                  );
                          }),
                    ),
                    textfield(),
                  ],
                );
              }
            }
          },
        ));
  }

  TextField textfield() {
    return TextField(
      controller: cr,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: () {
            Onsubmet();
          },
          child: const Icon(
            Icons.send,
          ),
        ),
        hintText: 'Send Message',
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Kmaincolor, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}

class ChatPuble extends StatelessWidget {
  final String message;

  const ChatPuble({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24), bottomRight: Radius.circular(24)),
          color: Kchatcolor,
        ),
        child: CustomText(test: message),
      ),
    );
  }
}

class ChatPuble2 extends StatelessWidget {
  final String message;

  const ChatPuble2({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24), bottomLeft: Radius.circular(24)),
          color: Kchatcolor2,
        ),
        child: CustomText(test: message),
      ),
    );
  }
}
