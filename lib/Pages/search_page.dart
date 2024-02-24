import 'package:flutter/material.dart';

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
                    hintText: '@ ステータス   # 場所',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                  ),
                  // 入力された値を保存
                  // onSubmitted: (text) => _submission(text),
                  onSubmitted: (value) => (),
                ),
              ),
            ),
          ),
        ));
  }
}
