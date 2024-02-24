import 'package:flutter/material.dart';
import 'package:goup8_app/Pages/GroupPages/groupdetail_page.dart';

class AddNewGroupMenber extends StatelessWidget {
  const AddNewGroupMenber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '新しいグループを作成',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 左寄りにする
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.search, color: Colors.blue), // 検索アイコンを追加
                hintText: '追加する人物を検索',
                filled: true, // 塗りつぶしを有効にする
                fillColor: Colors.grey[200], // 塗りつぶしの色をグレーに設定
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // 枠の角を丸くする
                  borderSide: BorderSide.none, // 枠線を非表示にする
                ),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onChanged: (value) {},
              onSubmitted: (value) {},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewGroupDetail(),
            ),
          );
        },
        label: const Text(
          'next',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
