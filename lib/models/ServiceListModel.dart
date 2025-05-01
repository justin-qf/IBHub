import 'dart:convert';

import 'package:get/get.dart';

ServiceListModel serviceListModelFromJson(String str) =>
    ServiceListModel.fromJson(json.decode(str));

String serviceListModelToJson(ServiceListModel data) =>
    json.encode(data.toJson());

class ServiceListModel {
  bool success;
  String message;
  Data data;

  ServiceListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceListModel.fromJson(Map<String, dynamic> json) =>
      ServiceListModel(
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
  List<ServiceDataList> data;
  String firstPageUrl;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int total;

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<ServiceDataList>.from(
            json["data"].map((x) => ServiceDataList.fromJson(x))),
        firstPageUrl: json["first_page_url"] ?? '',
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"] ?? '',
        nextPageUrl: json["next_page_url"] ?? '',
        path: json["path"] ?? '',
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"] ?? '',
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

class ServiceDataList {
  int id;
  String serviceTitle;
  String description;
  String keywords;
  String categoryId;
  String thumbnail;
  RxInt isActive;
  String categoryName;

  ServiceDataList({
    required this.id,
    required this.serviceTitle,
    required this.description,
    required this.keywords,
    required this.categoryId,
    required this.thumbnail,
    required int isActive,
    required this.categoryName,
  }) : isActive = RxInt(isActive);

  factory ServiceDataList.fromJson(Map<String, dynamic> json) =>
      ServiceDataList(
        id: json["id"],
        serviceTitle: json["service_title"] ?? '',
        description: json["description"] ?? '',
        keywords: json["keywords"] ?? '',
        categoryId: json["category_id"].toString(),
        thumbnail: json["thumbnail"] ?? '',
        isActive: json["is_active"] ?? 0,
        categoryName: json["category_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_title": serviceTitle,
        "description": description,
        "keywords": keywords,
        "category_id": categoryId,
        "thumbnail": thumbnail,
        "is_active": isActive.value,
        "category_name": categoryName,
      };
}
