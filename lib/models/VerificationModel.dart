
import 'dart:convert';

Verification verificationFromJson(String str) => Verification.fromJson(json.decode(str));

String verificationToJson(Verification data) => json.encode(data.toJson());

class Verification {
    bool success;
    String message;
    List<VerificationData> data;

    Verification({
        required this.success,
        required this.message,
        required this.data,
    });

    factory Verification.fromJson(Map<String, dynamic> json) => Verification(
        success: json["success"],
        message: json["message"],
        data: List<VerificationData>.from(json["data"].map((x) => VerificationData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class VerificationData {
    String name;
    String value;

    VerificationData({
        required this.name,
        required this.value,
    });

    factory VerificationData.fromJson(Map<String, dynamic> json) => VerificationData(
        name: json["name"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
    };
}
