import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ
import 'package:flutter/material.dart';

class MapPageClass {

  final db = FirebaseFirestore.instance;                // dbの初期化

  List<String> userList = [];

  String QRText = '';

  List<String> groupNames = [];

  Map<String, List<dynamic>> scheduleInfo = {
    'groupName': [],
    'dateTime': [],
  };

  // タップしたピンにいるユーザーを表示する関数
  Future<List<String>> viewUserList(value) async {           
    final snapshotUserName = await db.collection('User_info')   // User_infoコレクションの
      .where('user_place_id', isEqualTo: value)                 // タップしたピンのuser_place_idのテーブルのみ取得
      .get();

    // もしドキュメントが見つからなかった場合は空文字列を返す
    final userData = snapshotUserName.docs.map((doc)
                  => doc.data()['user_name']).toList();

    userList = List<String>.from(userData);

    final snapshotPlaceName = await db.collection('MapPlace')   // MapPlaceコレクションの
      .where('place_id', isEqualTo: value)                      // タップしたピンのplace_idのテーブルのみ取得
      .get();                                                   

    final placeName = snapshotPlaceName.docs.isNotEmpty
    ? snapshotPlaceName.docs.first.data()['place_name']
    : '';

    // タップしたピンにユーザーがいたら
    if(userList.isNotEmpty){                                    

      debugPrint('$placeName所在のユーザー');

      userList.forEach((userList) {

        debugPrint('$userList');  

      });

      return userList;

    } 

    // タップしたピンにユーザーがいなかったら
    else {

      debugPrint('現在所在しているユーザーはいません');

      return [];

    }
    
  }

  Future<Map<String, List<dynamic>>?> getScheduleInfo(value) async {

    final snapshotPlaceName = await db.collection('MapPlace')       // MapPlaceコレクションの
      .where('place_id', isEqualTo: value)                          // タップしたピンのplace_idのテーブルのみ取得
      .get();                                                   

    // place_nameに該当するidの名前を保存
    final placeName = snapshotPlaceName.docs.isNotEmpty               
    ? snapshotPlaceName.docs.first.data()['place_name'] as String
    : '';

    final Schedule = await db.collection('Schedule')                // Scheduleコレクションの
      .where('schedule_location', isEqualTo: placeName)             // タップしたピンの場所を使用する予定を取得
      .orderBy('date', descending: false)
      .get();

    // タップしたピンを使用するグループが無かったら処理終了
    if(Schedule.docs.isEmpty) {
      return null;
    }

    // 予定があったら使用するグループのidを取得
    final groupIDHolder = Schedule.docs.map((doc)
                  => doc.data()['schedule_group_id'] as int).toList();

    for(int i = 0; i < groupIDHolder.length; i++){

      final Group = await db.collection('Group')                  // MapPlaceコレクションの
        .where('group_id', isEqualTo: groupIDHolder[i])           // groupIDHolderと一致するグループのテーブルのみ取得
        .get();

      // グループ名を取得
      final groupName = Group.docs.map((doc)
                    => doc.data()['group_name'].toString()).toList();

      groupNames.addAll(groupName); // グループ名をリストに追加

    }

    scheduleInfo['groupName'] = List<String>.from(groupNames);

    groupNames.clear();                                           

    // 日時を取得
    final dateTimeHolder = Schedule.docs.map((doc)
                  => (doc.data()['date'] as Timestamp).toDate()).toList();                                                   

    scheduleInfo['dateTime'] = List<DateTime>.from(dateTimeHolder);

    if(scheduleInfo.isNotEmpty) {

      return scheduleInfo;

    }

    else {

      return null;

    }

  }
}