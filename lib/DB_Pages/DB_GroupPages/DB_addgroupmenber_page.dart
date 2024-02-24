import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ
import 'package:flutter/material.dart';
import 'package:goup8_app/DB_Pages/DB_GroupPages/DB_groupdetail_page.dart'; //DB関数のインポート

class DB_addgroupmember_page_class {

  final db = FirebaseFirestore.instance;                // dbの初期化
  String add_user_id = '';                            // add_user_nameの初期化

  Future<void> readUserSearch(value) async {            // 絞り込み検索のread関数
    final snapshot = await db.collection('User')        // Userテーブルにある
      .where('user_name', isEqualTo: value)             // 入力されたvalueがuser_nameと一致する場合のみ
      .orderBy('attribute')                             // 属性順
      .limit(10)                                        // 10個だけ表示
      .get();

    // 見つかったグループを全部つなげて文字にする
    final id_docs = snapshot.docs.map(
      (id_doc) => id_doc.data()['id'].toString(),       // 各ドキュメントから'id'フィールドを取得し、文字列に変換してリストにマップする
    );                                                  // (カラム名_doc) => カラム名_doc.data()['取りたいカラム'].toString(),
    final id = id_docs.join();                          // リストの要素を結合して1つの文字列にする final カラム名 = カラム名_docs.join();                 

    if(id.isEmpty == false){                                // idが空じゃなかったら
      debugPrint('$valueを作成予定のグループに追加しました'); // 表

      add_user_id += id;

    } 
    else {                                                  // 空なら(一致したユーザー名が無い)
      debugPrint('該当するユーザーが見つかりませんでした');
    }
  }

  /* 変数の引き渡し

  Future<void> async {
    final DB_groupdetail_page = DB_groupdetail_page_class();          // DB_group_pageのDB_group_page_classを参照
    DB_groupdetail_page.createGroup(add_user_id); 
  }

  */

}

