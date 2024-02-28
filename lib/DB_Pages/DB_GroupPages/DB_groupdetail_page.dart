import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DB_groupdetail_page_class {

  final db = FirebaseFirestore.instance;                // dbの初期化

  List<String> authority = ['メンバー','メンバー'];  // 権限
  String group_icon = 'テスト画像';                  // group_icon
  int group_id = 0;                                 // group_id
  List<int> group_members_user_id = [];             // 加入メンバーid
  String group_name = '';                           // 新しく作るグループの名前

  // 絞り込み検索のread関数
  Future<String> readGroupSearch(value) async {         // valueは入力された値
    final snapshot = await db.collection('Group')       // Groupテーブルにある
      .where('group_name', isEqualTo: value)            // 入力されたvalueがgroup_nameと一致する場合のみ
      .orderBy('group_id', descending: true)            // group_id降順
      .limit(1)                                         // 1つ合致で探索終了
      .get();

    group_name = snapshot.docs.isNotEmpty
    ? snapshot.docs.first.data()['group_name'].toString()
    : '';                                                      // もしドキュメントが見つからなかった場合は空文字列を返す

    if(group_name.isNotEmpty == true){                         
      // GroupIDが空じゃなかったら
      debugPrint('既にこのグループ名は使用されています');        // 表示

      return '';

    } else {    
                                                                 
      group_name = value;
      debugPrint('グループ名を$group_nameに設定しました'); 

      return group_name;
    }
  }

  // void get_id(add_user_info_id) {
  //   print(add_user_info_id);
  //   this.group_members_user_id = add_user_info_id;
  // }

  // void get_id(add_user_info_id) {
  //   this.group_members_user_id.addAll(add_user_info_id);
  // }

  Future<void> createGroup() async {

    print('代入確認：$group_members_user_id');

    final snapshot = await db.collection('Group')       // Groupテーブルにある
      .orderBy('group_id', descending: true)            // group_idで降順
      .limit(1)                                         // 1取得
      .get();

      final max_group_id = snapshot.docs.isNotEmpty
        ? snapshot.docs.first.data()['group_id']
        : -1;

      if (
        group_icon != ''                              // アイコンが設定されている
        && group_members_user_id.length != 0          // メンバーが追加されている
        && group_name != ''                           // グループ名が設定されている
        ) {

        if(max_group_id == -1) {                // group_idが割り振られていない(最初に作成されたグループ)

          group_id = 0;                         // group_idに0を割り振る

        } else {

          group_id = max_group_id + (1);        // 新しいグループにgroup_idを割り振る

        }

      } else {

        debugPrint('グループの作成に失敗');
        return;

      }

    // グループの作成
    await db.collection('Group').doc().set(
      {
        'authority':          'メンバー',
        'group_icon':         group_icon,
        'group_id':           group_id,
        'members_member_id':  group_members_user_id,
        'group_name':         group_name,
      },
    );

    debugPrint('グループ：$group_nameを作成しました');

    //グループを作成した後、変数を初期化
    authority = [];                  // 権限
    group_icon = 'テスト画像';       // group_icon
    group_id = 0;                    // group_id
    group_members_user_id = [];      // 加入メンバーid
    group_name = '';                 // 新しく作るグループの名前

  }
}  
                
