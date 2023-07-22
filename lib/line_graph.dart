import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class LineGraph extends StatefulWidget {
  final int month;
  final Map<List<int>, int> data;
  const LineGraph({
    required this.month,
    required this.data,
    super.key
  });

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {

  List<FlSpot> spotData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    spotData = [];
    for (var entry in widget.data.keys) {
      if (entry[0] == widget.month) {
        spotData.add(FlSpot(entry[1].toDouble(), widget.data[entry]!.toDouble()));
      } 
    }
    return Container(
        margin: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 200,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.lightBlue.shade200,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map(
                    (LineBarSpot touchedSpot) {
                      const textStyle = TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      );
                      List<String> moods = 
                      ['Very Sad', 'Sad', 'Neutral', 'Happy', 'Very Happy'];
                      String text = moods[touchedSpot.y.toInt() - 1];
                      return LineTooltipItem(
                        '$text \n',
                        textStyle,
                        children: [
                          TextSpan(
                            text: touchedSpot.x.toInt().toString(),
                            style: textStyle
                          ),
                        ]
                      );
                    },
                  ).toList();
                }
              )
            ),
            borderData: FlBorderData(show: false), 
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget:(value, meta) {
                    if ((value.toInt() - 1) % 5 == 0) {
                      return Text('${value.toInt()}/${widget.month}');
                    }
                    return const Text('');
                  },
                  interval: 1
                )
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))
            ),
            gridData: FlGridData(
              drawHorizontalLine: false,
              verticalInterval: 1,
              getDrawingVerticalLine: (value) =>
                FlLine(color: Colors.grey.shade400),
              checkToShowVerticalLine: (value) {
                return ((value.toInt() - 1) % 5 == 0);
              },
            ),
            lineBarsData: [
              LineChartBarData(
                color: Colors.lightBlue.shade200,
                barWidth: 4,
                dotData: FlDotData(
                  getDotPainter:(p0, p1, p2, p3) {
                    return FlDotCirclePainter(
                      color: Colors.white,
                      strokeColor: Colors.lightBlue.shade200,
                      strokeWidth: 2,
                      radius: 3
                    );
                  },
                ),
                spots: spotData
                // [
                // const FlSpot(12, 3),
                // const FlSpot(13, 4),
                // const FlSpot(14, 3),
                // const FlSpot(15, 2),
                // const FlSpot(16, 3),
                // const FlSpot(17, 4),
                // const FlSpot(18, 3),
                // const FlSpot(19, 2),
                // ],
              )
            ],
            minX: 0,
            maxX: 32,
            minY: 0,
            maxY: 6
          ),
          //swapAnimationDuration: const Duration(seconds: 2),
        ),
    );
  }
}