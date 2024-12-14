import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogBox extends StatefulWidget {
  final controllerConfidence;
  final controllerLift;
  final controllerSupport;
  final ValueSetter<String> onSelectedValue;
  VoidCallback onCancel;
  DialogBox({
    super.key,
    required this.controllerConfidence,
    required this.controllerLift,
    required this.controllerSupport,
    required this.onCancel,
    required this.onSelectedValue,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  late String selectedValue='Confidence';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 400,
        height: 300,
        child: Column(
          children: [
            Text("Select Value Type:"),
            Expanded(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text("Confidence Value"),
                    value: "Confidence",
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text("Lift Value"),
                    value: "Lift",
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text("Support Value"),
                    value: "Support",
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48),
            TextField(
              controller: selectedValue == "Confidence"
                  ? widget.controllerConfidence
                  : selectedValue == "Lift"
                  ? widget.controllerLift
                  : widget.controllerSupport,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "New Value ...",
              ),
            ),
            const SizedBox(width: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  child: Text("Save"),
                  onPressed:()=>{widget.onSelectedValue(selectedValue)},
                  color: Colors.green[400],
                ),
                const SizedBox(width: 64),
                MaterialButton(
                  child: Text("Cancel"),
                  onPressed: widget.onCancel,
                  color: Colors.green[400],
                ),
                const SizedBox(width: 28),
              ],
            )
          ],
        ),
      ),
    );
  }
}
