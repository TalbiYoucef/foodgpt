import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalyzeTile extends StatefulWidget {
  final String foodNames;
  const AnalyzeTile({
    super.key,
    required this.foodNames,
  });

  @override
  State<AnalyzeTile> createState() => _AnalyzeTileState();
}

class _AnalyzeTileState extends State<AnalyzeTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius:BorderRadius.circular(12)
      ),
      child:Row(
        children: [
          Text(
              widget.foodNames
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
