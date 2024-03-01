import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  final List<String> dataList;
  const SearchResultsPage({super.key, required this.dataList});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          '検索結果',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ListTile(
                title: Center(
                  child: Text(
                    dataList[index],
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              )
            ],
          );
        },
      ),
    );
  }
}
