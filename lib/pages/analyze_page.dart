import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalyzePage extends StatelessWidget {
  AnalyzePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed:()=>Navigator.pushNamed(context,'/homepage'),
              icon: Icon(Icons.arrow_back)),
          title: Text("Analytics Page"),
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("NIGATIVE ATTITUDE")
              ],
            )
          ],
    ),
    );
  }
}
