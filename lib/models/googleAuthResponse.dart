import 'dart:convert';

import 'package:ibh/models/login_model.dart';

GoogleAuth googleAuthFromJson(String str) =>
    GoogleAuth.fromJson(json.decode(str));
String googleAuthToJson(GoogleAuth data) => json.encode(data.toJson());

class GoogleAuth {
  bool success;
  String message;
  UserData data;

  GoogleAuth({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GoogleAuth.fromJson(Map<String, dynamic> json) => GoogleAuth(
        success: json["success"],
        message: json["message"],
        data: UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class UserData {
  User user;

  UserData({required this.user});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}
