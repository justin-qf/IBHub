import 'dart:convert';

ServiceDropdownModel serviceDropdownModelFromJson(String str) =>
    ServiceDropdownModel.fromJson(json.decode(str));

String serviceDropdownModelToJson(ServiceDropdownModel data) =>
    json.encode(data.toJson());

class ServiceDropdownModel {
  bool success;
  String message;
  List<ServiceData> data;

  ServiceDropdownModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceDropdownModel.fromJson(Map<String, dynamic> json) =>
      ServiceDropdownModel(
        success: json["success"],
        message: json["message"],
        data: List<ServiceData>.from(
            json["data"].map((x) => ServiceData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ServiceData {
  int id;
  String serviceTitle;
  String thumbnail;

  ServiceData({
    required this.id,
    required this.serviceTitle,
    required this.thumbnail,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
        id: json["id"],
        serviceTitle: json["service_title"] ?? '',
        thumbnail: json["thumbnail"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_title": serviceTitle,
        "thumbnail": thumbnail,
      };
}
