import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ
import 'package:flutter/material.dart';
import 'package:goup8_app/DB_Pages/DB_GroupPages/DB_groupdetail_page.dart'; //DB関数のインポート

List<int> add_user_info_id = [];  

class DB_addgroupmember_page_class {

  final db = FirebaseFirestore.instance;                // dbの初期化                

  // 絞り込み検索のread関数
  Future<void> readUserSearch(value) async {            
    final snapshot = await db.collection('User_info')   // User_infoテーブルにある
      .where('user_name', isEqualTo: value)             // 入力されたvalueがuser_nameと一致する場合のみ
      .orderBy('user_info_id', descending: true)        // user_info_idで降順
      .limit(10)                                        // 10個だけ表示
      .get();

    List<int> user_info_id = [];
    
    final user_info_id_docs = snapshot.docs.map(                              // 各ドキュメントから'group_name'フィールドを取得し、マップする
      (user_info_id_doc) => user_info_id_doc.data()['user_info_id'] as int,   // (カラム名_doc) => カラム名_doc.data()['取りたいカラム'] as int(int型に変換),
    ).toList();

    user_info_id.addAll(user_info_id_docs);

    user_info_id.forEach((user_info_id) {                      
      debugPrint('$user_info_id');
    });

    if(add_user_info_id.contains(user_info_id) == true){                 // 既に配列の中にidがあったら
      debugPrint('既にこのユーザーは追加されています');
    }

    else if(user_info_id.isNotEmpty == true){                            // idが空じゃなかったら
      debugPrint('$valueを作成予定のグループに追加しました');
      add_user_info_id.addAll(user_info_id);                             // 配列に追加するユーザーidを格納                
    } 

    else {                                                               // 一致したユーザー名が無い
      debugPrint('該当するユーザーが見つかりませんでした');
    }
  }

  // "back"が押された時ユーザー情報を初期化
  void reset_add_user_info_id() {                                
    add_user_info_id = [];
    add_user_info_id.forEach((add_user_info_id) {                       // 初期化されているか確認
      debugPrint('テスト：$add_user_info_id');
    });
  }

  // "next"が押された時ユーザー情報を渡す
  void set_add_user_info_id() async{
    
    add_user_info_id = add_user_info_id.toSet().toList();
    List<String> add_user_info_name = [];

    debugPrint('追加したメンバー');

    for(int i = 0; i < add_user_info_id.length; i++) {
      final snapshot = await db.collection('User_info')             // Groupテーブルにある
        .where('user_info_id', isEqualTo: add_user_info_id[i])      // 入力されたvalueがgroup_nameと一致する場合のみ
        .orderBy('user_info_id', descending: true)                  // user_info_id降順
        .limit(1)                                                   // 1つ合致で探索終了
        .get();

      String name_holder = (snapshot.docs.isNotEmpty
      ? snapshot.docs.first.data()['user_name'].toString()
      : '');                                                        // もしドキュメントが見つからなかった場合は空文字列を返す
      
      add_user_info_name[i] = name_holder;                                                        
    }
      add_user_info_name.forEach((add_user_info_name) {
      debugPrint('$add_user_info_name');
    });

    final DB_groupdetail_page = DB_groupdetail_page_class();    // DB_groupdetail_pageのDB_groupdetail_page_classを参照
    DB_groupdetail_page.get_id(add_user_info_id);               // DB_groupdetail_pageのreadUserSearch(value)関数を実行
  }
}

