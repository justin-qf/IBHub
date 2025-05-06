import 'dart:convert';

import 'package:ibh/models/categorylistdatamodel.dart';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool? success;
  String? message;
  LoginData? data;

  LoginModel({
    this.success,
    this.message,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null ? LoginData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class LoginData {
  User? user;

  LoginData({this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}

class User {
  int? id;
  String? name;
  String? appUrl;
  String? email;
  String? phone;
  String? businessName;
  String? website;
  String? address;
  City? city;
  StateData? state;
  String? pincode;
  String? visitingCardUrl;
  bool? isVerified;
  bool? isEmailVerified;
  String? isActive;
  String? token;
  double? businessReviewsAvgRating;
  Document? document;
  String? facebook;
  String? linkedin;
  String? whatsappNo;
  CatggoryData? category;

  User({
    this.id,
    this.name,
    this.appUrl,
    this.email,
    this.phone,
    this.businessName,
    this.website,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.visitingCardUrl,
    this.isVerified,
    this.isEmailVerified,
    this.isActive,
    this.token,
    this.businessReviewsAvgRating,
    this.document,
    this.facebook,
    this.linkedin,
    this.whatsappNo,
    this.category,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        appUrl: json["app_url"],
        email: json["email"],
        phone: json["phone"],
        businessName: json["business_name"],
        website: json["website"],
        address: json["address"],
        city: json["city"] != null ? City.fromJson(json["city"]) : null,
        state: json["state"] != null ? StateData.fromJson(json["state"]) : null,
        pincode: json["pincode"],
        visitingCardUrl: json["visiting_card_url"],
        isVerified: json["is_verified"],
        isEmailVerified: json["is_email_verified"],
        isActive: json["is_active"]?.toString(),
        token: json["token"],
        businessReviewsAvgRating: json["business_reviews_avg_rating"] != null
            ? (json["business_reviews_avg_rating"] as num).toDouble()
            : null,
        document: json["document"] != null
            ? Document.fromJson(json["document"])
            : null,
        facebook: json["facebook"],
        linkedin: json["linkedin"],
        whatsappNo: json["whatsapp_no"],
        category: json["category"] != null
            ? CatggoryData.fromJson(json["category"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "app_url": appUrl,
        "email": email,
        "phone": phone,
        "business_name": businessName,
        "website": website,
        "address": address,
        "city": city?.toJson(),
        "state": state?.toJson(),
        "pincode": pincode,
        "visiting_card_url": visitingCardUrl,
        "is_verified": isVerified,
        "is_email_verified": isEmailVerified,
        "is_active": isActive,
        "token": token,
        "business_reviews_avg_rating": businessReviewsAvgRating,
        "document": document?.toJson(),
        "facebook": facebook,
        "linkedin": linkedin,
        "whatsapp_no": whatsappNo,
        "category": category,
      };
}

class City {
  int? id;
  String? city;
  int? stateId;

  City({
    this.id,
    this.city,
    this.stateId,
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
  int? id;
  String? name;
  int? countryId;

  StateData({
    this.id,
    this.name,
    this.countryId,
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

class Document {
  String? documentType;
  String? documentUrl;
  int? documentId;

  Document({this.documentType, this.documentUrl, this.documentId});

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        documentId: json["id"] ?? '',
        documentType: json["document_type"] ?? '',
        documentUrl: json["document_url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "document_type": documentType,
        "document_url": documentUrl,
        "id": documentId
      };
}

// import 'dart:convert';

// LoginModel loginModelFromJson(String str) =>
//     LoginModel.fromJson(json.decode(str));

// String loginModelToJson(LoginModel data) => json.encode(data.toJson());

// class LoginModel {
//   bool success;
//   String message;
//   LoginData data;

//   LoginModel({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
//       success: json["success"],
//       message: json["message"],
//       data: LoginData.fromJson(json["data"]));

//   Map<String, dynamic> toJson() =>
//       {"success": success, "message": message, "data": data.toJson()};
// }

// class LoginData {
//   User user;

//   LoginData({required this.user});

//   factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
//         user: User.fromJson(json["user"]),
//       );

//   Map<String, dynamic> toJson() => {"user": user.toJson()};
// }

// class User {
//   int id;
//   String name;
//   String appUrl;
//   String email;
//   String phone;
//   String businessName;
//   String website;
//   String address;
//   City? city;
//   StateData? state;
//   String pincode;
//   String visitingCardUrl;
//   bool isVerified;
//   String token;
//   String? documentType;
//   String? documentUrl;
//   double? businessReviewsAvgRating;

//   User({
//     required this.id,
//     required this.name,
//     required this.appUrl,
//     required this.email,
//     required this.phone,
//     required this.businessName,
//     required this.address,
//     required this.website,
//     required this.city,
//     required this.state,
//     required this.pincode,
//     required this.visitingCardUrl,
//     required this.isVerified,
//     required this.token,
//     required this.businessReviewsAvgRating,
//   });

//   factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["id"],
//         name: json["name"] ?? '',
//         appUrl: json["app_url"] ?? '',
//         email: json["email"] ?? '',
//         phone: json["phone"] ?? '',
//         businessName: json["business_name"] ?? '',
//         address: json["address"] ?? '',
//         website: json["website"] ?? '',
//         city: json["city"] != null ? City.fromJson(json["city"]) : null,
//         state: json["state"] != null ? StateData.fromJson(json["state"]) : null,
//         pincode: json["pincode"] ?? '',
//         visitingCardUrl: json["visiting_card_url"] ?? '',
//         isVerified: json["is_verified"],
//         token: json["token"] ?? '',
//         businessReviewsAvgRating: json["business_reviews_avg_rating"] != null
//             ? json["business_reviews_avg_rating"]?.toDouble()
//             : 0.0,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "app_url": appUrl,
//         "email": email,
//         "phone": phone,
//         "business_name": businessName,
//         "address": address,
//         "website": website,
//         "city": city?.toJson(),
//         "state": state?.toJson(),
//         "pincode": pincode,
//         "visiting_card_url": visitingCardUrl,
//         "is_verified": isVerified,
//         "token": token,
//         "business_reviews_avg_rating": businessReviewsAvgRating,
//       };
// }

// class City {
//   int id;
//   String city;
//   int stateId;

//   City({
//     required this.id,
//     required this.city,
//     required this.stateId,
//   });

//   factory City.fromJson(Map<String, dynamic> json) => City(
//         id: json["id"],
//         city: json["city"] ?? '',
//         stateId: json["state_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "city": city,
//         "state_id": stateId,
//       };
// }

// class StateData {
//   int id;
//   String name;
//   int countryId;

//   StateData({
//     required this.id,
//     required this.name,
//     required this.countryId,
//   });

//   factory StateData.fromJson(Map<String, dynamic> json) => StateData(
//         id: json["id"],
//         name: json["name"] ?? '',
//         countryId: json["country_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "country_id": countryId,
//       };
// }
