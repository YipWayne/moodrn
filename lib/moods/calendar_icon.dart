import 'package:flutter/material.dart';

class CalendarIcon extends StatefulWidget {
  final DateTime date;
  final String moodImage;
  final bool isSelected;
  final bool isToday;
  const CalendarIcon({super.key, 
    required this.date,
    required this.moodImage, 
    required this.isSelected,
    required this.isToday
  });

  @override
  State<CalendarIcon> createState() => _CalendarIconState();
}

class _CalendarIconState extends State<CalendarIcon> {

  String day = '';

  @override
  void initState() {
    day = widget.date.day.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.isToday ? Colors.red : null,
              borderRadius: BorderRadius.circular(5)
            ),
            padding: const EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
            margin: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                color: widget.isToday ? Colors.white : Colors.black                  
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: (widget.isSelected) ?                
                  Border.all(width: 2, color: Colors.black) :             
                  Border.all(width: 2, color: Colors.white.withOpacity(0)), 
              borderRadius:               
                  BorderRadius.circular(100)                               
            ),
            child: Image.asset(
              widget.moodImage,
              height: 37,
              width: 37
            )
          )
        ]
      )
    );  
  }
}