import 'package:flutter/material.dart';

import 'activity.dart';

// ignore: must_be_immutable
class ActivityIcon extends StatelessWidget{  
  Activity activity;
  ActivityIcon(this.activity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ColorFiltered(
            colorFilter: activity.isSelected ? 
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
            child: CircleAvatar(
              radius: 25,
              child: SizedBox(
                width: 30,
                height: 30,                         
                child: Image.asset(
                  activity.image,
                )
              )
            )
          ),
        ),
        Text(
          activity.name.toLowerCase(),
          style: const TextStyle(
            fontSize: 12
          ),
        )
      ],
    );
  }

}