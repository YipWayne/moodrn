import 'package:flutter/material.dart';

class MoodCard extends StatefulWidget {
  final String date;
  final String moodImage;
  final List<String> activityImages;
  final String comments;

  const MoodCard({
    required this.date,
    required this.moodImage,
    required this.activityImages,
    required this.comments,
    super.key
  });

  @override
  State<MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<MoodCard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Card(
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(15.0, 20.0, 8.0, 0.0),
              child: Column(
                children: [
                  Image.asset(
                    widget.moodImage,
                    height: 55,
                    width: 55
                  ),
                  const SizedBox(height: 15),
                  Container(
                    alignment: Alignment.center,
                    width: 80,
                    padding: const EdgeInsets.all(3.0),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(8)) 
                    ),
                    child: Text(
                      widget.date,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10
                      )
                    )
                  )
                ]
              )
            ),
            const VerticalDivider(
              indent: 8,
              endIndent: 8,
              color: Colors.grey
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(12.0, 10.0, 27.0, 0.0),
                child: Column(
                  children: [              
                    Expanded(
                      child: ListView.separated(   
                        scrollDirection: Axis.horizontal,   
                        itemCount: widget.activityImages.length,    
                        separatorBuilder: (context, index) => 
                          const SizedBox(width: 10),           
                        itemBuilder: (BuildContext context, int index) {
                          return CircleAvatar(
                            radius: 25,
                            child: SizedBox(
                              width: 30,
                              height: 30,                         
                              child: Image.asset(
                                widget.activityImages[index],
                              )
                            )
                          );
                        }
                      )
                    ),
                    Container(
                      height: 65,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.comments,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )    
                    )
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }
}