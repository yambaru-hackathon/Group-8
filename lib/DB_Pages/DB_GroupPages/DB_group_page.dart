import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ
import 'package:flutter/material.dart';               

class DB_group_page_class {

  final db = FirebaseFirestore.instance;                // dbの初期化

  // 絞り込み検索のread関数
  Future<void> readGroupSearch(value) async {           
    final snapshot = await db.collection('Group')       // Groupテーブルにある
      .where('group_name', isEqualTo: value)            // 入力されたvalueがgroup_nameと一致する場合のみ
      .orderBy('group_id', descending: true)            // Group_idで降順
      .limit(10)                                        // 10だけ表示
      .get();

    // 見つかったグループを全部つなげて文字にする
    String group_name = snapshot.docs.isNotEmpty
    ? snapshot.docs.first.data()['group_name'].toString()
    : '';                                                                 // もしドキュメントが見つからなかった場合は空文字列を返す

    if(group_name.isNotEmpty == true){                                    // GroupIDが空じゃなかったら

      debugPrint(group_name);                                             // 表示
      
    } 
    else {                                                                // 空なら
      debugPrint('該当するグループが見つかりませんでした');
    }
  } 
}  