import 'dart:convert';

CityData cityDataFromJson(String str) => CityData.fromJson(json.decode(str));

String cityDataToJson(CityData data) => json.encode(data.toJson());

class CityData {
  bool status;
  List<CityDatum> data;
  String message;

  CityData({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CityData.fromJson(Map<String, dynamic> json) => CityData(
        status: json["status"],
        data: List<CityDatum>.from(json["data"].map((x) => CityDatum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class CityDatum {
  int id;
  String name;

  CityDatum({
    required this.id,
    required this.name,
  });

  factory CityDatum.fromJson(Map<String, dynamic> json) => CityDatum(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
