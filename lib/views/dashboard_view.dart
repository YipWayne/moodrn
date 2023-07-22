import 'package:flutter/material.dart';

import 'package:moodrn/moods/mood_card.dart';
import 'package:moodrn/views/create_update_mood_view.dart';

import '../global.dart';
import '../db_helper.dart';
import '../utilities/delete_dialog.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
        future: DBHelper.getAllData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'There are no entries',
                  style: TextStyle(
                    color: Colors.grey
                  ),
                )
              );  
            }
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                Map<String, dynamic>? currEntry = snapshot.data?[index];
                if (currEntry != null) {
                  List<String> currActivities = currEntry['activity_images']
                  .split(',');
                  return Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [   
                            GestureDetector(
                              onTap: () async {
                                final shouldDelete = await showDeleteDialog(context);
                                if (shouldDelete) {
                                  setState(() {
                                    DBHelper.delete(currEntry['date']);
                                  });
                                }
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.grey
                                )
                            ),
                            const SizedBox(width: 15), 
                            GestureDetector(
                              onTap:() => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:(context) =>
                                    CreateUpdateMoodView(date: currEntry['date'])
                                )
                              ).then((value) {                    
                                  setState(() {});                                                                                            
                              }),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.grey
                              )   
                            ),
                            const SizedBox(width: 10)
                          ]
                        ),
                        MoodCard(
                          date: reformatDate(currEntry['date']), 
                          moodImage: currEntry['mood_image'], 
                          activityImages: currActivities, 
                          comments: currEntry['comments']
                        )
                      ]
                    )
                  );
                }
                return const CircularProgressIndicator();
              }
            );
          }
          return const Center(
            child: CircularProgressIndicator()
          );
        }
      )
    );
  }
}