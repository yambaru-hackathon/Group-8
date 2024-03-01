import 'package:flutter/material.dart';
import 'package:goup8_app/Pages/account_page.dart';
import 'package:goup8_app/Pages/qrcodescan_page.dart';
import 'package:goup8_app/Pages/search_page.dart';
import 'package:goup8_app/DB_Pages/DB_map_page.dart';
import 'dart:math';

void main() {
  runApp(const MapPage());
}

final DB_map_page = MapPageClass();  //  DB_DB_map_pageのMapPageClass()を参照

List<String> userList = [];

Map<String, List<dynamic>>? scheduleInfo;

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRcodescanPage()),
              );
            },
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 30,
            ),
          ),
          const Text(
            'User Name',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);
  @override
  State<DemoPage> createState() => _DemoPageState();
}

class PinData {
  num x, y;
  final String message;
  PinData(this.x, this.y, this.message);
}

class _DemoPageState extends State<DemoPage> {
  final _transformationController = TransformationController();
  double scale = 1.0;
  double defaultWidth = 50.0;
  double defaultHeight = 20.0;
  double defFontSize = 20.0;
  
  double calcWidth() {
    return ((defaultWidth / scale) / 2);
  }

  double calcHeight() {
    return ((defaultHeight / scale));
  }

  void tapPin(String message, List<String> userList, Map<String, List<dynamic>>? scheduleInfo) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Center(child: Text(message)), // タイトルを中央に配置する

          // ユーザーと予定が存在する時
          content: (userList.isNotEmpty && scheduleInfo != null)
          ? SizedBox(
              height: 150,
              width: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // '所在しているユーザー'のテキストを表示
                  Align(
                  alignment: Alignment.center,
                  child: Text(
                    '所在しているユーザー',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // ユーザー情報を表示するListView.builder
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: userList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // userList の要素を取得
                    final user = userList[index];
                    // ユーザー情報を表示するウィジェット
                    return Text(
                      '$user',
                      textAlign: TextAlign.center,
                    );
                  },
                ),

                // 間隔を追加
                SizedBox(height: 16), // 16ピクセルの高さの空白を追加

                // '予定が入っているグループ'のテキストを表示
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '予定が入っているグループ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // スケジュール情報を表示するListView.builder
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: scheduleInfo['groupName']!.length,
                  itemBuilder: (BuildContext context, int index) {
                    // scheduleInfo の要素を取得
                    final groupName = scheduleInfo['groupName']![index];
                    final dateTime = scheduleInfo['dateTime']![index];
                    // スケジュール情報を表示するウィジェット
                    return Text(
                      '$groupName : $dateTime',
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ],
            ),
          )

