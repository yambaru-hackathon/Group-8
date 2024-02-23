import 'package:flutter/material.dart';

class NewGroupDetail extends StatelessWidget {
  const NewGroupDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '新しいグループを作成',
        ),
      ),
    );
  }
}
