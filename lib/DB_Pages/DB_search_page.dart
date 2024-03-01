import 'package:cloud_firestore/cloud_firestore.dart'; // firebaseに接続するパッケージ
import 'package:flutter/material.dart';

class SearchPageClass {
  final db = FirebaseFirestore.instance; // Firestore のインスタンスを取得

  String returnGroupName = ''; // グループ名
  String returnPlaceName = ''; // 場所の名前
  List<String> returnAttributeName = []; // 属性に一致するユーザー

  // グループを検索する関数
  Future<String> searchGroup(String value) async {
    value = value.substring(1);

    final snapshot = await db
        .collection('Group') // Groupテーブルにある
        .where('group_name', isEqualTo: value) // 入力されたグループ名が存在する場合のみ
        .limit(1) // 1つのテーブルだけ取得
        .get(); // 合致したテーブルの情報を取得

    returnGroupName = snapshot.docs.isNotEmpty
        ? snapshot.docs.first.data()['group_name']
        : '';

    if (returnGroupName.isNotEmpty) {
      return returnGroupName;
    } else {
      return '';
    }
  }

  // 場所を検索する関数
  Future<String> searchPlace(String value) async {
    value = value.substring(1);

    final snapshot = await db
        .collection('MapPlace') // MapPlaceテーブルにある
        .where('place_name', isEqualTo: value) // 入力された場所が存在する場合のみ
        .limit(1) // 1つのテーブルだけ取得
        .get(); // 合致したテーブルの情報を取得

    returnPlaceName = snapshot.docs.isNotEmpty
        ? snapshot.docs.first.data()['place_name']
        : '';

    if (returnPlaceName.isNotEmpty) {
      return returnPlaceName;
    } else {
      return '';
    }
  }

  // 属性を元にユーザーを検索する関数
  Future<List<String>> searchAttribute(String value) async {
    value = value.substring(1);

    final AttributeId = await db
        .collection('Attribute') // Attributeテーブルにある
        .where('attribute_name', isEqualTo: value) // 入力された属性が存在する場合のみ
        .limit(1) // 1つのテーブルだけ取得
        .get(); // 合致したテーブルの情報を取得

    final attributeIdHolder = AttributeId.docs.isNotEmpty
        ? AttributeId.docs.first.data()['attribute_id']
        : '';

    final UserAttributeId = await db
        .collection('User_info') // User_infoテーブルにある
        .where('user_attribute_id',
            isEqualTo: attributeIdHolder) // 入力された属性のユーザーが存在する場合のみ
        .limit(10) // 10個のテーブルだけ取得
        .get(); // 合致したテーブルの情報を取得

    final UserAttributeName =
        UserAttributeId.docs.map((doc) => doc.data()['user_name']).toList();

    returnAttributeName = List<String>.from(UserAttributeName);

    if (returnAttributeName.isNotEmpty) {
      return returnAttributeName;
    } else {
      return [];
    }
  }
}