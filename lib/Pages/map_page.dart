import 'package:flutter/material.dart';
import 'dart:async';
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

  double calcWidth(double imageWidth) {
    return ((defaultWidth / imageWidth) / scale / 2);
  }

  double calcHeight(double imageHeight) {
    return ((defaultHeight / imageHeight) / scale);
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
    PinData(47, 285, "情報通信工学実験室"),
    PinData(75, 285, "準備室1"),
    PinData(90, 285, "準備室2"),
    PinData(117, 285, "ネットワーク演習室"),
    PinData(236, 285, "調理室"),
    PinData(264, 285, "創造工房"),
    PinData(311, 285, "中央機器分析室"),
    PinData(358, 285, "材料特性評価室"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getImageSize('images/創造実践塔1F.png'),
        builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          Size imageSize = snapshot.data!;
          return InteractiveViewer(
            alignPanAxis: false,
            constrained: true,
            panEnabled: true,
            scaleEnabled: true,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            minScale: 2.0,
            maxScale: 5.0,
            onInteractionUpdate: (details) {
              setState(() {
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
                  if (scale > 0.9)
                    Positioned(
                      left: pinData.x - calcWidth(imageSize.width),
                      top: pinData.y - calcHeight(imageSize.height),
                      width: defaultWidth / scale,
                      height: defaultHeight / scale,
                      child: GestureDetector(
                        child: Container(
                          alignment: const Alignment(0.0, 0.0),
                          child: Image.asset(
                            "images/map_pin_shadow.png",
                          ),
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
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Size> getImageSize(String imagePath) async {
    Image image = Image.asset(imagePath);
    Completer<Size> completer = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ));
        },
      ),
    );
    return completer.future;
  }
}
