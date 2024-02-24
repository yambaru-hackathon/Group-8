// import 'dart:ffi'「 Future<Void> createGroup() async { 」この関数が恐らく原因

import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ
import 'package:flutter/material.dart';
import 'package:goup8_app/DB_Pages/DB_GroupPages/DB_addgroupmenber_page.dart'; // DB関数のインポート 変数の引き渡しに使用

class DB_groupdetail_page_class {

  final db = FirebaseFirestore.instance;                // dbの初期化
  DB_addgroupmember_page_class DB_addgroupmember_page = DB_addgroupmember_page_class();

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

      debugPrint('既にこのグループ名は使用されています');                   // 表示
      
    } 
    else {                                                                // 空なら
      debugPrint('このグループ名は使用可能です');
    }

    /* 作成ボタンの動作

    Future<Void> createGroup() async {

      await db.collection('Groups').doc().set(
        {
          'group_icon': 'テスト画像',
          'group_name': '$group_name',
          'members_member_id': 'members_member_id',
          'authority': 'authority',
        },
      );
    }

    */

  } 
}  

/* groupdetail_page.dartの検索バー

// テスト検索部分
if(value.isEmpty != true) {                               // エンターキーを押した時文字列が空じゃないなら
final DB_groupdetail_page = DB_groupdetail_page_class();  // DB_group_pageのDB_group_page_classを参照
DB_groupdetail_page.readGroupSearch(value);               // DB_group_pageのreadGroupSearch(value)関数を実行
}
// テスト検索部分

*/
                