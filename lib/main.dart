import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moodrn/db_notifier.dart';
import 'package:moodrn/views/calendar_view.dart';
import 'package:moodrn/views/dashboard_view.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => DBNotifier(),
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodRN',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int selectedIndex = 0;

  final titleOptions = [
    'My Calendar',
    'My Dashboard',
  ];

  final widgetOptions = [
    const CalendarView(),
    const DashboardView(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(titleOptions[selectedIndex]),
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
      body: Container(
        child: widgetOptions.elementAt(selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          )
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}


