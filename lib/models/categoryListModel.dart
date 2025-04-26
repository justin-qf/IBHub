import 'dart:convert';

CategoryListModel categoryListModelFromJson(String str) =>
    CategoryListModel.fromJson(json.decode(str));

String categoryListModelToJson(CategoryListModel data) =>
    json.encode(data.toJson());

class CategoryListModel {
  bool success;
  String message;
  Data data;

  CategoryListModel(
      {required this.success, required this.message, required this.data});

  factory CategoryListModel.fromJson(Map<String, dynamic> json) =>
      CategoryListModel(
        success: json["success"],
        message: json["message"] ?? '',
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int currentPage;
  List<CategoryListData> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String? nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<CategoryListData>.from(
            json["data"].map((x) => CategoryListData.fromJson(x))),
        firstPageUrl: json["first_page_url"] ?? '',
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"] ?? '',
        nextPageUrl: json["next_page_url"] ?? '',
        path: json["path"] ?? '',
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"] ?? '',
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class CategoryListData {
  int id;
  String name;
  String thumbnail;
  String description;

  CategoryListData({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory CategoryListData.fromJson(Map<String, dynamic> json) =>
      CategoryListData(
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
