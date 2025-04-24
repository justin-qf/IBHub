import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ibh/api_handle/ModelClasses/CityModel.dart';
import 'package:ibh/componant/widgets/widgets.dart';
import 'package:ibh/configs/string_constant.dart';

class APIHandling {
  Future<List<CityDatum>> fetchCityData() async {
    final url =
        Uri.parse('http://192.168.1.28/the_prelim_masters/public/api/getCity');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        CityData data = cityDataFromJson(response.body);
        return data.data;
      }
    } catch (e) {
      print(e);
    }

    return [];
  }

  Future<void> registerUser({
    required name,
    required email,
    required address,
    required contactNumber,
    required password,
    required cityId,
    required cityName,
  }) async {
    final url =
        Uri.parse('http://192.168.1.28/the_prelim_masters/public/api/register');

    final body = {
      "name": name,
      "email_id": email,
      "address": address,
      "contact_number": contactNumber,
      "device_token": "",
      "password": password,
      "city_id": cityId,
      "city_name": cityName
    };

    try {
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print("Success:${json}");
      } else {
        print('Failed :${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUser(context,
      {contactNumber, password, gotoDashboard, isloading}) async {
    final url =
        Uri.parse('http://192.168.1.28/the_prelim_masters/public/api/login');

    final body = {"contact_number": contactNumber, "password": password};

    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == true) {
          getpopup(context,
              istimerrunout: true,
              title: 'Success',
              message: json['message'] ?? LoginConst.successLogin,
              function: () {
            gotoDashboard();
          });
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(json['message'] ?? LoginConst.successLogin),
          //     backgroundColor: primaryColor,
          //     behavior: SnackBarBehavior.floating,
          //   ),
          // );

          print('Login Successful: $json');
        } else {
          getpopup(context,
              istimerrunout: true,
              title: 'Failed',
              message: json['message'] ?? LoginConst.errorLogin, function: () {
            isloading();
          });
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(json['message'] ?? LoginConst.errorLogin),
          //     backgroundColor: Colors.red,
          //     behavior: SnackBarBehavior.floating,
          //   ),
          // );

          print('Login Failed - Invalid credentials: $json');
        }
      } else {
        getpopup(context,
            istimerrunout: true,
            title: 'Failed',
            message: LoginConst.errorLogin, function: () {
          isloading();
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(LoginConst.errorLogin),
        //     backgroundColor: Colors.red,
        //     behavior: SnackBarBehavior.floating,
        //   ),
        // );

        isloading();
        print('Login Failed - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      isloading();
    }
  }

  Future<void> sendResetRequest(BuildContext context,
      {required mobileNumber}) async {
    final url = Uri.parse(
        'http://192.168.1.28/the_prelim_masters/public/api/forgetPassword');

    final body = {
      "mobile_number": mobileNumber,
    };

    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          getpopup(context,
              istimerrunout: true,
              title: 'Success',
              message: json['message'], function: () {
            Get.back();
          });
        } else {
          getpopup(context,
              istimerrunout: true,
              title: 'Failed',
              message: json['message'], function: () {
            Get.back();
          });
        }
      } else {
        getpopup(context,
            istimerrunout: true,
            title: 'Failed',
            message: 'Invalid Credentials', function: () {
          Get.back();
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
