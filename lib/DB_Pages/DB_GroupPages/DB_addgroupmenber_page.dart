import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ
import 'package:flutter/material.dart';
import 'package:goup8_app/DB_Pages/DB_GroupPages/DB_groupdetail_page.dart'; //DB関数のインポート

class DB_addgroupmember_page_class {

  final db = FirebaseFirestore.instance;                // dbの初期化 

  final DB_groupdetail_page = DB_groupdetail_page_class();    // DB_groupdetail_pageのDB_groupdetail_page_classを参照

  List<int> add_user_info_id = [];                 

  // ユーザー追加のread関数
  Future<void> readUserSearch(value) async {            

    final snapshot = await db.collection('User_info') // User_infoテーブルにある
    .where('user_name', isEqualTo: value)             // 入力されたvalueがuser_nameと一致する場合のみ
    .orderBy('user_info_id', descending: true)        // user_info_idで降順
    .limit(1)                                         // 1つのテーブルだけ取得
    .get();

    // もしドキュメントが見つからなかった場合は空文字列を返す
    int? user_info_id = (
      snapshot.docs.isNotEmpty
      ? snapshot.docs.first.data()['user_info_id']
      : null                                                           
    );

    // 既に配列の中にidがあったら
    if(this.add_user_info_id.contains(user_info_id)){                 
      debugPrint('既にこのユーザーは追加されています');
    }
    // idがnullじゃなかったら
    else if(user_info_id != null){ 
      debugPrint('$valueを作成予定のグループに追加しました');
      this.add_user_info_id.add(user_info_id);                         // add_user_info_idにuser_info_idを格納             
    }
    // 一致したユーザー名が無い
    else {                                                               
      debugPrint('該当するユーザーが見つかりませんでした');
    }

  }

  // "back"が押された時ユーザー情報を初期化
  void reset_add_user_info_id() {                                
    this.add_user_info_id = [];
    this.add_user_info_id.forEach((add_user_info_id) {       
      debugPrint('初期化されているか確認：$add_user_info_id');
    });
  }

  // "next"が押された時ユーザー情報を渡す
  void set_add_user_info_id() async{
    
    this.add_user_info_id = this.add_user_info_id.toSet().toList();
    List<String> add_user_info_name = [];

    debugPrint('追加したメンバー');

    //idを１つずつ検索して名前を取得
    for(int i = 0; i < this.add_user_info_id.length; i++) {
      final snapshot = await db.collection('User_info')             // Groupテーブルにある
        .where('user_info_id', isEqualTo: add_user_info_id[i])      // 入力されたvalueがgroup_nameと一致する場合のみ
        .limit(1).get();                                            // 1つ合致で探索終了

      // もしドキュメントが見つからなかった場合は空文字列を返す
      String name_holder = (
        snapshot.docs.isNotEmpty
        ? snapshot.docs.first.data()['user_name']
        : ''                                                        
      );                                                        
      // add_suer_info_nameにnme_holderを格納
      add_user_info_name.add(name_holder);                                                        
    }
      // メンバーを配列１つずつ表示
      add_user_info_name.forEach((add_user_info_name) {
      debugPrint('$add_user_info_name');
    });

    this.add_user_info_id.forEach((add_user_info_id) {
      debugPrint('$add_user_info_id');
    });

    final DB_groupdetail_page = DB_groupdetail_page_class();    // DB_groupdetail_pageのDB_groupdetail_page_classを参照
    DB_groupdetail_page.get_id(add_user_info_id);               // DB_groupdetail_pageのreadUserSearch(value)関数を実行

    // DB_groupdetail_page.get_id(add_user_info_id); 

  }

  
}

