import 'package:flutter/material.dart';

class NewGroupDetail extends StatefulWidget {
  const NewGroupDetail({Key? key}) : super(key: key);

  @override
  _NewGroupDetailState createState() => _NewGroupDetailState();
}

class _NewGroupDetailState extends State<NewGroupDetail> {
  int? _selectedPermission;

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
                const Flexible(
                  child: TextField(
                    maxLength: 20,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "グループ名を入力",
                      labelText: "Group Name",
                    ),
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
              });
            },
          ),
          const Expanded(child: SizedBox.shrink()),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {},
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
          )
        ],
      ),
    );
  }
}
