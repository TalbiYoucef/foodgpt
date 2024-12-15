import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodgpt/pages/analyze_page.dart';
import 'package:foodgpt/pages/food_tile.dart';
import 'package:foodgpt/pages/settings_dialog.dart';
import 'package:http/http.dart' as http;

class product {
  final String category;
  final String name;
  final int id;

  product({required this.category, required this.name,required this.id});

  // Convert a map into a product object
  factory product.fromJson(Map<String, dynamic> json) {
    return product(
      id:json['id'],
      category: json['category'],
      name: json['type'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}
// TODO: integrate with FastAPI

class _HomePageState extends State<HomePage> {
  List map1 = [
    ['Coffee', Icons.coffee],
    ['Tea', Icons.emoji_food_beverage],
    ['Bakery', Icons.bakery_dining],
    ['Drinking Chocolate', Icons.coffee],
    ['Flavours', Icons.water_drop],
    ['Coffee Beans', Icons.coffee],
    ['Loose Tea', Icons.emoji_food_beverage],
  ];

  Future<List<product>> fetchProducts() async {
    // Replace with your API URL
    final response = await http
        .get(Uri.parse('http://d0d5-154-121-46-88.ngrok-free.app/products'));

    if (response.statusCode == 200) {
      // Decode the response body into a list of JSON objects
      Map<String, dynamic> data = json.decode(response.body);
      print(data['products']);
      List<dynamic> productsJson = data['products'];

      // Map each item in the list to a product instance
      List<product> products = productsJson
          .map((json) => product.fromJson(json as Map<String, dynamic>))
          .toList();
      return products;
    } else {
      throw Exception('Failed to load users');
    }
  }

  late Future<List<product>> futureProducts;
  final List finalFoodList = [];
  List<String> antecedentsList=[];
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  double confidenceValue = 0.8;
  double liftValue = 0.9;
  double supportValue = 0.7;
  String selectedValueFromDialog = 'Confidence';

  void determineIcon() async {
    // Initialize the icon with a default icon
    IconData _category = Icons.coffee;
    futureProducts=fetchProducts();
    // Ensure that futureProducts is loaded before processing
    List<product> products = await futureProducts;
    antecedentsList=[];
    // Iterate through the products once the data is loaded
    for (int i = 0; i < products.length; i++) {
      for (int j = 0; j < map1.length; j++) {
        // Match category from futureProducts to map1 to get the icon
        if (map1[j][0] == products[i].category) {
          _category = map1[j][1]; // Set the icon based on the category
          break; // Exit the inner loop once the correct icon is found
        }
      }

      // Add the food item with its name, selected state, and category icon
      finalFoodList.add([products[i].name, false, _category]);
    }
    for(int i=0;i<products.length;i++) {
      if(finalFoodList[i][1]) {
        antecedentsList.add(finalFoodList[i][0]);
      }
    }
  }

  void checkBoxChanged(bool? state, int index) {
    setState(() {
      finalFoodList[index][1] = !finalFoodList[index][1];
    });
  }

  void modifyParameters() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controllerConfidence: _controller1,
          controllerLift: _controller2,
          controllerSupport: _controller3,
          onCancel: dismissChanges,
          onSelectedValue: (value) {
            setState(() {
              selectedValueFromDialog = value; // Update the selected value
            });
            saveParameters();
          },
        );
      },
    );
  }

  void saveParameters() {
    if (selectedValueFromDialog == 'Confidence') {
      confidenceValue = double.tryParse(_controller1.text)!;
      liftValue = 0.9;
      supportValue = 0.7;
      _controller2.text = liftValue.toString();
      _controller3.text = supportValue.toString();
    } else if (selectedValueFromDialog == 'Lift') {
      confidenceValue = 0.8;
      liftValue = double.tryParse(_controller2.text)!;
      supportValue = 0.7;
      _controller1.text = confidenceValue.toString();
      _controller3.text = supportValue.toString();
    } else {
      confidenceValue = 0.8;
      liftValue = 0.9;
      supportValue = double.tryParse(_controller3.text)!;
      _controller1.text = confidenceValue.toString();
      _controller2.text = liftValue.toString();
    }
    Navigator.of(context).pop();
  }

  void dismissChanges() {
    _controller1.text = confidenceValue.toString();
    _controller2.text = liftValue.toString();
    _controller3.text = supportValue.toString();
    Navigator.of(context).pop();
  }

  FutureBuilder _builder() {
    return FutureBuilder<List<product>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: finalFoodList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: FoodTile(
                  foodName: finalFoodList[index][0],
                  foodSelected: finalFoodList[index][1],
                  onSelected: (value) => checkBoxChanged(value, index),
                  iconName: finalFoodList[index][2],
                ),
              );
            },
            padding: EdgeInsets.only(bottom: 100),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
  List<String> determineAntecedents() {
        antecedentsList=[];
        for(int i=0;i<finalFoodList.length;i++){
          if(finalFoodList[i][1]) {
            antecedentsList.add("${finalFoodList[i][0]}");
          }
        }
        return antecedentsList;
  }
  @override
  void initState() {
    super.initState();
    determineIcon();
    _controller1.text = confidenceValue.toString();
    _controller2.text = liftValue.toString();
    _controller3.text = supportValue.toString();

    // Populate the finalFoodList when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: null,
        title: Text("FoodGPT"),
      ),
      body: _builder(),
      floatingActionButton: Stack(
        children: [
          Positioned(
              right: 10,
              bottom: 16,
              child: FloatingActionButton(
                heroTag: 'analyzePageFAB',
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_circle_right_sharp, size: 36),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnalyzePage(
                              antecedentsList: determineAntecedents(),
                              confidenceValue: confidenceValue != 0.8 ? confidenceValue: 0.8,
                              supportValue: supportValue != 0.7 ? supportValue: 0.7,
                              liftValue: liftValue!= 0.9 ? liftValue: 0.9))),
                },
              )),
          Positioned(
              left: 46,
              bottom: 16,
              child: FloatingActionButton(
                heroTag: 'settingsFAB',
                backgroundColor: Colors.white,
                child: Icon(Icons.settings_sharp, size: 36),
                onPressed: () => {
                  (modifyParameters()),
                },
              ))
        ],
      ),
    );
  }
}
