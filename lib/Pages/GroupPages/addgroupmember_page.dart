import 'package:flutter/material.dart';
import 'package:group8/DB_Pages/DB_GroupPages/DB_addgroupmenber_page.dart';
import 'package:group8/Pages/GroupPages/groupdetail_page.dart';

class AddNewGroupMenber extends StatelessWidget {
  final DB_addgroupmember_page =
      DB_addgroupmember_page_class(); // DB_addgroupmember_pageのDB_addgroupmember_page_classを参照

  AddNewGroupMenber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.blue), // 検索アイコンを追加
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
                  onSubmitted: (value) {
                    // 検索部分
                    // エンターキーを押した時文字列が空じゃないなら
                    if (value.isNotEmpty == true) {
                      DB_addgroupmember_page.readUserSearch(
                          value); // DB_addgroupmember_pageのreadUserSearch(value)関数を実行
                    } else {
                      debugPrint('文字を入力してください');
                    }
                    // 検索部分
                  },
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
              DB_addgroupmember_page
                  .set_add_user_info_id(); // DB_addgroupmember_pageのset_add_user_info_id()関数を実行

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
        ),
      ),
    );
  }
}
