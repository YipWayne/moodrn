import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:moodrn/moods/calendar_icon.dart';
import 'package:moodrn/views/create_update_mood_view.dart';
import 'package:moodrn/db_helper.dart';

import '../global.dart';
import '../moods/mood_card.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<String, String> entries = {};
  bool doneLoading = false;
  
  Future<void> getAllEntries() async {
    await DBHelper.getAllData()
    .then((value) {
      for (var entry in value) {
        final date = entry['date'];
        final mood = entry['mood_image'];
        entries[date] = mood;
      }
    });
    doneLoading = true;
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
    return Scaffold(
      body: doneLoading ? Column(
        children: [
          TableCalendar(
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false
            ),
            rowHeight: 66,
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2033, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return (
                isSameDay(_selectedDay, day) && 
                (_focusedDay.month == day.month)
              );
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });            
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final formattedDate = formatDate(day);
                return CalendarIcon(
                  date: day,
                  moodImage: entries[formattedDate] ?? 'assets/mood_null.png',
                  isSelected: false,
                  isToday: false
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                final formattedDate = formatDate(day);
                final today = DateTime.now();
                bool isToday_ = (
                (day.day == today.day) && 
                (day.month == today.month) &&
                (day.year == today.year)
                );
                if (_focusedDay.month == day.month) {
                  return CalendarIcon(
                  date: day,
                  moodImage: entries[formattedDate] ?? 'assets/mood_null.png',
                  isSelected: true,
                  isToday: isToday_
                  );
                }
                return const Text('');
              },
              todayBuilder: (context, day, focusedDay) {
                final formattedDate = formatDate(day);
                return CalendarIcon(
                  date: day,
                  moodImage: entries[formattedDate] ?? 'assets/mood_null.png',
                  isSelected: false,
                  isToday: true
                );
              },
              outsideBuilder: (context, day, focusedDay)
                => const Text('')
            )
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
            child: FutureBuilder (
              future: DBHelper.getData(formatDate(_focusedDay)),
              builder: ((context, snapshot) {
                final hasEntry = snapshot.data?.length;
                if (hasEntry == 1) {
                  Map<String, dynamic>? currEntry = snapshot.data?[0];
                  List<String> currActivities = currEntry?['activity_images']
                  .split(',');
                  return MoodCard(
                    date: reformatDate(currEntry?['date']), 
                    moodImage: currEntry?['mood_image'], 
                    activityImages: currActivities, 
                    comments: currEntry?['comments'] 
                  );
                }
                else {
                  return const MoodCard(
                    date: '',
                    moodImage: 'assets/mood_null.png', 
                    activityImages: [], 
                    comments: ''
                  );
                }
              })
            ),
          )
        ],
      ) : 
      const Center(
        child: CircularProgressIndicator()
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:(context) =>
                CreateUpdateMoodView(date:formatDate(_focusedDay),) //there should be a better implementation of this
            )
          ).then((value) async {   
            await getAllEntries();               
            setState(() {});                                                                                            
          });
        },
        child: const Icon(Icons.add),
      ), 
    );
  }
}
