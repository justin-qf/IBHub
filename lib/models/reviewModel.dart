import 'dart:convert';

ReviewModel reviewModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  bool success;
  String message;
  Data data;

  ReviewModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        success: json["success"],
        message: json["message"],
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
  List<ReviewData> data;
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
        data: List<ReviewData>.from(
            json["data"].map((x) => ReviewData.fromJson(x))),
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

class ReviewData {
  int id;
  int userId;
  int businessId;
  String rating;
  String review;
  DateTime createdAt;
  UserReviewData user;

  ReviewData({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.rating,
    required this.review,
    required this.createdAt,
    required this.user,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
        id: json["id"],
        userId: json["user_id"],
        businessId: json["business_id"],
        rating: json["rating"] ?? '',
        review: json["review"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        user: UserReviewData.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "business_id": businessId,
        "rating": rating,
        "review": review,
        "created_at": createdAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class UserReviewData {
  int id;
  String name;
  String visitingCardUrl;

  UserReviewData({
    required this.id,
    required this.name,
    required this.visitingCardUrl,
  });

  factory UserReviewData.fromJson(Map<String, dynamic> json) => UserReviewData(
        id: json["id"],
        name: json["name"] ?? '',
        visitingCardUrl: json["visiting_card_url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "visiting_card_url": visitingCardUrl,
      };
}
