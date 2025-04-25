import 'dart:convert';

CityModel cityModelFromJson(String str) => CityModel.fromJson(json.decode(str));

String cityModelToJson(CityModel data) => json.encode(data.toJson());

class CityModel {
  bool success;
  String message;
  List<CityListData> data;

  CityModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        success: json["success"],
        message: json["message"] ?? '',
        data: List<CityListData>.from(
            json["data"].map((x) => CityListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CityListData {
  int id;
  String city;

  CityListData({
    required this.id,
    required this.city,
  });

  factory CityListData.fromJson(Map<String, dynamic> json) => CityListData(
        id: json["id"],
        city: json["city"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
      };
}
