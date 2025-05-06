import 'dart:convert';

BusinessModel businessModelFromJson(String str) =>
    BusinessModel.fromJson(json.decode(str));

String businessModelToJson(BusinessModel data) => json.encode(data.toJson());

class BusinessModel {
  bool success;
  String message;
  Data data;

  BusinessModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
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
  List<BusinessData> data;
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
        data: List<BusinessData>.from(
            json["data"].map((x) => BusinessData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
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

class BusinessData {
  int id;
  String businessId;
  String name;
  String email;
  String phone;
  String businessName;
  String address;
  City? city;
  StateDataList? state;
  String pincode;
  String visitingCardUrl;
  bool isEmailVerified;
  double? businessReviewsAvgRating;
  bool isFavorite;
  String 

  BusinessData({
    required this.id,
    required this.businessId,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.visitingCardUrl,
    required this.isEmailVerified,
    required this.businessReviewsAvgRating,
    required this.isFavorite,
  });

  factory BusinessData.fromJson(Map<String, dynamic> json) => BusinessData(
        id: json["id"],
        businessId: json["business_id"].toString() ?? '',
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        businessName: json["business_name"] ?? '',
        address: json["address"] ?? '',
        city: json["city"] != null ? City.fromJson(json["city"]) : null,
        state: json["state"] != null
            ? StateDataList.fromJson(json["state"])
            : null,
        pincode: json["pincode"] ?? '',
        visitingCardUrl: json["visiting_card_url"] ?? '',
        isEmailVerified: json["is_email_verified"] ?? false,
        businessReviewsAvgRating: json["business_reviews_avg_rating"] != null
            ? json["business_reviews_avg_rating"]?.toDouble()
            : 0.0,
        isFavorite: json["is_favorite"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessId ?? '',
        "name": name,
        "email": email,
        "phone": phone,
        "business_name": businessName,
        "address": address,
        "city": city?.toJson(),
        "state": state?.toJson(),
        "pincode": pincode,
        "visiting_card_url": visitingCardUrl,
        "business_reviews_avg_rating": businessReviewsAvgRating,
        "is_favorite": isFavorite,
        "is_email_verified": isEmailVerified
      };
}

class City {
  int id;
  String city;

  City({
    required this.id,
    required this.city,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        city: json["city"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
      };
}

class StateDataList {
  int id;
  String name;

  StateDataList({required this.id, required this.name});

  factory StateDataList.fromJson(Map<String, dynamic> json) =>
      StateDataList(id: json["id"], name: json["name"] ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
