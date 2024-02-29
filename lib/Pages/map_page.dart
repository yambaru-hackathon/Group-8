import 'package:flutter/material.dart';
import 'package:goup8_app/Pages/account_page.dart';
import 'package:goup8_app/Pages/qrcodescan_page.dart';
import 'package:goup8_app/Pages/search_page.dart';
import 'package:goup8_app/DB_Pages/DB_map_page.dart';

void main() {
  runApp(const MapPage());
}

final DB_map_page = MapPageClass();  //  DB_DB_map_pageのMapPageClass()を参照

List<String> userList = [];

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

  void tapPin(String message, List<String> userList) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Center(child: Text(message)),
        content: userList.isNotEmpty
            ? SizedBox(
                width: 350,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: userList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                      userList[index],
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              )
            : Container(
              width: 350,
              child: Text(
                '$message に所在のユーザーはいません',
                textAlign: TextAlign.center,
              ),
            ),
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

                      if (pinData.x == 47 && pinData.y == 285){
                            userList = await DB_map_page.viewUserList(7);
                          }

                      else if (pinData.x == 75 && pinData.y == 285){
                        userList = await DB_map_page.viewUserList(6);
                      }

                      else if (pinData.x == 90 && pinData.y == 285){
                        userList = await DB_map_page.viewUserList(5);
                      }

                      else if (pinData.x == 117 && pinData.y == 285){
                        userList = await DB_map_page.viewUserList(4);
                      }

                      else if (pinData.x == 236 && pinData.y == 285){
                        userList = await DB_map_page.viewUserList(3);
                      }

                      else if (pinData.x == 264 && pinData.y == 285){
                        userList = await DB_map_page.viewUserList(2);
                      }

                      else if (pinData.x == 311 && pinData.y == 285){
                        userList = await DB_map_page.viewUserList(1);
                      }

                      else if (pinData.x == 358 && pinData.y == 285){
                        userList = await DB_map_page.viewUserList(0);
                      }

                      tapPin(pinData.message, userList);
                    },
                  )),
        ],
      ),
    ));
  }
}
