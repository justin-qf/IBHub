import 'dart:convert';

ImageCategoryModel imageCategoryModelFromJson(String str) =>
    ImageCategoryModel.fromJson(json.decode(str));

String imageCategoryModelToJson(ImageCategoryModel data) =>
    json.encode(data.toJson());

class ImageCategoryModel {
  bool success;
  String message;
  ImageCategoryDataList data;

  ImageCategoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ImageCategoryModel.fromJson(Map<String, dynamic> json) =>
      ImageCategoryModel(
        success: json["success"],
        message: json["message"],
        data: ImageCategoryDataList.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class ImageCategoryDataList {
  int currentPage;
  List<ImageCategoryData> data;
  String firstPageUrl;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int total;

  ImageCategoryDataList({
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

  factory ImageCategoryDataList.fromJson(Map<String, dynamic> json) =>
      ImageCategoryDataList(
          currentPage: json["current_page"],
          data: List<ImageCategoryData>.from(
              json["data"].map((x) => ImageCategoryData.fromJson(x))),
          firstPageUrl: json["first_page_url"],
          lastPage: json["last_page"],
          lastPageUrl: json["last_page_url"],
          nextPageUrl: json["next_page_url"],
          path: json["path"],
          perPage: json["per_page"],
          prevPageUrl: json["prev_page_url"],
          total: json["total"]);

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
        "total": total
      };
}

class ImageCategoryData {
  int id;
  int imageCategoryTypeId;
  String name;
  String thumbnail;
  String description;
  CategoryType categoryType;

  ImageCategoryData({
    required this.id,
    required this.imageCategoryTypeId,
    required this.name,
    required this.thumbnail,
    required this.description,
    required this.categoryType,
  });

  factory ImageCategoryData.fromJson(Map<String, dynamic> json) =>
      ImageCategoryData(
        id: json["id"],
        imageCategoryTypeId: json["image_category_type_id"],
        name: json["name"],
        thumbnail: json["thumbnail"],
        description: json["description"],
        categoryType: CategoryType.fromJson(json["category_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_category_type_id": imageCategoryTypeId,
        "name": name,
        "thumbnail": thumbnail,
        "description": description,
        "category_type": categoryType.toJson(),
      };
}

class CategoryType {
  int id;
  String title;

  CategoryType({
    required this.id,
    required this.title,
  });

  factory CategoryType.fromJson(Map<String, dynamic> json) => CategoryType(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
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
