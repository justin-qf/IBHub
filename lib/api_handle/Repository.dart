import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ibh/configs/apicall_constant.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/log.dart';

class Repository {
  static final client = http.Client();

  static Uri buildUrl(String endPoint) {
    String host = ApiUrl.buildApiUrl;
    final apiPath = host + endPoint;
    logcat("API", apiPath);
    return Uri.parse(apiPath);
  }

  static get buildHeader async {
    return {
      HttpHeaders.contentTypeHeader: "application/json",
    };
  }

  static get buildMultipartHeader async {
    return {'content-type': "multipart/form-data"};
  }
 static Future<http.Response> postApi(Map<String, dynamic> body, String endPoint,
      {bool? allowHeader}) async {
    logcat("APIURL:::", buildUrl(endPoint));
    logcat("APIURL:::",  jsonEncode(body));
    String token = await UserPreferences().getToken();
    //logcat("TOKEN", token.toString());
    Map<String, String> headers = {
      'Content-Type': "application/json",
      'Authorization': 'Bearer $token',
    };
    // logcat("PassignData", {
    //   'Content-Type': "application/json",
    //   'Authorization': token,
    // });

    try {
      var response = await client
          .post(buildUrl(endPoint), body: jsonEncode(body), headers: headers)
          .timeout(const Duration(seconds: 20)); // ⏳ Set timeout to 30s
      return response;
    } catch (e) {
      if (e is TimeoutException) {
        logcat("API Error", "Request timed out!");
        throw TimeoutException("The request timed out. Please try again.");
      } else {
        logcat("API Error", e.toString());
        rethrow;
      }
    }
    // var response = await client.post(buildUrl(endPoint),
    //     body: jsonEncode(body),
    //     headers: allowHeader == true ? headers : await buildHeader);
    // return response;
  }
  static Future<http.Response> post(Map<String, dynamic> body, String endPoint,
      {bool? allowHeader}) async {
    logcat("APIURL:::", buildUrl(endPoint));
    String token = await UserPreferences().getToken();
    //logcat("TOKEN", token.toString());
    Map<String, String> headers = {
      'Content-Type': "application/json",
      'Authorization': 'Bearer $token',
    };
    // logcat("PassignData", {
    //   'Content-Type': "application/json",
    //   'Authorization': token,
    // });

    try {
      var response = await client
          .post(buildUrl(endPoint), body: jsonEncode(body), headers: headers)
          .timeout(const Duration(seconds: 20)); // ⏳ Set timeout to 30s
      return response;
    } catch (e) {
      if (e is TimeoutException) {
        logcat("API Error", "Request timed out!");
        throw TimeoutException("The request timed out. Please try again.");
      } else {
        logcat("API Error", e.toString());
        rethrow;
      }
    }
    // var response = await client.post(buildUrl(endPoint),
    //     body: jsonEncode(body),
    //     headers: allowHeader == true ? headers : await buildHeader);
    // return response;
  }

  static Future<http.Response> update(
      Map<String, dynamic> body, String endPoint,
      {bool? allowHeader}) async {
    logcat("APIURL:::", buildUrl(endPoint));
    String token = await UserPreferences().getToken();
    logcat("TOKEN", token.toString());
    Map<String, String> headers = {
      'Content-Type': "application/json",
      'Authorization': token,
    };
    logcat("PassignData", {
      'Content-Type': "application/json",
      'Authorization': token,
    });
    var response = await client.put(buildUrl(endPoint),
        body: jsonEncode(body),
        headers: allowHeader == true ? headers : await buildHeader);
    return response;
  }

  static Future<http.Response> get(Map<String, String> body, String endPoint,
      {bool? allowHeader, bool? isToken}) async {
    logcat("APIURL:::", buildUrl(endPoint));

    String token = await UserPreferences().getToken();
    logcat("Token::::", token.toString());
    Map<String, String> headers = {
      'Content-Type': "application/json",
      'Authorization': 'Bearer $token',
    };
    var response = await client.get(buildUrl(endPoint),
        headers: allowHeader == true ? headers : await buildHeader);
    return response;
  }

  static Future<http.Response> put(Map<String, dynamic> body, String endPoint,
      {bool? allowHeader}) async {
    logcat("APIURL:::", buildUrl(endPoint));
    String token = await UserPreferences().getToken();
    logcat("TOKEN", token.toString());

    // Set up headers for the PUT request
    Map<String, String> headers = {
      'Content-Type': "application/json",
      'Authorization': 'Bearer $token',
    };

    // Make the PUT request
    var response = await client.put(
      buildUrl(endPoint),
      body: jsonEncode(body), // Convert body to JSON format
      headers: allowHeader == true ? headers : await buildHeader,
    );

    return response;
  }

  static Future<http.StreamedResponse> multiPartPost(var body, String endPoint,
      {bool allowHeader = false,
      http.MultipartFile? multiPart,
      List<http.MultipartFile>? multiPartData}) async {
    String token = await UserPreferences().getToken();
    logcat("Token::::", token.toString());
    Map<String, String> headers = {
      'Content-Type': "multipart/form-data",
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
      "POST",
      buildUrl(endPoint),
    );
    if (allowHeader) request.headers.addAll(headers);
    if (multiPart != null) {
      request.files.add(multiPart);
      logcat("files", request.files.length);
    }
    if (multiPartData != null) {
      request.files.addAll(multiPartData);
    }
    request.fields.addAll(body);

    var response = await request.send();

    return response;
  }

  static Future<http.Response> delete(String endPoint,
      {bool? allowHeader, bool? isToken}) async {
    logcat("APIURL:::", buildUrl(endPoint));

    String token = await UserPreferences().getToken();
    logcat("Token::::", token.toString());

    Map<String, String> headers = {
      'Content-Type': "application/json",
      'Authorization': 'Bearer $token',
    };

    var response = await client.delete(
      buildUrl(endPoint),
      headers: allowHeader == true ? headers : await buildHeader,
    );
    return response;
  }
}
