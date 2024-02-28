import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Account',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.account_circle,
                    size: 70,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'Usere Name',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          // ここから
          const Divider(
            color: Colors.grey,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 10,
              bottom: 10,
            ),
            child: const Row(
              children: [
                Text(
                  '選択地域',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 30,
                ),
                Spacer(),
                Text(
                  '沖縄工業高等専門学校',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
          // ここまではテンプレなので、情報を追加できるならここを引用してUIを制作
          const Divider(
            color: Colors.grey,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 10,
              bottom: 10,
            ),
            child: const Row(
              children: [
                Text(
                  '属性',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 30,
                ),
                Spacer(),
                Text(
                  '生徒',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
