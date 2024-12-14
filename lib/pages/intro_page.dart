import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodgpt/pages/button_intro.dart';
import 'package:lottie/lottie.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding:EdgeInsets.only(top:130),child:Lottie.asset(width:MediaQuery.sizeOf(context).width,repeat:true,'assets/lottie/splash_screen.json')),
          Text("Welcome To FoodGPT!",style:TextStyle(fontSize: 28,color:Colors.black)),
          const Spacer(),
          ButtonIntro(),
          const Spacer(),
        ],
      ),
      backgroundColor: Colors.green[400],
    );
  }
}
