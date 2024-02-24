class Event {
  final String title;
  Event({this.title = "", required Location}); // デフォルト値を指定

  String toString() => this.title;
}

class Location {
  final String title;
  Location({this.title = ""});

  String toString() => this.title;
}
