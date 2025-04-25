// To parse this JSON data, do
//
//     final categoryData = categoryDataFromJson(jsonString);

import 'dart:convert';

CategoryData categoryDataFromJson(String str) => CategoryData.fromJson(json.decode(str));

String categoryDataToJson(CategoryData data) => json.encode(data.toJson());

class CategoryData {
    bool success;
    String message;
    List<CatggoryData> data;

    CategoryData({
        required this.success,
        required this.message,
        required this.data,
    });

    factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        success: json["success"],
        message: json["message"],
        data: List<CatggoryData>.from(json["data"].map((x) => CatggoryData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CatggoryData {
    int id;
    String name;

    CatggoryData({
        required this.id,
        required this.name,
    });

    factory CatggoryData.fromJson(Map<String, dynamic> json) => CatggoryData(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
