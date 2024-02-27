import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goup8_app/DB_Pages/DB_GroupPages/DB_group_page.dart';
import 'package:goup8_app/Pages/GroupPages/selectperson_page.dart';
import 'package:goup8_app/DB_Pages/DB_GroupPages/DB_groupdetail_page.dart'; //DB関数のインポート

class NewGroupDetail extends StatefulWidget {
  const NewGroupDetail({Key? key}) : super(key: key);

  @override
  _NewGroupDetailState createState() => _NewGroupDetailState();
}

class _NewGroupDetailState extends State<NewGroupDetail> {

  final DB_groupdetail_page = DB_groupdetail_page_class();  //  DB_groupdetail_pageのDB_groupdetail_page_class()を参照

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
                           // 検索部分
                          if(value.isEmpty != true) {                                 
                            // エンターキーを押した時文字列が空じゃないなら
                            DB_groupdetail_page.readGroupSearch(value);               // DB_groupdetail_pageのreadGroupSearch(value)関数を実行

                          }
                          // 検索部分
                        },
                      ),
                    ),
                  ],
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

                    DB_groupdetail_page.createGroup();                          //  DB_groupdetail_pageのcreateGroup()関数を実行

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
