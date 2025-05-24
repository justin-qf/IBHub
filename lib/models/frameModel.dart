import 'dart:convert';

FrameModel frameModelFromJson(String str) =>
    FrameModel.fromJson(json.decode(str));

String frameModelToJson(FrameModel data) => json.encode(data.toJson());

class FrameModel {
  bool success;
  String message;
  FrameDataList data;

  FrameModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FrameModel.fromJson(Map<String, dynamic> json) => FrameModel(
        success: json["success"],
        message: json["message"],
        data: FrameDataList.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class FrameDataList {
  int currentPage;
  List<FramesData> data;
  String firstPageUrl;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int total;

  FrameDataList({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.total,
  });

  factory FrameDataList.fromJson(Map<String, dynamic> json) => FrameDataList(
        currentPage: json["current_page"],
        data: List<FramesData>.from(
            json["data"].map((x) => FramesData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "total": total,
      };
}

class FramesData {
  int id;
  int userId;
  String title;
  String description;
  int categoryId;
  String imgUrl;
  int isActive;
  Category category;

  FramesData({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.imgUrl,
    required this.isActive,
    required this.category,
  });

  factory FramesData.fromJson(Map<String, dynamic> json) => FramesData(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        categoryId: json["category_id"],
        imgUrl: json["img_url"] ?? '',
        isActive: json["is_active"],
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "description": description,
        "category_id": categoryId,
        "img_url": imgUrl,
        "is_active": isActive,
        "category": category.toJson(),
      };
}

class Category {
  int id;
  String name;
  String thumbnail;
  String description;

  Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"] ?? '',
        thumbnail: json["thumbnail"] ?? '',
        description: json["description"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "description": description,
      };
}
