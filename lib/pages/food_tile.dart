import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodTile extends StatefulWidget {

  final String foodName;
  final bool foodSelected;
  final IconData iconName;
  Function(bool?)? onSelected;
  FoodTile({
    super.key,
    required this.foodName,
    required this.foodSelected,
    required this.onSelected,
    required this.iconName,
  });

  @override
  State<FoodTile> createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
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
            Icon(widget.iconName),
            const Spacer(),
            Text(
              widget.foodName
            ),
            const Spacer(),
            Checkbox(
                value: widget.foodSelected,
                onChanged: widget.onSelected
            ),
          ],
        ),
      );
  }
}
