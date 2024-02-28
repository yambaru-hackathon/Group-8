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

  final DB_schedule_page = DBSchedulePageClass();  //  DB_groupdetail_pageのDB_groupdetail_page_class()を参照

  late final Map<DateTime, List<Event>> selectedEvents;
  final List<Event> events = [];

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

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
              selectedTextStyle: TextStyle(color: Colors.white),
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
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ..._getEventsfromDay(selectedDay).map(
            (Event event) => ListTile(
              title: Text(
                event.title,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(top: 64),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _eventController,
                        decoration: InputDecoration(
                          hintText: "タイトルを入力(必須)",
                          labelText: "Title"),    // タイトル

                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          // 文字列が空じゃないなら
                          if(value.isNotEmpty) {
                            DB_schedule_page.addTitle(value);
                          }
                        },
                      ),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: "場所を入力",
                          labelText: "Location",                            // 場所
                          prefixIcon: Icon(Icons.location_on_rounded),
                        ),

                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          // 文字列が空じゃないなら
                          if(value.isNotEmpty) {
                          DB_schedule_page.addLocation(value);
                          }
                        },
                      ),
                      TextFormField(
                        controller: _datetimeController,
                        decoration: InputDecoration(
                          hintText: "2024-01-01 12:00:00(必須)",
                          labelText: "Datetime",                            // 日時
                          prefixIcon: Icon(Icons.access_time),
                        ),

                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          // 文字列が空じゃないなら
                          if(value.isNotEmpty) {
                            DB_schedule_page.addDateTime(value);
                          }
                        },
                      ),
                      TextFormField(
                        controller: _groupController,
                        decoration: InputDecoration(
                          hintText: "グループ名を入力",
                          labelText: "Group",                               // グループ
                          prefixIcon: Icon(Icons.group),
                        ),

                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          // 文字列が空じゃないなら
                          if(value.isNotEmpty) {
                            DB_schedule_page.addGroup(value);
                          }
                        },
                      ),
                      TextFormField(
                        controller: _guestController,
                        decoration: InputDecoration(
                          hintText: "ユーザー名を入力",
                          labelText: "Guest",                               // ゲスト
                          prefixIcon: Icon(Icons.person_2),
                        ),

                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onFieldSubmitted: (value) {
                          // 文字列が空じゃないなら
                          if(value.isNotEmpty) {
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
                      child: Text("Cancel"),
                      onPressed: () {
                        //スケジュールのキャンセル
                        DB_schedule_page.resetSchedule();

                        Navigator.pop(context);
                      }
                    ),
                    TextButton(
                      child: Text("Ok"),
                      onPressed: () {
                        //スケジュールの作成
                        DB_schedule_page.createSchedule();

                        // 入力されたイベント情報を取得
                        String title = _eventController.text;
                        String Location = _locationController.text;
                        // ... その他の入力項目を取得
                        // イベント情報を Event オブジェクトに格納
                        Event newEvent = Event(
                          title: title,
                          Location: Location,
                        );
                        // リストにイベントを追加
                        setState(() {
                          events.add(newEvent);
                        });
                        // カレンダーを更新する (必要に応じて)
                        // モーダルを閉じる
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
