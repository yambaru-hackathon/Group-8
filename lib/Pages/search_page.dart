import 'package:flutter/material.dart';
import 'package:goup8_app/DB_Pages/DB_search_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
              backgroundColor: Colors.blue,
              title: SizedBox(
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '@ グループ   # 場所  * 属性',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {},
                  onSubmitted: (value) {
                    // 検索部分
                    if (value.isEmpty != true) {
                      // エンターキーを押した時文字列が空じゃないなら
                      final DB_search_page =
                          DB_search_page_class(); // DB_group_pageのDB_group_page_classを参照
                      DB_search_page.JudgeSearch(
                          value); // DB_group_pageのreadGroupSearch(value)関数を実行
                    }
                    // 検索部分
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
