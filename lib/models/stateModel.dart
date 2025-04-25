import 'dart:convert';

StateModel stateModelFromJson(String str) =>
    StateModel.fromJson(json.decode(str));

String stateModelToJson(StateModel data) => json.encode(data.toJson());

class StateModel {
  bool success;
  String message;
  List<StateListData> data;

  StateModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        success: json["success"],
        message: json["message"] ?? '',
        data: List<StateListData>.from(
            json["data"].map((x) => StateListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class StateListData {
  int id;
  String name;

  StateListData({
    required this.id,
    required this.name,
  });

  factory StateListData.fromJson(Map<String, dynamic> json) => StateListData(
        id: json["id"],
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
