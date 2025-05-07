import 'dart:convert';

import 'package:ibh/models/login_model.dart';

AppUpdateModel appUpdateModelFromJson(String str) =>
    AppUpdateModel.fromJson(json.decode(str));

String appUpdateModelToJson(AppUpdateModel data) => json.encode(data.toJson());

class AppUpdateModel {
  bool success;
  String message;
  AppUpdateData data;
  User users;

  AppUpdateModel(
      {required this.success,
      required this.message,
      required this.data,
      required this.users});

  factory AppUpdateModel.fromJson(Map<String, dynamic> json) => AppUpdateModel(
        success: json["success"],
        message: json["message"],
        data: AppUpdateData.fromJson(json["data"]),
        users: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
        "user":users.toJson(),
      };
}

class AppUpdateData {
  int id;
  String version;
  String appUrl;
  String description;
  int isForcefullyUpdate;
  int isActive;

  AppUpdateData({
    required this.id,
    required this.version,
    required this.appUrl,
    required this.description,
    required this.isForcefullyUpdate,
    required this.isActive,
  });

  factory AppUpdateData.fromJson(Map<String, dynamic> json) => AppUpdateData(
        id: json["id"],
        version: json["version"] ?? '',
        appUrl: json["app_url"] ?? '',
        description: json["description"] ?? '',
        isForcefullyUpdate: json["is_forcefully_update"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "app_url": appUrl,
        "description": description,
        "is_forcefully_update": isForcefullyUpdate,
        "is_active": isActive,
      };
}
