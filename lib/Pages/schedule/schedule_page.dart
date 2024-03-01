import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:goup8_app/Pages/schedule/event.dart';
import 'package:goup8_app/DB_Pages/DB_schedule_page.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<SchedulePage> {
  final DB_schedule_page =
      DBSchedulePageClass(); //  DB_groupdetail_pageのDB_groupdetail_page_class()を参照

  late final Map<DateTime, List<Event>> selectedEvents;
  final List<Event> events = [];

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime? _selectedDate; // _selectedDateを追加

  TextEditingController _eventController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _datetimeController = TextEditingController();
  TextEditingController _groupController = TextEditingController();
  TextEditingController _guestController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: const Text(
            'Schedule',
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              print(focusedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ..._getEventsfromDay(selectedDay).map(
            (Event event) => ListTile(
              title: Text(
                event.title,
              ),
              subtitle: Text(
                event.location,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(events[index].title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("！確認!"),
                              content: const Text("削除しますか?"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Delete")),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(
                                    "Cancel",
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                ),
                              ],
                            ),
                          ) ??
                          false;
                      if (confirm) {
                        var event;
                        await FirebaseFirestore.instance
                            .collection('schedule')
                            .doc(event.id)
                            .delete();
                        Navigator.pop(context);
                      }
                    },
                  ),
                  subtitle: Text(events[index].location),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 64),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        //initialValue: _eventController.text,
                        controller: _eventController,
                        decoration: const InputDecoration(
                            hintText: "タイトルを入力(必須)",
                            labelText: "Title"), // タイトル

                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          // 文字列が空じゃないなら
                          if (value.isNotEmpty) {
                            DB_schedule_page.addTitle(value);
                          }
                        },
                      ),
                      TextFormField(
                        //initialValue: _locationController.text,
                        controller: _locationController,
                        decoration: const InputDecoration(
                          hintText: "場所を入力",
                          labelText: "Location", // 場所
                          prefixIcon: Icon(Icons.location_on_rounded),
                        ),

                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          // 文字列が空じゃないなら
                          if (value.isNotEmpty) {
                            DB_schedule_page.addLocation(value);
                          }
                        },
                      ),
                      TextFormField(
                        controller: _datetimeController,
                        decoration: const InputDecoration(
                          hintText: "2024-01-01 12:00:00(必須)",
                          labelText: "Datetime", // 日時
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          // 文字列が空じゃないなら
                          if (value.isNotEmpty) {
                            DB_schedule_page.addDateTime(value);
                          }
                        },
                      ),
                      TextFormField(
                        controller: _groupController,
                        decoration: const InputDecoration(
                          hintText: "グループ名を入力",
                          labelText: "Group", // グループ
                          prefixIcon: Icon(Icons.group),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          // 文字列が空じゃないなら
                          if (value.isNotEmpty) {
                            DB_schedule_page.addGroup(value);
                          }
                        },
                      ),
                      TextFormField(
                        //initialValue: _guestController.text,
                        controller: _guestController,
                        decoration: const InputDecoration(
                          hintText: "ユーザー名を入力",
                          labelText: "Guest", // ゲスト
                          prefixIcon: Icon(Icons.person_2),
                        ),

                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          // 文字列が空じゃないなら
                          if (value.isNotEmpty) {
                            DB_schedule_page.addUser(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          //スケジュールのキャンセル
                          DB_schedule_page.resetSchedule();

                          Navigator.pop(context);
                        }),
                    TextButton(
                      child: const Text("Ok"),
                      onPressed: () {
                        //スケジュールの作成
                        DB_schedule_page.createSchedule();
                        Navigator.popUntil(context, (route) => route.isFirst);

                        // 入力されたイベント情報を取得
                        //String title = _eventController.text;
                        //String location = _locationController.text;
                        // ... その他の入力項目を取得
                        // イベント情報を Event オブジェクトに格納
                        //Event newEvent = Event(
                        //title: title,
                        //location: location,
                        //);
                        // リストにイベントを追加
                        //setState(() {
                        //events.add(newEvent);
                        //});
                        // カレンダーを更新する (必要に応じて)
                        // モーダルを閉じる
                        //Navigator.pop(context);
                        //},
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        label: const Text("Add Event"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
