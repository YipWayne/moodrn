import 'package:flutter/material.dart';
import 'package:moodrn/db_helper.dart';
import 'package:moodrn/drop_down.dart';

import 'package:moodrn/line_graph.dart';
import 'package:moodrn/pie_graph.dart';

import '../global.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {

  int currMonth = DateTime.now().month;
  Map<List<int>, int> lineData = {};
  
  bool done = false;

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
  String dropdownValue = 'July';

  Future<void> getAllEntries() async {
    await DBHelper.getAllData()
    .then((value) {
      for (var entry in value) {
        final date = entry['date'];
        final month = int.parse(date.substring(5, 7));
        final day = int.parse(date.substring(8));
        final mood = entry['mood_name'];
        lineData[[month, day]] = moods.indexOf(mood) + 1;
      }
      done = true;
    });
  }

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) async {
        await getAllEntries();
        setState(() {});
    });  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return done ? Container(
      padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: DropdownButton<String>(
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
                  currMonth = months.indexOf(value!) + 1;
                  dropdownValue = value;
                });
              },
               items: months.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ),
          const SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 1,
            child: Column(
              children: [
                const Text(
                  'Mood Flow',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(12)) 
                  ),
                  child: LineGraph(
                    month: currMonth, 
                    data: lineData
                  )
                ),
              ],
            )
          ),
          const SizedBox(height: 40),
          FractionallySizedBox(
            widthFactor: 1,
            child: Column(
              children: [
                const Text(
                  'Mood Chart',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(12)) 
                  ),
                  child: PieGraph(
                    month: currMonth,
                    data: lineData
                  )
                ),
              ],
            )
          ),
        ],
      )
    ) :
    const Center(
      child: CircularProgressIndicator()
    );
  }
}