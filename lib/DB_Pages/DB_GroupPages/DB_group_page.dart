import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ
import 'package:flutter/material.dart';               

class DB_group_page_class {

  final db = FirebaseFirestore.instance;                // dbの初期化

  Future<void> readGroupSearch(value) async {           // 絞り込み検索のread関数
    final snapshot = await db.collection('Group')       // Groupテーブルにある
      .where('group_name', isEqualTo: value)            // 入力されたvalueがgroup_nameと一致する場合のみ
      .orderBy('authority')                             // 権限順
      .limit(10)                                        // 10だけ表示
      .get();

    // 見つかったグループを全部つなげて文字にする
    final group_name_docs = snapshot.docs.map(                            // 各ドキュメントから'group_name'フィールドを取得し、文字列に変換してリストにマップする
      (group_name_doc) => group_name_doc.data()['group_name'].toString(), // (カラム名_doc) => カラム名_doc.data()['取りたいカラム'].toString(),
    );

    final group_name = group_name_docs.join();                            // リストの要素を結合して1つの文字列にする final カラム名 = カラム名_docs.join();
    if(group_name.isEmpty == false){                                      // GroupIDが空じゃなかったら

      debugPrint(group_name);                                             // 表示
      
    } 
    else {                                                                // 空なら
      debugPrint('該当するグループが見つかりませんでした');
    }
  } 
}  