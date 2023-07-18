import 'package:flutter/foundation.dart';
import 'package:moodrn/db_helper.dart';

import 'activities/activity.dart';
import 'moods/mood.dart';

class DBNotifier extends ChangeNotifier {
  String date = '';
  String moodName = '';
  String moodImage = '';

  List<String> allActivitiesNames = [];
  List<String> allActivitiesImages = [];

  void initialise (
    String date_,
    String moodName_,
    String moodImage_,
    List<String> allActivitiesNames_,
    List<String> allActivitiesImages_
  ) {
    date = date_;
    moodName = moodName_;
    moodImage = moodImage_;
    allActivitiesNames = allActivitiesNames_;
    allActivitiesImages = allActivitiesImages_;
  }

  void freshInitalise (String date_) {
    date = date_;
    moodName = '';
    moodImage = '';
    allActivitiesNames = [];
    allActivitiesImages = [];
  }

  void addMood (Mood mood) {
    moodName = mood.name;
    moodImage = mood.image;
  }

  void addActivityToList (Activity activity) {
    allActivitiesNames.add(activity.name);
    allActivitiesImages.add(activity.image);
  }

  void removeActivityFromList (Activity activity) {
    allActivitiesNames.remove(activity.name);
    allActivitiesImages.remove(activity.image);
  }

  Future<bool> addEntryToDB(String comments) async {
    // If fields in dbNotifier are empty
    if (date == '' || moodName == '' || allActivitiesNames.isEmpty) {
      return false;
    }
    else {
      allActivitiesNames.sort((a, b) => a.toString().compareTo(b.toString()));
      allActivitiesImages.sort((a, b) => a.toString().compareTo(b.toString()));
      // sort activities alphabetically
      String joinedNames = allActivitiesNames.join(',');
      String joinedImages = allActivitiesImages.join(',');
      await DBHelper.insert(
        'moods_table',
        {
          'date': date,
          'mood_name': moodName,
          'mood_image': moodImage,
          'activity_names': joinedNames,
          'activity_images': joinedImages,
          'comments': comments
        }
      );
      return true;
    }
  }

}