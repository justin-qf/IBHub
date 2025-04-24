
import 'dart:convert';

StateModel stateDatFromJson(String str) => StateModel.fromJson(json.decode(str));

String stateDatToJson(StateModel data) => json.encode(data.toJson());

class StateModel {
    bool success;
    String message;
    List<Statedata> data;

    StateModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        success: json["success"],
        message: json["message"],
        data: List<Statedata>.from(json["data"].map((x) => Statedata.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Statedata {
    int id;
    String name;

    Statedata({
        required this.id,
        required this.name,
    });

    factory Statedata.fromJson(Map<String, dynamic> json) => Statedata(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}


CityData cityDataFromJson(String str) => CityData.fromJson(json.decode(str));

String cityDataToJson(CityData data) => json.encode(data.toJson());

class CityData {
    bool success;
    String message;
    List<Citydata> data;

    CityData({
        required this.success,
        required this.message,
        required this.data,
    });

    factory CityData.fromJson(Map<String, dynamic> json) => CityData(
        success: json["success"],
        message: json["message"],
        data: List<Citydata>.from(json["data"].map((x) => Citydata.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Citydata {
    int id;
    String city;

    Citydata({
        required this.id,
        required this.city,
    });

    factory Citydata.fromJson(Map<String, dynamic> json) => Citydata(
        id: json["id"],
        city: json["city"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
    };
}
