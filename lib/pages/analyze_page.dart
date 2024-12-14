import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodgpt/pages/analyze_tile.dart';
import 'package:lottie/lottie.dart';

class AnalyzePage extends StatefulWidget {
  final List antecedentsList;
  final double confidenceValue;
  final double supportValue;
  final double liftValue;

  AnalyzePage({
    super.key,
    required this.antecedentsList,
    required this.confidenceValue,
    required this.supportValue,
    required this.liftValue,
  });

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  final List selectedProducts = [];
  final List rules = [
    ['1+2', '0.9', '0.8', '0.7'],
    ['3+3', '0.9', '0.8', '0.6'],
    ['4+4', '0.9', '0.8', '0.5'],
    ['1+2', '0.9', '0.8', '0.7'],
    ['3+3', '0.9', '0.8', '0.6'],
    ['4+4', '0.9', '0.8', '0.5'],
    ['1+2', '0.9', '0.8', '0.7'],
    ['3+3', '0.9', '0.8', '0.6'],
    ['4+4', '0.9', '0.8', '0.5'],
    ['1+2', '0.9', '0.8', '0.7'],
    ['3+3', '0.9', '0.8', '0.6'],
    ['4+4', '0.9', '0.8', '0.5'],
    ['1+2', '0.9', '0.8', '0.7'],
    ['3+3', '0.9', '0.8', '0.6'],
    ['4+4', '0.9', '0.8', '0.5']
  ];

  bool isLoading = true; // Start with the loading state

  void getNames(List foodList) {
    for (int i = 0; i < foodList.length; i++) {
      if (foodList[i][1]) {
        selectedProducts.add(foodList[i][0]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getNames(widget.antecedentsList);
    // Simulate loading with a delay (for example, 2 seconds)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // After 2 seconds, stop the loading animation
      });
    });
  }

  // Custom method to show a bottom sheet with scrollable content
  void _showScrollableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // This makes the bottom sheet scrollable
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Initial size of the sheet
          minChildSize: 0.25, // Minimum size when dragged down
          maxChildSize: 0.9, // Maximum size when expanded
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle for dragging
                  Container(
                    width: 50,
                    height: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: selectedProducts.length, // Example number of items
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${selectedProducts[index]}'),
                          onTap: () {
                            // Handle item selection
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => {
              Navigator.pushNamed(context,'/homepage'),
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("Generated Rules Page"),
      ),
      body: isLoading
          ? Center(child:Column(children: [Lottie.asset('assets/lottie/loading_animation.json'),Text("Please wait, Loading ...",style: TextStyle(color: Colors.black,fontSize: 24),)])) // Show loading animation
          : Column(
        children: [
          // Existing rules list
          Expanded(
            child: ListView.builder(
              itemCount: rules.length,
              itemBuilder: (BuildContext context, int index) {
                return AnalyzeTile(
                    foodNames: rules[index][0],
                    confidenceValue: rules[index][1],
                    supportValue: rules[index][2],
                    liftValue: rules[index][3]);
              },
            ),
          ),
          Container(
            color: Colors.green[400],
            child: ElevatedButton(
              onPressed: () => _showScrollableBottomSheet(context),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                alignment: Alignment.center,
                backgroundColor: Colors.green[400],
              ),
              child: Text('Show Selected Products', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
