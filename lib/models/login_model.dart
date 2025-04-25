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
  int id;
  String name;
  String email;
  String phone;
  String businessName;
  String address;
  City city;
  StateData state;
  String pincode;
  String visitingCardUrl;
  bool isVerified;
  String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.visitingCardUrl,
    required this.isVerified,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        businessName: json["business_name"] ?? '',
        address: json["address"] ?? '',
        city: City.fromJson(json["city"]),
        state: StateData.fromJson(json["state"]),
        pincode: json["pincode"] ?? '',
        visitingCardUrl: json["visiting_card_url"] ?? '',
        isVerified: json["is_verified"],
        token: json["token"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "business_name": businessName,
        "address": address,
        "city": city.toJson(),
        "state": state.toJson(),
        "pincode": pincode,
        "visiting_card_url": visitingCardUrl,
        "is_verified": isVerified,
        "token": token,
      };
}

class City {
  int id;
  String city;
  int stateId;

  City({
    required this.id,
    required this.city,
    required this.stateId,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        city: json["city"] ?? '',
        stateId: json["state_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "state_id": stateId,
      };
}

class StateData {
  int id;
  String name;
  int countryId;

  StateData({
    required this.id,
    required this.name,
    required this.countryId,
  });

  factory StateData.fromJson(Map<String, dynamic> json) => StateData(
        id: json["id"],
        name: json["name"] ?? '',
        countryId: json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_id": countryId,
      };
}
