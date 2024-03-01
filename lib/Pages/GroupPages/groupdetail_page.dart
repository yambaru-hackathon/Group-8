import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goup8_app/Pages/GroupPages/selectperson_page.dart';
import 'package:goup8_app/DB_Pages/DB_GroupPages/DB_groupcreate_page.dart'; //DB関数のインポート

class NewGroupDetail extends StatefulWidget {
  const NewGroupDetail({Key? key}) : super(key: key);

  @override
  _NewGroupDetailState createState() => _NewGroupDetailState();
}

class _NewGroupDetailState extends State<NewGroupDetail> {
  final DB_groupcreate_page =
      GroupCreatePageClass(); //  DB_groupdetail_pageのDB_groupdetail_page_class()を参照

  int? _selectedPermission;
  bool _selectperson = false;
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.group),
                      iconSize: 50,
                    ),
                    Flexible(
                      child: TextField(
                        maxLength: 20,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          hintText: "グループ名を入力",
                          labelText: "Group Name",
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {},
                        onSubmitted: (value) {
                          // グループ名入力部分

                          // エンターキーを押した時文字列が空じゃないなら
                          if (value.isNotEmpty) {
                            DB_groupcreate_page.addGroupName(
                                value); // DB_groupcreate_pageのaddGroupName関数を実行
                          }
                          // グループ名入力部分
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
                    // ユーザー名入力部分

                    // エンターキーを押した時文字列が空じゃないなら
                    if (value.isNotEmpty == true) {
                      DB_groupcreate_page.addUserId(
                          value); // DB_groupcreate_pageのaddUserId関数を実行
                    }

                    // ユーザー名入力部分
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                ),
                child: const Text(
                  'グループ編集の権限',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              RadioListTile<int>(
                title: const Text('全ての人に許可'),
                value: 1,
                groupValue: _selectedPermission,
                dense: true,
                onChanged: (int? value) {
                  setState(() {
                    DB_groupcreate_page.allPermitButton();

                    _selectedPermission = value;
                    _selectperson = false;
                  });
                },
              ),
              RadioListTile<int>(
                title: const Text('許可しない'),
                value: 2,
                groupValue: _selectedPermission,
                dense: true,
                onChanged: (int? value) {
                  setState(() {
                    DB_groupcreate_page.notAllPermitButton();

                    _selectedPermission = value;
                    _selectperson = false;
                  });
                },
              ),
              RadioListTile<int>(
                title: const Text('許可する人を選択する'),
                value: 3,
                groupValue: _selectedPermission,
                dense: true,
                onChanged: (int? value) {
                  setState(() {
                    DB_groupcreate_page.selectionPermitButton();

                    _selectedPermission = value;
                    _selectperson = true;
                  });
                },
              ),
              Visibility(
                visible: _selectperson,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: _selectedPermission == 3
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SelectPerson(),
                                    ),
                                  );
                                }
                              : null,
                          icon: const Icon(
                            Icons.add_circle_outline,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          'add person',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    // グループを作成する関数
                    DB_groupcreate_page
                        .createGroup(); // DB_groupcreate_pageのcreateGroup関数を実行

                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 50),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
