import 'package:flutter/material.dart';
import 'package:goup8_app/DB_Pages/DB_search_page.dart';
import 'package:goup8_app/Pages/searchresults_page.dart';

final DB_search_page =
    SearchPageClass(); // DB_group_pageのDB_group_page_classを参照

String groupName = ''; // グループの名前を格納
String placeName = ''; // 場所の名前を格納
List<String> attributeUserNames = []; // 属性に一致するユーザーを配列で格納

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
                  onSubmitted: (String value) async {
                    // 検索部分
                    // エンターキーを押した時文字列が空じゃないなら
                    if (value.isEmpty != true) {
                      if (value.startsWith('@')) {
                        groupName = await DB_search_page.searchGroup(value);

                        if (groupName.isNotEmpty == true) {
                          debugPrint('代入確認@グループ：$groupName');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SearchResultsPage(dataList: [groupName]),
                            ),
                          );
                        } else {
                          debugPrint('該当するグループは見つかりませんでした');
                          _showAlertDialog(context, '該当するグループは見つかりませんでした');
                        }
                      } else if (value.startsWith('#')) {
                        placeName = await DB_search_page.searchPlace(value);

                        if (placeName.isNotEmpty == true) {
                          debugPrint('代入確認#場所：$placeName');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SearchResultsPage(dataList: [placeName]),
                            ),
                          );
                        } else {
                          debugPrint('該当する場所は見つかりませんでした');
                          _showAlertDialog(context, '該当する場所は見つかりませんでした');
                        }
                      } else if (value.startsWith('*')) {
                        attributeUserNames =
                            await DB_search_page.searchAttribute(value);

                        if (attributeUserNames.isNotEmpty) {
                          debugPrint('代入確認*属性：$value');
                          attributeUserNames.forEach((attributeUserNames) {
                            debugPrint('$attributeUserNames');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultsPage(
                                  dataList: attributeUserNames),
                            ),
                          );
                        } else {
                          debugPrint('該当する属性のユーザーは見つかりませんでした');
                          _showAlertDialog(context, '該当する属性のユーザーは見つかりませんでした');
                        }
                      } else {
                        debugPrint('文字列の最初に記号を付けてください');
                        _showAlertDialog(context, '文字列の最初に記号を付けてください');
                      }
                    } else {
                      debugPrint('文字列を入力してください');
                      _showAlertDialog(context, '文字列を入力してください');
                    }

                    // 検索部分
                  },
                ),
              ),
            ),
          ),
        ));
  }

  // アラートを表示する関数
  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("Not Found")),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}