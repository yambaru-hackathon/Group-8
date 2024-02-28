class Event {
  final String title;
  final String location; // デフォルト値を指定

  Event({this.title = "", this.location = ""}); // デフォルト値を指定

  String toString() {
    if (title.isNotEmpty && location.isNotEmpty) {
      return '$title - $location';
    } else if (title.isNotEmpty) {
      return title;
    } else {
      return 'No title';
    }
  }
}
