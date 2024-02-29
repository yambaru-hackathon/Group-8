import 'package:cloud_firestore/cloud_firestore.dart'; // firebaseに接続するパッケージ
import 'package:flutter/material.dart';

class DB_search_page_class {
  final db = FirebaseFirestore.instance; // dbの初期化
  int? userAttribute;

  void JudgeSearch(value) {
    if (value.isEmpty) {
      return;
    }
    String firstCharacter = value.substring(0, 1);

    switch (firstCharacter) {
      case '@':
        readGroupSearch(value.substring(
          1,
        ));
        break;

      case '#':
        readPlaceSearch(value.substring(
          1,
        ));
        break;

      case '*':
        debugPrint(value);
        if (value.substring(
              1,
            ) ==
            '学生') {
          userAttribute = 0;
        } else if (value.substring(
              1,
            ) ==
            '教員') {
          userAttribute = 1;
        }
        readAttributeSearch(userAttribute);
        break;
      default:
        readPersonSearch(value);
        break;
    }
  }

  // グループ検索関数
  Future<void> readGroupSearch(value) async {
    final snapshot = await db
        .collection('Group') // Groupテーブルにある
        .where('group_name', isEqualTo: value) // 入力されたvalueがgroup_nameと一致する場合のみ
        .orderBy('group_id', descending: true) // Group_idで降順
        .limit(10) // 10だけ表示
        .get();

    // 見つかったグループを全部つなげて文字にする
    String groupName = snapshot.docs.isNotEmpty
        ? snapshot.docs.first.data()['group_name'].toString()
        : ''; // もしドキュメントが見つからなかった場合は空文字列を返す

    if (groupName.isNotEmpty == true) {
      // GroupIDが空じゃなかったら

      debugPrint(groupName); // 表示
    } else {
      // 空なら
      debugPrint('該当するグループが見つかりませんでした');
    }
  }

  // 場所検索関数
  Future<void> readPlaceSearch(value) async {
    debugPrint('場所検索関数');
    final snapshot = await db
        .collection('MapPlace') // MapPlaceテーブルにある
        .where('place_name', isEqualTo: value) // 入力されたvalueがplace_nameと一致する場合のみ
        .orderBy('place_id', descending: true) // place_idで降順
        .limit(10) // 10だけ表示
        .get();

    // 見つかった場所を全部つなげて文字にする
    String placeName = snapshot.docs.isNotEmpty
        ? snapshot.docs.first.data()['place_name'].toString()
        : ''; // もしドキュメントが見つからなかった場合は空文字列を返す

    if (placeName.isNotEmpty == true) {
      // placeIDが空じゃなかったら
      debugPrint(placeName); // 表示
    } else {
      // 空なら
      debugPrint('該当する場所が見つかりませんでした');
    }
  }

  // 属性検索関数
  Future<void> readAttributeSearch(value) async {
    debugPrint(value);
    final snapshot = await db
        .collection('User_info') // User_infoテーブルにある
        .where('user_attribute_id',
            isEqualTo: value) // 入力されたvalueがattributeと一致する場合のみ
        .orderBy('user_info_id', descending: true) // user_info_idで降順
        .limit(10) // 10だけ表示
        .get();

    final userData =
        snapshot.docs.map((doc) => doc.data()['user_name']).toList();

    var userList = List<String>.from(userData);

    if (userList.isNotEmpty == true) {
      // UserIDが空じゃなかったら
      for (String userData in userList) {
        debugPrint(userData); // 表示
      }
    } else {
      // 空なら
      debugPrint('検索した属性該当する人物が見つかりませんでした');
    }
  }

  // 場所検索関数
  Future<void> readPersonSearch(value) async {
    final snapshot = await db
        .collection('User_info') // User_infoテーブルにある
        .where('user_name', isEqualTo: value) // 入力されたvalueがuser_nameと一致する場合のみ
        .orderBy('user_info_id', descending: true) // user_info_idで降順
        .limit(10) // 10だけ表示
        .get();

    // 見つかったグループを全部つなげて文字にする
    String userName = snapshot.docs.isNotEmpty
        ? snapshot.docs.first.data()['user_name'].toString()
        : ''; // もしドキュメントが見つからなかった場合は空文字列を返す

    if (userName.isNotEmpty == true) {
      // userNameが空じゃなかったら

      debugPrint(userName); // 表示
    } else {
      // 空なら
      debugPrint('該当する人物が見つかりませんでした');
    }
  }
}
