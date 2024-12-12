import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalyzeButton extends StatelessWidget {
  const AnalyzeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.yellow,
      child:Icon(Icons.arrow_circle_right,
      size:36),
      onPressed: ()=> {
        Navigator.pushNamed(context,'/analyzepage'),
      },
    );
  }
}
