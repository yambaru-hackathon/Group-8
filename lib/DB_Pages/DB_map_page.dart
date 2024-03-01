import 'package:cloud_firestore/cloud_firestore.dart';  // firebaseに接続するパッケージ
import 'package:flutter/material.dart';

class MapPageClass {

  final db = FirebaseFirestore.instance;                // dbの初期化

  List<String> userList = [];

  String QRText = '';

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

}