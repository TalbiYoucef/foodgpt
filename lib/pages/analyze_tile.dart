import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalyzeTile extends StatefulWidget {
  final String foodNames;
  final String confidenceValue;
  final String supportValue;
  final String liftValue;
  const AnalyzeTile({
    super.key,
    required this.foodNames,
    required this.confidenceValue,
    required this.supportValue,
    required this.liftValue,
  });
  @override
  State<AnalyzeTile> createState() => _AnalyzeTileState();
}

class _AnalyzeTileState extends State<AnalyzeTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green[400],  // Vibrant yellow background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
              widget.foodNames,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
              )
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailContainer(
                  'Confidence',
                  widget.confidenceValue,
                  Colors.black,
                  Colors.white
              ),
              _buildDetailContainer(
                  'Support',
                  widget.supportValue,
                  Colors.black,
                  Colors.white
              ),
              _buildDetailContainer(
                  'Lift',
                  widget.liftValue,
                  Colors.black,
                  Colors.white
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContainer(String label, String value, Color bgColor, Color textColor) {
    return Container(
      height: 50,
      width: 110,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500
              )
          ),
          Text(
              value,
              style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.w600
              )
          ),
        ],
      ),
    );
  }
}