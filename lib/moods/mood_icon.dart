import 'package:flutter/material.dart';

import 'mood.dart';

// ignore: must_be_immutable
class MoodIcon extends StatelessWidget{  
  Mood mood;
  MoodIcon(this.mood, {super.key});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: mood.isSelected ? 
      const ColorFilter.mode(
        Colors.transparent,
        BlendMode.multiply,
      ) :
      const ColorFilter.matrix(<double>[
        0.2126,0.7152,0.0722,0,0,
        0.2126,0.7152,0.0722,0,0,
        0.2126,0.7152,0.0722,0,0,
        0,0,0,1,0
      ]),
      child: Image.asset(
        mood.image,
        height: 10,
        width: 10
      ),
    );
  }

}