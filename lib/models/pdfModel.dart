import 'dart:convert';

PdfData pdfDataFromJson(String str) => PdfData.fromJson(json.decode(str));

String pdfDataToJson(PdfData data) => json.encode(data.toJson());

class PdfData {
  bool success;
  String message;
  Datalink data;

  PdfData({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PdfData.fromJson(Map<String, dynamic> json) => PdfData(
        success: json["success"],
        message: json["message"],
        data: Datalink.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Datalink {
  String url;

  Datalink({
    required this.url,
  });

  factory Datalink.fromJson(Map<String, dynamic> json) => Datalink(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
