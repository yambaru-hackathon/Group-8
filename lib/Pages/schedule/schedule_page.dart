import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:group8_app/Pages/schedule/calendar.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
    );
  }
}
