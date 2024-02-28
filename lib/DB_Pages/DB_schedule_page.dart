import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ
import 'package:flutter/material.dart';

class SchedulePageClass {

  final db = FirebaseFirestore.instance; // Firestore のインスタンスを取得

  DateTime dateString = DateTime(0);      // 日付
  int? scheduleGroupId;                   // 追加するグループ
  int scheduleId = -1;                    // スケジュールID 
  String scheduleLocation = '';           // 場所
  List<int> scheduleMembersUserId = [];   // 追加するメンバー
  String scheduleName = '';               // タイトル

  // タイトルを追加する関数
  void addTitle (value) {
    scheduleName = value;
    debugPrint('Title:$scheduleName');
  }

  // 場所を追加する関数
  void addLocation (value) {
    scheduleLocation = value;
    debugPrint('Location:$scheduleLocation');
  }

  // 日付を追加する関数
  void addDateTime (value) {
    dateString = DateTime.parse(value);

    if (dateString != DateTime(0)) {

      debugPrint('dateString:$dateString');

    } else {
      
      debugPrint('日付を追加できませんでした');

    }
  }

  // グループを追加する関数
  Future<void> addGroup(value) async {         

    final snapshot = await db.collection('Group')       // Groupテーブルにある
      .where('group_name', isEqualTo: value)            // 入力されたvalueがgroup_nameと一致する場合のみ
      .orderBy('group_id', descending: true)            // group_id降順
      .limit(1)                                         // 1つ合致で探索終了
      .get();

    // もしドキュメントが見つからなかった場合は空文字列を返す
    scheduleGroupId = snapshot.docs.isNotEmpty
    ? snapshot.docs.first.data()['group_id']
    : null;                                                      

    // GroupIDが空じゃなかったら
    if(scheduleGroupId != null){                         
      
      debugPrint('$valueを予定に追加しました');
    
    // GroupIDが存在しないなら
    } else {    
                                                                 
      debugPrint('$valueは存在しません');

    }

  }

  // ユーザーを追加する関数
  Future<void> addUser(value) async {            

    final snapshot = await db.collection('User_info') // User_infoテーブルにある
    .where('user_name', isEqualTo: value)             // 入力されたvalueがuser_nameと一致する場合のみ
    .orderBy('user_info_id', descending: true)        // user_info_idで降順
    .limit(1)                                         // 1つのテーブルだけ取得
    .get();

    int? addUserId;

    // もしドキュメントが見つからなかった場合は空文字列を返す
    addUserId = snapshot.docs.isNotEmpty
      ? snapshot.docs.first.data()['user_info_id']
      : null;

    // 既に追加されていたら
    if(scheduleMembersUserId.contains(addUserId)){

      debugPrint('既にこのユーザーは追加されています');

    }
    // idが存在したら
    else if(addUserId != null){ 

      debugPrint('$valueを予定に追加しました');
      scheduleMembersUserId.add(addUserId);

    }
    // 入力したユーザーが存在しなかったら
    else {                                                               
      debugPrint('該当するユーザーが見つかりませんでした');
    }

  }

  // 予定作成をキャンセルした際、変数をリセットする関数
  void resetSchedule() {

    //グループ作成に失敗後、変数を初期化
    dateString = DateTime(0);         // 日付
    scheduleGroupId;                  // 追加するグループ
    scheduleId = -1;                  // スケジュールID 
    scheduleLocation = '';            // 場所
    scheduleMembersUserId = [];       // 追加するメンバー
    scheduleName = '';                // タイトル
    
    debugPrint('予定の作成をキャンセルしました');

  }

  // 予定を作成する関数
  Future<void> createSchedule() async {

    final snapshot = await db.collection('Schedule')   // Scheduleテーブルにある
      .orderBy('schedule_id', descending: true)        // schedule_idで降順
      .limit(1)                                        // 1取得
      .get();

      int maxScheduleId = snapshot.docs.isNotEmpty
        ? snapshot.docs.first.data()['schedule_id'] 
        : -1;

      print('加算前id確認:$maxScheduleId');

      // タイトルと日付が追加されている
      if (scheduleName != '' && dateString != DateTime(0)) {
        
        // schedule_idが割り振られていない(最初に作成された予定)
        if(maxScheduleId == -1) {

          // schedule_idに0を割り振る
          scheduleId = 0;                        

        } else {

          // 新しい予定にschedule_idを割り振る
          scheduleId = maxScheduleId + (1);  

          print('加算後id確認:$scheduleId');      

        }

      } else {

        debugPrint('予定の作成に失敗');

        //予定作成に失敗後、変数を初期化
        dateString = DateTime(0);         // 日付
        scheduleGroupId;                  // 追加するグループ
        scheduleId = -1;                  // スケジュールID 
        scheduleLocation = '';            // 場所
        scheduleMembersUserId = [];       // 追加するメンバー
        scheduleName = '';                // タイトル

        return;

      }

    // 予定の作成
    await db.collection('Schedule').doc().set(
      {
        'date':                     dateString,
        'schedule_group_id':        scheduleGroupId,
        'schedule_id':              scheduleId,
        'schedule_location':        scheduleLocation,
        'schedule_members_user_id': scheduleMembersUserId,
        'schedule_name':            scheduleName,
      },
    );

    debugPrint('予定：$scheduleNameを追加しました');

    //予定作成に失敗後、変数を初期化
    dateString = DateTime(0);         // 日付
    scheduleGroupId;                  // 追加するグループ
    scheduleId = -1;                  // スケジュールID 
    scheduleLocation = '';            // 場所
    scheduleMembersUserId = [];       // 追加するメンバー
    scheduleName = '';                // タイトル

  }

}
