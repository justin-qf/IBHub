import 'dart:convert';

ImageModel imageModelFromJson(String str) =>
    ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
  bool success;
  String message;
  ImageDataList data;

  ImageModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        success: json["success"],
        message: json["message"],
        data: ImageDataList.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class ImageDataList {
  int currentPage;
  List<ImageData> data;
  String firstPageUrl;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int total;

  ImageDataList({
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

  factory ImageDataList.fromJson(Map<String, dynamic> json) => ImageDataList(
        currentPage: json["current_page"],
        data: List<ImageData>.from(
            json["data"].map((x) => ImageData.fromJson(x))),
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

class ImageData {
  int id;
  String title;
  int categoryId;
  String imgKeywords;
  String imgPath;
  String imgThumbPath;
  DateTime startDate;
  DateTime endDate;
  int isActive;
  int isFree;
  int sortOrder;
  String language;
  Category category;

  ImageData({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.imgKeywords,
    required this.imgPath,
    required this.imgThumbPath,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.isFree,
    required this.sortOrder,
    required this.language,
    required this.category,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        id: json["id"],
        title: json["title"] ?? '',
        categoryId: json["category_id"],
        imgKeywords: json["img_keywords"] ?? '',
        imgPath: json["img_path"] ?? '',
        imgThumbPath: json["img_thumb_path"] ?? '',
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        isActive: json["is_active"],
        isFree: json["is_free"],
        sortOrder: json["sort_order"],
        language: json["language"] ?? '',
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category_id": categoryId,
        "img_keywords": imgKeywords,
        "img_path": imgPath,
        "img_thumb_path": imgThumbPath,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
        "is_free": isFree,
        "sort_order": sortOrder,
        "language": language,
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
