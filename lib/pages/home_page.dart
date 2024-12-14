import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodgpt/pages/analyze_page.dart';
import 'package:foodgpt/pages/food_tile.dart';
import 'package:foodgpt/pages/settings_dialog.dart';

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
    ['Tea', Icons.bakery_dining],
    ['Bakery', Icons.emoji_food_beverage],
    ['Drinking Chocolate', Icons.coffee],
    ['Flavours', Icons.water_drop],
    ['Coffee Beans', Icons.coffee],
    ['Loose Tea', Icons.emoji_food_beverage],
  ];
  final List foodList = [
    ["Coffee 1", false, 'Coffee'],
    ["Bakery 1", false, 'Bakery'],
    ["Tea 1", false, 'Tea'],
    ["Coffee 1", false, 'Coffee'],
    ["Bakery 1", false, 'Bakery'],
    ["Tea 1", false, 'Tea'],
    ["Coffee 1", false, 'Coffee'],
    ["Bakery 1", false, 'Bakery'],
    ["Tea 1", false, 'Tea'],
    ["Coffee 1", false, 'Coffee'],
    ["Bakery 1", false, 'Bakery'],
    ["Tea 1", false, 'Tea'],
    ["Coffee 1", false, 'Coffee'],
    ["Bakery 1", false, 'Bakery'],
    ["Tea 1", false, 'Tea']
  ];
  final List finalFoodList = [];
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  double confidenceValue = 0.8;
  double liftValue = 0.9;
  double supportValue = 0.7;
  String selectedValueFromDialog='Confidence';
  void determineIcon() {
    IconData _category = Icons.coffee;
    for (int i = 0; i < foodList.length - 1; i++) {
      for (int j = 0; j < map1.length; j++) {
        if (map1[j][0] == foodList[i][2]) {
          _category = map1[j][1];
          break;
        }
      }
      finalFoodList.add([foodList[i][0], false, _category]);
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
              selectedValueFromDialog = value;// Update the selected value
            });
            saveParameters();
          },
        );
      },
    );
  }
  void saveParameters() {
    if(selectedValueFromDialog=='Confidence') {
      confidenceValue = double.tryParse(_controller1.text)!;
      liftValue = 0.9;
      supportValue = 0.7;
      _controller2.text=liftValue.toString();
      _controller3.text=supportValue.toString();
    } else if(selectedValueFromDialog=='Lift'){
      confidenceValue = 0.8;
      liftValue = double.tryParse(_controller2.text)!;
      supportValue = 0.7;
      _controller1.text=confidenceValue.toString();
      _controller3.text=supportValue.toString();
    } else {
      confidenceValue = 0.8;
      liftValue = 0.9;
      supportValue = double.tryParse(_controller3.text)!;
      _controller1.text=confidenceValue.toString();
      _controller2.text=liftValue.toString();
    }
    Navigator.of(context).pop();
  }

  void dismissChanges() {
    _controller1.text = confidenceValue.toString();
    _controller2.text = liftValue.toString();
    _controller3.text = supportValue.toString();
    Navigator.of(context).pop();
  }

  ListView? _builder() {
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
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_circle_right_sharp, size: 36),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnalyzePage(
                              antecedentsList: finalFoodList,
                              confidenceValue: confidenceValue,
                              supportValue: supportValue,
                              liftValue: liftValue))),
                },
              )),
          Positioned(
              left: 46,
              bottom: 16,
              child: FloatingActionButton(
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
