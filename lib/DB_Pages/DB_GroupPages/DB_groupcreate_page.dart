import 'package:flutter/material.dart';                 // flutterを記述する上で必要なパッケージ
import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ

class GroupCreatePageClass {

  final db = FirebaseFirestore.instance;    // Firestore のインスタンスを取得

  List<String> authority = [];              // 権限
  String groupIcon = 'テスト画像';           // グループのアイコン
  int groupId = -1;                         // グループID
  List<int> groupMembersUserId = [];        // 加入メンバーid
  String groupName = '';                    // 新しく作るグループの名前

  bool allPermit = false;                   // 全ての人に許可             
  bool notAllPermit = false;                // 全ての人に許可しない
  bool selectionPermit = false;             // 許可する人を選択する

  // 入力されたグループ名を追加する関数
  Future<void> addGroupName(value) async {                // valueは入力された名前

    final snapshot = await db.collection('Group')         // Groupテーブルにある
      .where('group_name', isEqualTo: value)              // 入力された名前が既に使用されていた場合
      .limit(1)                                           // 1つのテーブルだけ取得
      .get();                                             // 合致したテーブルの情報を取得

    // もしドキュメントが見つからなかった場合は空文字列を返す
    groupName = snapshot.docs.isNotEmpty
    ? snapshot.docs.first.data()['group_name']
    : '';                                                      

    // 文字列が空じゃない(既に使用されている)
    if(groupName.isNotEmpty == true) {                         

      debugPrint('既にこのグループ名は使用されています');

    // 文字列が空(まだ使用されていない)
    } else {    
                                                                 
      groupName = value;
      debugPrint('グループ名を$groupNameに設定しました'); 

    }
  }

  // 入力されたユーザーを追加する関数
  Future<void> addUserId(value) async {            

    final snapshot = await db.collection('User_info')     // User_infoテーブルにある
    .where('user_name', isEqualTo: value)                 // 入力されたユーザー名が存在する場合のみ
    .orderBy('user_info_id', descending: true)            // user_info_idで降順
    .limit(1)                                             // 1つのテーブルだけ取得
    .get();                                               // 合致したテーブルの情報を取得

    int? groupMembersUserIdHolder;                        // 一時的に追加するユーザーidを保持する変数              

    // もしドキュメントが見つからなかった場合は空文字列を返す
    groupMembersUserIdHolder = snapshot.docs.isNotEmpty
      ? snapshot.docs.first.data()['user_info_id']
      : null;

    // 既にユーザーが追加されていたら
    if(groupMembersUserId.contains(groupMembersUserIdHolder)) {   

      debugPrint('既にこのユーザーは追加されています');

    }

    // 入力したユーザーが存在したら
    else if(groupMembersUserIdHolder != null){ 

      debugPrint('$valueを作成予定のグループに追加しました');
      groupMembersUserId.add(groupMembersUserIdHolder);       // add_user_info_idにuser_info_idを格納
      groupMembersUserIdHolder = null;                        // 追加した後、nullで初期化

    }

    // 入力したユーザー名が存在しない
    else {                                                               
      debugPrint('該当するユーザーが見つかりませんでした');
    }

  }

  // 全ての人に許可を押した時
  void allPermitButton () {

    allPermit = true;
    notAllPermit = false;
    selectionPermit = false;

  }

  // 全ての人に許可しないを押した時
  void notAllPermitButton () {

    allPermit = false;
    notAllPermit = true;
    selectionPermit = false;
    
  }

  // 許可する人を選択を押した時
  void selectionPermitButton () {

    allPermit = false;
    notAllPermit = false;
    selectionPermit = true;
    
  }

  // グループを作成する関数
  Future<void> createGroup() async {

    if (allPermit == true) {

      for(int i = 0; i < groupMembersUserId.length; i++) {

        authority.add('管理者');

      }

    } else if (notAllPermit == true) {

      for(int i = 0; i < groupMembersUserId.length; i++) {

        authority.add('メンバー');

      }

    } else if (selectionPermit == true) {

      for(int i = 0; i < groupMembersUserId.length; i++) {

        authority.add('選択して許可');

      }

    }

    final snapshot = await db.collection('Group')       // Groupテーブルにある
      .orderBy('group_id', descending: true)            // group_idで降順
      .limit(1)                                         // 1つのテーブルだけ取得
      .get();                                           // 合致したテーブルの情報をを取得

      // もしドキュメントが見つからなかった場合は-1を返す
      final maxGroupId = snapshot.docs.isNotEmpty
        ? snapshot.docs.first.data()['group_id']
        : -1;

      // 必要な情報が入力されているか確認
      if (
        authority.isNotEmpty                        // 
        &&groupIcon != ''                           // アイコンが設定されている
        && groupMembersUserId.isNotEmpty            // メンバーが追加されている
        && groupName != ''                          // グループ名が設定されている
        ) {

        // group_idが割り振られていない(最初に作成されたグループ)
        if(maxGroupId == -1) {               
          
          // group_idに0を割り振る
          groupId = 0;                         

        } else {

          // 新しいグループにgroup_idを割り振る
          groupId = maxGroupId + (1);        

        }

      // 必要な情報が入力されていなかった場合、関数をここで終了
      } else {

        debugPrint('グループの作成に失敗');

        // グループを作成に失敗した後、変数を初期化
        authority = [];                           // 権限
        groupIcon = 'テスト画像';                 // グループのアイコン
        groupId = -1;                             // グループID
        groupMembersUserId = [];                  // 加入メンバーid
        groupName = '';                           // 新しく作るグループの名前

        allPermit = false;                        // 全ての人に許可             
        notAllPermit = false;                     // 全ての人に許可しない
        selectionPermit = false;                  // 許可する人を選択する

        return;

      }

    // グループの作成
    await db.collection('Group').doc().set(
      {
        'authority':          authority,
        'group_icon':         groupIcon,
        'group_id':           groupId,
        'group_member_id':    groupMembersUserId,
        'group_name':         groupName,
      },
    );

    debugPrint('グループ：$groupNameを作成しました');

    //グループを作成した後、変数を初期化
    authority = [];                       // 権限
    groupIcon = 'テスト画像';              // グループのアイコン
    groupId = -1;                         // グループID
    groupMembersUserId = [];              // 加入メンバーid
    groupName = '';                       // 新しく作るグループの名前

    allPermit = false;                    // 全ての人に許可             
    notAllPermit = false;                 // 全ての人に許可しない
    selectionPermit = false;              // 許可する人を選択する


  }

  // // "back"が押された時(グループの作成をキャンセルした時)、入力情報を初期化
  // void resetInfo() {

  //   debugPrint('動作確認テスト');

  //   // グループの作成をキャンセルした時、変数を初期化
  //   authority = [];                               // 権限
  //   groupIcon = 'テスト画像';                      // グループのアイコン
  //   groupId = -1;                                 // グループID
  //   groupMembersUserId = [];                      // 加入メンバーid
  //   groupName = '';                               // 新しく作るグループの名前

  // }

}
