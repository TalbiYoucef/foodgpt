import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodgpt/pages/analyze_tile.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class rules {
  final List<String> consequents;
  final List<String> antecedents;
  final double support;
  final double confidence;
  final double lift;

  rules(
      {required this.consequents,
      required this.antecedents,
      required this.support,
      required this.confidence,
      required this.lift});

  // Convert a map into a product object
  factory rules.fromJson(Map<String, dynamic> json) {
    return rules(
      consequents: List<String>.from(json['consequents'] ?? []),
      // Ensure we handle the list correctly
      antecedents: List<String>.from(json['antecedents'] ?? []),
      // Ensure we handle the list correctly
      support: json['support'] ?? 0.0,
      confidence: json['confidence'] ?? 0.0,
      lift: json['lift'] ?? 0.0,
    );
  }
}

class AnalyzePage extends StatefulWidget {
  final List<String> antecedentsList;
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
  late List<rules> rulesList;

  String selectedMetric = '';
  double threshold = 0;
  bool isLoading = true; // Start with the loading state
  void determineMetric() {
    if (widget.confidenceValue != 0.8) {
      selectedMetric = 'confidence';
      threshold = widget.confidenceValue;
    } else if (widget.supportValue != 0.7) {
      selectedMetric = 'support';
      threshold = widget.supportValue;
    } else if (widget.liftValue != 0.9) {
      selectedMetric = 'lift';
      threshold = widget.liftValue;
    } else {
      selectedMetric = 'confidence';
      threshold = widget.confidenceValue;
    }
  }

  Future<List<rules>> fetchRules() async {
    Map<String, dynamic> payload = {
      "products": widget.antecedentsList,
      "metric": selectedMetric,
      "threshold": "$threshold",
    };

    print('Payload: $payload');
    print(json.encode(payload));

    try {
      final response = await http
          .post(
            Uri.parse('https://d0d5-154-121-46-88.ngrok-free.app/rules'),
            // Ensure this is the correct endpoint
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(payload),
          )
          .timeout(Duration(seconds: 10)); // Timeout after 10 seconds

      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('rules') && data['rules'] is List) {
          List<dynamic> rulesJson = data['rules'];
          return rulesJson
              .map((json) => rules.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Invalid response format: ${data}');
        }
      } else {
        throw Exception(
            'API returned status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error fetching rules: $e');
      return Future.error('Failed to fetch rules: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    rulesList=[];
    // Call the initialization logic in a separate method
    initializeData();
  }

// New method to handle async operations
  Future<void> initializeData() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      determineMetric(); // Determine the metric
      rulesList=await fetchRules(); // Fetch rules asynchronously
    } catch (e) {
      print('Error initializing data: $e');
      // Handle errors if necessary, e.g., show an alert or a snackbar
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
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
          initialChildSize: 0.5,
          // Initial size of the sheet
          minChildSize: 0.25,
          // Minimum size when dragged down
          maxChildSize: 0.9,
          // Maximum size when expanded
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
                      itemCount: widget.antecedentsList.length,
                      // Example number of items
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${widget.antecedentsList[index]}'),
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
                  Navigator.pushNamed(context, '/homepage'),
                },
            icon: Icon(Icons.arrow_back)),
        title: Text("Generated Rules Page"),
      ),
      body: isLoading
          ? Center(
              child: Column(children: [
              Lottie.asset('assets/lottie/loading_animation.json'),
              Text(
                "Please wait, Loading ...",
                style: TextStyle(color: Colors.black, fontSize: 24),
              )
            ])) // Show loading animation
          : Column(
              children: [
                // Existing rules list
                Expanded(
                  child: ListView.builder(
                    itemCount: rulesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnalyzeTile(
                          foodNames: rulesList[index].consequents.join(', ')+' ---> '+rulesList[index].antecedents.join(', '),
                        confidenceValue: rulesList[index].confidence.toStringAsFixed(2),
                        supportValue: rulesList[index].support.toStringAsFixed(2),
                        liftValue: rulesList[index].lift.toStringAsFixed(2));
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
                    child: Text('Show Selected Products',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
    );
  }
}