          // ユーザーだけ存在して予定が存在しない時
          : (userList.isNotEmpty && scheduleInfo == null)
          ? SizedBox(
            height: 150,
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // '所在しているユーザー'のテキストを表示
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '所在しているユーザー',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // ユーザー情報を表示するListView.builder
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: userList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // userList の要素を取得
                    final user = userList[index];
                    // ユーザー情報を表示するウィジェット
                    return Text(
                      '$user',
                      textAlign: TextAlign.center,
                    );
                  },
                ),

                // 間隔を追加
                SizedBox(height: 16), // 16ピクセルの高さの空白を追加

                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '予定が入っているグループはありません',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )

          // ユーザーが存在せずに予定が存在する時
          : (userList.isEmpty && scheduleInfo != null)
          ? SizedBox(
            height: 150,
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$message に所在のユーザーはいません',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // 間隔を追加
                SizedBox(height: 16), // 16ピクセルの高さの空白を追加

                // '予定が入っているグループ'のテキストを表示
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '予定が入っているグループ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // スケジュール情報を表示するListView.builder
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: scheduleInfo['groupName']!.length,
                  itemBuilder: (BuildContext context, int index) {
                    // scheduleInfo の要素を取得
                    final groupName = scheduleInfo['groupName']![index];
                    final dateTime = scheduleInfo['dateTime']![index];
                    // スケジュール情報を表示するウィジェット
                    return Text(
                      '$groupName : $dateTime',
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ],
            ),
          )

          // ユーザーも予定も存在しない時
          : Container(
            height: 150,
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$message に所在のユーザーはいません',
                  textAlign: TextAlign.center,
                ),

                // 間隔を追加
                SizedBox(height: 16), // 16ピクセルの高さの空白を追加

                Text(
                  '予定が入っているグループはありません',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            ),
            // OK Button
            actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  
   // ピンのリストを適当に生成
  final List<PinData> pinDataList = [
    PinData(50, 295, "情報通信工学実験室"),
    PinData(79, 295, "準備室1"),
    PinData(93, 295, "準備室2"),
    PinData(119, 295, "ネットワーク演習室"),
    PinData(236, 295, "調理室"),
    PinData(264, 295, "創造工房"),
    PinData(311, 295, "中央機器分析室"),
    PinData(358, 295, "材料特性評価室"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        // ignore: deprecated_member_use
        alignPanAxis: false,
        constrained: true,
        panEnabled: true,
        scaleEnabled: true,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: 0.1,
        maxScale: 10.0,
        onInteractionUpdate: (details) {
          setState(() {
            // データを更新
            scale = _transformationController.value.getMaxScaleOnAxis();
          });
        },
        transformationController: _transformationController,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              'images/創造実践塔1F.png',
              fit: BoxFit.fitWidth,
            ),
            for (PinData pinData in pinDataList)
              // 一定の scale よりも小さくなったら非表示にする
              if (scale > 0.9)
                // Positionedで配置
                Positioned(
                    // 座標を左上にすると、拡大縮小時にピンの位置がズレていくので、ピンの先端がズレないように固定
                    left: pinData.x - calcWidth(),
                    top: pinData.y - calcHeight(),
                    // 画像の拡大率に合わせて、ピン画像のサイズを調整
                    width: defaultWidth / scale,
                    height: defaultHeight / scale,
                    child: GestureDetector(
                      child: Container(
                        alignment: const Alignment(0.0, 0.0),
                        child: Image.asset("images/map_pin_shadow.png"),
                      ),
                      onTap: () async {

                        if (pinData.x == 50 && pinData.y == 295){
                          userList = await DB_map_page.viewUserList(7);
                          scheduleInfo = await DB_map_page.getScheduleInfo(7);
                        }

                        else if (pinData.x == 79 && pinData.y == 295){
                          userList = await DB_map_page.viewUserList(6);
                          scheduleInfo = await DB_map_page.getScheduleInfo(6);
                        }

                        else if (pinData.x == 93 && pinData.y == 295){
                          userList = await DB_map_page.viewUserList(5);
                          scheduleInfo = await DB_map_page.getScheduleInfo(5);
                        }

                        else if (pinData.x == 119 && pinData.y == 295){
                          userList = await DB_map_page.viewUserList(4);
                          scheduleInfo = await DB_map_page.getScheduleInfo(4);
                        }

                        else if (pinData.x == 236 && pinData.y == 295){
                          userList = await DB_map_page.viewUserList(3);
                          scheduleInfo = await DB_map_page.getScheduleInfo(3);
                        }

                        else if (pinData.x == 264 && pinData.y == 295){
                          userList = await DB_map_page.viewUserList(2);
                          scheduleInfo = await DB_map_page.getScheduleInfo(2);
                        }

                        else if (pinData.x == 311 && pinData.y == 295){
                          userList = await DB_map_page.viewUserList(1);
                          scheduleInfo = await DB_map_page.getScheduleInfo(1);
                        }

                        else if (pinData.x == 358 && pinData.y == 295){
                          userList = await DB_map_page.viewUserList(0);
                          scheduleInfo = await DB_map_page.getScheduleInfo(0);
                        }

                        else {
                          debugPrint('登録されていない座標のピン');
                        }

                        if(scheduleInfo != null) {
                          print('使用するグループ：${scheduleInfo?['groupName']}');
                          print('予定時間:${scheduleInfo?['dateTime']}');
                        }

                        else {
                          print('使用予定のグループはありません');
                        }

                        tapPin(pinData.message, userList, scheduleInfo);
                      }
                    )
                ),
          ],
        ),
      )
    );
  }
}
                  


