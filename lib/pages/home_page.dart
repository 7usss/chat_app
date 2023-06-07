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

  CollectionReference collection = FirebaseFirestore.instance.collection('messages');
  @override
  void dispose() {
    cr.dispose();
    super.dispose();
  }

  Onsubmet() {
    collection.add({'message': cr.text, 'time': DateTime.now()});
    cr.clear();
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
                    Navigator.pushReplacementNamed(context, 'RegisterPage');
                  },
                  icon: const Icon(Icons.logout))
            ]),
        body: StreamBuilder<QuerySnapshot>(
          stream: collection.orderBy('time', descending: false).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data!.docs.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ChatPuble(
                            message: snapshot.data!.docs[index]['message'],
                          );
                        }),
                  ),
                  TextField(
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
                  ),
                ],
              );
            } else {
              return const Text('data');
            }
          },
        ));
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
          color: Ksecondcolor,
        ),
        child: CustomText(test: message),
      ),
    );
  }
}
