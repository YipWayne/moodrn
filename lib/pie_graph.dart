import 'package:flutter/material.dart';

import 'package:pie_chart/pie_chart.dart';

import 'global.dart';

class PieGraph extends StatefulWidget {
  final int month;
  final Map<List<int>, int> data;
  const PieGraph({
    required this.month,
    required this.data,
    super.key
  });

  @override
  State<PieGraph> createState() => _PieGraphState();
}

class _PieGraphState extends State<PieGraph> {

  Map<String, double> dataMap = {
    'Very Sad': 0,
    'Sad': 0,
    'Neutral': 0,
    'Happy': 0,
    'Very Happy': 0
  };


  @override
  Widget build(BuildContext context) {
    dataMap.updateAll((name, value) => value = 0); 
    for (var entry in widget.data.keys) {
      if (entry[0] == widget.month) {
        final key = moods[widget.data[entry]! - 1];
        dataMap.update(
          key, 
          (value) => ++value,
          ifAbsent: () => 1
        );
      } 
    }
    return PieChart(
      colorList: [
        Colors.lightBlue.shade900,
        Colors.lightBlue.shade700,
        Colors.lightBlue,
        Colors.lightBlue.shade200,
        Colors.lightBlue.shade100
      ],
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
      animationDuration: const Duration(milliseconds: 0),
      dataMap: dataMap
    );
  }
}