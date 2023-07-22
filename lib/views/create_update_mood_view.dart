import 'package:flutter/material.dart';
import 'package:moodrn/global.dart';
import 'package:provider/provider.dart';

import 'package:moodrn/services/db_notifier.dart';
import 'package:moodrn/moods/mood_icon.dart';

import '../activities/activity.dart';
import '../activities/activity_icon.dart';
import '../services/db_helper.dart';
import '../moods/mood.dart';
import '../utilities/insufficient_dialog.dart';

class CreateUpdateMoodView extends StatefulWidget {
  final String date;
  const CreateUpdateMoodView({super.key, required this.date}); 

  @override
  State<CreateUpdateMoodView> createState() => _CreateUpdateMoodViewState();
}

class _CreateUpdateMoodViewState extends State<CreateUpdateMoodView> {

  List<Mood> moods = [
    Mood('Very Sad', 'assets/mood_very_sad.png', false),
    Mood('Sad', 'assets/mood_sad.png', false),
    Mood('Neutral', 'assets/mood_neutral.png', false),
    Mood('Happy', 'assets/mood_happy.png', false),
    Mood('Very Happy', 'assets/mood_very_happy.png', false)
  ];

  List<Activity> activities = [
    Activity('Read', 'assets/activity_read.png', false),
    Activity('Sports', 'assets/activity_sports.png', false),
    Activity('Skate', 'assets/activity_skate.png', false),
    Activity('Gym', 'assets/activity_gym.png', false),
    Activity('Dance', 'assets/activity_dance.png', false),
    Activity('Games', 'assets/activity_games.png', false),
    Activity('Shopping', 'assets/activity_shopping.png', false),
    Activity('Sleep', 'assets/activity_sleep.png', false)
  ];

  final TextEditingController _textController = TextEditingController();
  bool doneLoading = false;

  Future<void> updateViewAndNotifier() async {
    await DBHelper.doesDataExist(widget.date) 
    .then((value) async {
      if (value == true) {
        await DBHelper.getData(widget.date)
        .then((value) {
          final entry = value.first;
          final moodName = entry['mood_name']; 
          final moodImage = entry['mood_image'];
          final activitiesNames = entry['activity_names'].split(',');
          final activitiesImages = entry['activity_images'].split(',');
          for (final mood in moods) {
            if (mood.name == moodName) {
              setState(() {
                mood.isSelected = true;
              }); 
              break;
            }
          }
          for (final activity in activities) {
            if (activitiesNames.contains(activity.name)) {
              setState(() {
                activity.isSelected = true;
              });
            }
          }
          Provider.of<DBNotifier>(context, listen: false)
          .initialise(
            widget.date,
            moodName,
            moodImage,
            activitiesNames,
            activitiesImages
          );
          _textController.text = entry['comments'];
        });
      }
      else {
        Provider.of<DBNotifier>(context, listen: false)
        .freshInitalise(widget.date);
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
        await updateViewAndNotifier();
        doneLoading = true;
        setState(() {});
    });  
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(reformatDate(widget.date)),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(top: 15),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        toolbarHeight: 70,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            indent: 15,
            endIndent: 15,
            ),
        )
      ),
     
      body: doneLoading ? Container( 
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 110,
                  margin: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(12)) 
                  ),
                  child: Column(
                    children: [
                      const Text('How are you feeling?'),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: moods.length,
                          crossAxisSpacing: 7,
                          padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                          children: List.generate(moods.length, (index){
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  for(var mood in moods) {
                                    mood.isSelected = false;
                                  } 
                                  Provider.of<DBNotifier>(context, listen: false)
                                  .addMood(moods[index]);
                                  moods[index].isSelected = true;
                                });      
                              },
                              child: MoodIcon(
                                moods[index]
                              )
                            );
                          })   
                        ),
                      )
                    ]
                  )
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 210,
                  margin: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(12)) 
                  ),
                  child: Column(
                    children: [
                      const Text('What activities did you do?'),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                          children: List.generate(activities.length, (index){
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (activities[index].isSelected) {
                                    activities[index].isSelected = false;
                                    Provider.of<DBNotifier>(context, listen: false)
                                    .removeActivityFromList(activities[index]);
                                  }
                                  else {
                                    activities[index].isSelected = true;
                                    Provider.of<DBNotifier>(context, listen: false)
                                    .addActivityToList(activities[index]);
                                  }
                                });      
                              },
                              child: ActivityIcon(
                                activities[index]
                              )
                            );
                          })   
                        ),
                      )
                    ]
                  )
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 250,
                  margin: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 20.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.all(Radius.circular(12)) 
                  ),
                  child: Column(
                    children: [
                      const Text('Comments (if any)'),
                      Container(
                        padding: const EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 0.0),
                        child: TextFormField(
                          controller: _textController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          textAlignVertical: TextAlignVertical.top, 
                          keyboardType: TextInputType.multiline,
                          maxLines: 6
                        )
                      )
                    ]
                  )
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: const Size(300, 70),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightGreen.shade400,
                  ),
                  onPressed: () async {
                    bool addEntrySuccess = await Provider.of<DBNotifier>(context, listen: false)
                    .addEntryToDB(_textController.text);
                    if (addEntrySuccess && context.mounted) {
                      Navigator.of(context).pop();
                    }
                    else {
                      showInsufficientDialog(context);
                    }
                  },
                  child: const Text('Confirm')
                ),
              )
            ]
          ),
        )
      ) :
      const Center(child: CircularProgressIndicator())
    );
  }
}