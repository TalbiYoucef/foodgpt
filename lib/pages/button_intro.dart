import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonIntro extends StatelessWidget {
  const ButtonIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: ()=>{Navigator.pushNamed(context, '/homepage')}, style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    ),child:const Text(
    'Get Started',
    style: TextStyle(
    fontSize: 18,
    color: Colors.black,
    )),);
  }
}
