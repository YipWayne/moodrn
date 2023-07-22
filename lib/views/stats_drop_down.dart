import 'package:flutter/material.dart';

class DropdownMnu extends StatefulWidget {
  final int month;
  const DropdownMnu({
    required this.month,
    super.key
    });

  @override
  State<DropdownMnu> createState() => _DropdownMnuState();
}

class _DropdownMnuState extends State<DropdownMnu> {
  List<String> months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July', 
    'August', 
    'September', 
    'October',
    'November',
    'December'
    ];
  String dropdownValue = 'January';

  @override
  void initState() {
    dropdownValue = months[widget.month - 1];
    super.initState();
 
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 1,
      underline: Container(
        height: 2,
        color: Colors.lightBlue,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: months.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}