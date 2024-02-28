import 'package:cloud_firestore/cloud_firestore.dart'; // firebaseに接続するパッケージ
import 'package:flutter/material.dart';

class DB_group_page_class {
  final db = FirebaseFirestore.instance; // dbの初期化

  Future<void> readGroupSearch(value) async {
    // 絞り込み検索のread関数
    final snapshot = await db
        .collection('GroupID')
        .where('name', isEqualTo: value) // DBにあるグループ名と一致する場合のみ
        .orderBy('authority') // 名前順
        .limit(10) // 10だけ表示
        .get();

    // 見つかったグループを全部つなげて文字にする
    final docs = snapshot.docs.map(
      (doc) => doc.data().toString(),
    );
    final GroupID = docs.join();
    if (GroupID.isEmpty == false) {
      // GroupIDが空じゃなかったら
      debugPrint(GroupID); // 表示
    } else {
      // 空なら
      debugPrint('該当するグループが見つかりませんでした');
    }
  }
}
