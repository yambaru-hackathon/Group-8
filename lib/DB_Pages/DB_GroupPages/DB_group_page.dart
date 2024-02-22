import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';                 // firebaseに接続するパッケージ

class DB_group_page_class {

  final db = FirebaseFirestore.instance;                // dbの初期化

  Future<void> readGroupSearch(value) async {           // 絞り込みのread関数
    final snapshot = await db.collection('GroupID')
      .where('name', isEqualTo: value)                  // テスト団体のみ
      .orderBy('authority')                                  // 名前順
      .limit(10)                                        // 10だけ表示
      .get();

    // 見つかったグループを全部つなげて文字にする
    final docs = snapshot.docs.map(
      (doc) => doc.data().toString(),
    );
    final GroupID = docs.join();
    if(GroupID.isEmpty == false){
      debugPrint(GroupID);
    } else {
      debugPrint('該当するグループが見つかりませんでした');
    }
    
  } 
}  