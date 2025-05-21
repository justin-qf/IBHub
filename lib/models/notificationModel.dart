// import 'dart:convert';

// NotificationApi? notificationFromJson(String str) =>
//     str.isEmpty ? null : NotificationApi.fromJson(json.decode(str));

// String notificationToJson(NotificationApi? data) =>
//     data == null ? '' : json.encode(data.toJson());

// class NotificationApi {
//   bool? success;
//   String? message;
//   NotificationData? data;

//   NotificationApi({
//     this.success,
//     this.message,
//     this.data,
//   });

//   factory NotificationApi.fromJson(Map<String, dynamic> json) =>
//       NotificationApi(
//         success: json["success"],
//         message: json["message"],
//         data: json["data"] == null
//             ? null
//             : NotificationData.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "message": message,
//         "data": data?.toJson(),
//       };
// }

// class NotificationData {
//   int? currentPage;
//   List<NotificationDataMessages>? data;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Link>? links;
//   dynamic nextPageUrl;
//   String? path;
//   int? perPage;
//   dynamic prevPageUrl;
//   int? to;
//   int? total;

//   NotificationData({
//     this.currentPage,
//     this.data,
//     this.firstPageUrl,
//     this.from,
//     this.lastPage,
//     this.lastPageUrl,
//     this.links,
//     this.nextPageUrl,
//     this.path,
//     this.perPage,
//     this.prevPageUrl,
//     this.to,
//     this.total,
//   });

//   factory NotificationData.fromJson(Map<String, dynamic> json) =>
//       NotificationData(
//         currentPage: json["current_page"],
//         data: json["data"] == null
//             ? null
//             : List<NotificationDataMessages>.from(json["data"]
//                 .map((x) => NotificationDataMessages.fromJson(x))),
//         firstPageUrl: json["first_page_url"],
//         from: json["from"],
//         lastPage: json["last_page"],
//         lastPageUrl: json["last_page_url"],
//         links: json["links"] == null
//             ? null
//             : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
//         nextPageUrl: json["next_page_url"],
//         path: json["path"],
//         perPage: json["per_page"],
//         prevPageUrl: json["prev_page_url"],
//         to: json["to"],
//         total: json["total"],
//       );

//   Map<String, dynamic> toJson() => {
//         "current_page": currentPage,
//         "data": data?.map((x) => x.toJson()).toList(),
//         "first_page_url": firstPageUrl,
//         "from": from,
//         "last_page": lastPage,
//         "last_page_url": lastPageUrl,
//         "links": links?.map((x) => x.toJson()).toList(),
//         "next_page_url": nextPageUrl,
//         "path": path,
//         "per_page": perPage,
//         "prev_page_url": prevPageUrl,
//         "to": to,
//         "total": total,
//       };
// }

// class NotificationDataMessages {
//   int? id;
//   int? userId;
//   String? title;
//   String? message;
//   int? isRead;
//   DateTime? createdAt;

//   NotificationDataMessages({
//     this.id,
//     this.userId,
//     this.title,
//     this.message,
//     this.isRead,
//     this.createdAt,
//   });

//   factory NotificationDataMessages.fromJson(Map<String, dynamic> json) =>
//       NotificationDataMessages(
//         id: json["id"],
//         userId: json["user_id"],
//         title: json["title"],
//         message: json["message"],
//         isRead: json["is_read"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "title": title,
//         "message": message,
//         "is_read": isRead,
//         "created_at": createdAt?.toIso8601String(),
//       };
// }

// class Link {
//   String? url;
//   String? label;
//   bool? active;

//   Link({
//     this.url,
//     this.label,
//     this.active,
//   });

//   factory Link.fromJson(Map<String, dynamic> json) => Link(
//         url: json["url"],
//         label: json["label"],
//         active: json["active"],
//       );

//   Map<String, dynamic> toJson() => {
//         "url": url,
//         "label": label,
//         "active": active,
//       };
// }
