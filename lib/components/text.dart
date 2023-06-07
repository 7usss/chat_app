import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({required this.test, super.key});
  final String test;

  @override
  Widget build(BuildContext context) {
    return Text(
      test,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
    );
  }
}
