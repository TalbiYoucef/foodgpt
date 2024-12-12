
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodgpt/pages/button_analyze.dart';
import 'package:foodgpt/pages/food_tile.dart';
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}
// TODO: fix drawer
// TODO: integrate with FastAPI
// TODO: make an animation transition from Home Screen to Analytics page
// TODO: make a getStarted On home page
class _HomePageState extends State<HomePage> {

  List map1=[['Coffee',Icons.coffee],['Tea',Icons.bakery_dining],['Bakery',Icons.emoji_food_beverage],['Drinking Chocolate',Icons.coffee],['Flavours',Icons.water_drop],['Coffee Beans',Icons.coffee],['Loose Tea',Icons.emoji_food_beverage],];
  final List foodList=[["Coffee 1",false,'Coffee'],["Bakery 1",false,'Bakery'],["Tea 1",false,'Tea']];
  final List finalFoodList=[];
  void determineIcon() {
    for (int i=0;i<foodList.length;i++){
      finalFoodList.add(['',false,Icons.coffee]);
      for(int j=0;j<map1.length;j++){
        if(map1[j][0]==foodList[i][2]){
          finalFoodList[i][2]=map1[i][1];
          break;
        }
      }
      finalFoodList[i][0]=foodList[i][0];
      finalFoodList[i][1]=false;
    }
  }
  void checkBoxChanged(bool? state, int index) {
    setState(() {
      finalFoodList[index][1] = !finalFoodList[index][1];
    });
  }
  @override
  void initState() {
    super.initState();
    determineIcon(); // Populate the finalFoodList when the widget is initialized
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=> {}, icon: Icon(Icons.menu)),
        title: Text("FoodGPT"),
      ),
      body: ListView.builder(
        itemCount: finalFoodList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left:15,right:15,top:15),
            child: FoodTile(
              foodName: finalFoodList[index][ 0],
              foodSelected: finalFoodList[index][1],
              onSelected: (value) => checkBoxChanged(value, index),
              iconName: finalFoodList[index][2],
            ),
          );
        },
      ),
      floatingActionButton: AnalyzeButton(),
    );
    determineIcon();
  }
}
