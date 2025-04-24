import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool success;
  String message;
  LoginData data;

  LoginModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
      success: json["success"],
      message: json["message"],
      data: LoginData.fromJson(json["data"]));

  Map<String, dynamic> toJson() =>
      {"success": success, "message": message, "data": data.toJson()};
}

class LoginData {
  User user;

  LoginData({required this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {"user": user.toJson()};
}

class User {
  String id;
  String name;
  String email;
  String phone;
  String businessName;
  String city;
  String state;
  String pincode;
  String visitingCardUrl;
  bool isVerified;
  String token;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.businessName,
      required this.city,
      required this.state,
      required this.pincode,
      required this.visitingCardUrl,
      required this.isVerified,
      required this.token});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"].toString() ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        businessName: json["business_name"] ?? '',
        city: json["city"] ?? '',
        state: json["state"] ?? '',
        pincode: json["pincode"] ?? '',
        visitingCardUrl: json["visiting_card_url"] ?? '',
        isVerified: json["is_verified"] ?? '',
        token: json["token"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "business_name": businessName,
        "city": city,
        "state": state,
        "pincode": pincode,
        "visiting_card_url": visitingCardUrl,
        "is_verified": isVerified,
        "token": token,
      };
}
