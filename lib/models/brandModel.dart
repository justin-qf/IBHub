import 'dart:convert';

BrandModel brandModelFromJson(String str) =>
    BrandModel.fromJson(json.decode(str));

String brandModelToJson(BrandModel data) => json.encode(data.toJson());

class BrandModel {
  bool success;
  String message;
  BrandData data;

  BrandModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        success: json["success"],
        message: json["message"],
        data: BrandData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class BrandData {
  int currentPage;
  List<BrandDetailData> data;
  String firstPageUrl;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int total;

  BrandData({
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

  factory BrandData.fromJson(Map<String, dynamic> json) => BrandData(
        currentPage: json["current_page"],
        data: List<BrandDetailData>.from(
            json["data"].map((x) => BrandDetailData.fromJson(x))),
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

class BrandDetailData {
  int id;
  String title;
  String description;
  int isActive;
  List<Category> category;

  BrandDetailData({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.category,
  });

  factory BrandDetailData.fromJson(Map<String, dynamic> json) =>
      BrandDetailData(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        isActive: json["is_active"],
        category: List<Category>.from(
            json["category"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "is_active": isActive,
        "category": List<dynamic>.from(category.map((x) => x.toJson())),
      };
}

class Category {
  int id;
  String name;
  String thumbnail;
  String description;
  int imageCategoryTypeId;

  Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
    required this.imageCategoryTypeId,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"] ?? '',
        thumbnail: json["thumbnail"] ?? '',
        description: json["description"] ?? '',
        imageCategoryTypeId: json["image_category_type_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "description": description,
        "image_category_type_id": imageCategoryTypeId,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
