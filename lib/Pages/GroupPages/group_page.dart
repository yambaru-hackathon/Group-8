import 'package:flutter/material.dart';
import 'package:goup8_app/Pages/GroupPages/addgroupmenber_page.dart';
import 'package:goup8_app/DB_Pages/DB_GroupPages/DB_group_page.dart'; // DB関数のインポート

class GroupPage extends StatelessWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'Group',
          style: TextStyle(
            color: Colors.white,
          ),
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
                hintText: 'グループを検索',
                filled: true, // 塗りつぶしを有効にする
                fillColor: Colors.grey[200], // 塗りつぶしの色をグレーに設定
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onChanged: (value) {},
              onSubmitted: (value) {
                if(value.isEmpty != true) {
                  final DB_group_page = DB_group_page_class(); // DB_group_pageのDB_group_page_classを参照
                  DB_group_page.readGroupSearch(value);
                }
              },
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20, left: 30),
            child: const Text(
              '作成したグループ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          // ListView.builder(),  ここで作ったグループを取得してリストを表示する
        ],
      ),
      //creat button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewGroupMenber()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
