import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  bool success;
  String message;
  ProductData data;

  ProductModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      success: json["success"],
      message: json["message"],
      data: ProductData.fromJson(json["data"]));

  Map<String, dynamic> toJson() =>
      {"success": success, "message": message, "data": data.toJson()};
}

class ProductData {
  int currentPage;
  List<ProductListData> data;
  String firstPageUrl;
  int lastPage;
  String lastPageUrl;
  // List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int total;

  ProductData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.lastPage,
    required this.lastPageUrl,
    // required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.total,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        currentPage: json["current_page"],
        data: List<ProductListData>.from(
            json["data"].map((x) => ProductListData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        // links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
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
        // "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "total": total,
      };
}

class ProductListData {
  int id;
  int userId;
  int categoryId;
  int servicesId;
  String name;
  String slug;
  String description;
  String price;
  String salePrice;
  int stock;
  dynamic sku;
  List<String> images;
  List<String> specifications;
  bool isFeatured;
  bool status;
  bool isService;
  String unit;
  Category category;
  Service service;

  ProductListData({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.servicesId,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.salePrice,
    required this.stock,
    required this.sku,
    required this.images,
    required this.specifications,
    required this.isFeatured,
    required this.status,
    required this.isService,
    required this.unit,
    required this.category,
    required this.service,
  });

  factory ProductListData.fromJson(Map<String, dynamic> json) =>
      ProductListData(
        id: json["id"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        servicesId: json["services_id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        price: json["price"],
        salePrice: json["sale_price"],
        stock: json["stock"],
        sku: json["sku"],
        images: List<String>.from(json["images"].map((x) => x)),
        specifications: List<String>.from(json["specifications"].map((x) => x)),
        isFeatured: json["is_featured"],
        status: json["status"],
        isService: json["is_service"],
        unit: json["unit"],
        category: Category.fromJson(json["category"]),
        service: Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "category_id": categoryId,
        "services_id": servicesId,
        "name": name,
        "slug": slug,
        "description": description,
        "price": price,
        "sale_price": salePrice,
        "stock": stock,
        "sku": sku,
        "images": List<dynamic>.from(images.map((x) => x)),
        "specifications": List<dynamic>.from(specifications.map((x) => x)),
        "is_featured": isFeatured,
        "status": status,
        "is_service": isService,
        "unit": unit,
        "category": category.toJson(),
        "service": service.toJson(),
      };
}

class Category {
  int id;
  String name;
  String thumbnail;
  String description;

  Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"] ?? '',
        thumbnail: json["thumbnail"] ?? '',
        description: json["description"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "description": description,
      };
}

class Service {
  int id;
  String serviceTitle;
  String description;

  Service({
    required this.id,
    required this.serviceTitle,
    required this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        serviceTitle: json["service_title"] ?? '',
        description: json["description"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_title": serviceTitle,
        "description": description,
      };
}

// class Link {
//   String? url;
//   String label;
//   bool active;

//   Link({
//     required this.url,
//     required this.label,
//     required this.active,
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
