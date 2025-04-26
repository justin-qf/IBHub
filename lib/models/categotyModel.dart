import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  bool success;
  String message;
  List<CategoryData> data;

  CategoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        success: json["success"],
        message: json["message"],
        data: List<CategoryData>.from(
            json["data"].map((x) => CategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CategoryData {
  int id;
  String name;
  String thumbnail;

  CategoryData({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["id"],
        name: json["name"] ?? '',
        thumbnail: json["thumbnail"] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "thumbnail": thumbnail};
}
