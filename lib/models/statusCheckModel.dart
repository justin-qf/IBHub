import 'dart:convert';

StatusCheck statusCheckFromJson(String str) =>
    StatusCheck.fromJson(json.decode(str));

String statusCheckToJson(StatusCheck data) => json.encode(data.toJson());

class StatusCheck {
  bool success;
  String message;
  StatusData data;

  StatusCheck({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StatusCheck.fromJson(Map<String, dynamic> json) => StatusCheck(
        success: json["success"],
        message: json["message"],
        data: StatusData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class StatusData {
  int id;
  int userId;
  String serviceTitle;
  String description;
  String keywords;
  int categoryId;
  String thumbnail;
  String isActive;

  StatusData({
    required this.id,
    required this.userId,
    required this.serviceTitle,
    required this.description,
    required this.keywords,
    required this.categoryId,
    required this.thumbnail,
    required this.isActive,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) => StatusData(
        id: json["id"],
        userId: json["user_id"],
        serviceTitle: json["service_title"],
        description: json["description"],
        keywords: json["keywords"],
        categoryId: json["category_id"],
        thumbnail: json["thumbnail"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_title": serviceTitle,
        "description": description,
        "keywords": keywords,
        "category_id": categoryId,
        "thumbnail": thumbnail,
        "is_active": isActive,
      };
}
