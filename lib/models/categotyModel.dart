import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  bool success;
  String message;
  List<CategoryData> data;

  CategoryModel(
      {required this.success, required this.message, required this.data});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
      success: json["success"],
      message: json["message"],
      data: List<CategoryData>.from(
          json["data"].map((x) => CategoryData.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson()))
      };
}

class CategoryData {
  String name;

  CategoryData({required this.name});

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      CategoryData(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}
