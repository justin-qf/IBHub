// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:science_cafe/api_handle/apiModelClass.dart';
// import 'package:science_cafe/componant/CustomSnakbar.dart';
// import 'package:science_cafe/configs/colors_constant.dart';
// import 'package:science_cafe/controller/internet_controller.dart';

// class ApiHandling {
//   Future<Gst> getData({required pageNo}) async {
//     try {
//       var url = Uri.parse(
//           'https://pmsvrfzg-9171.inc1.devtunnels.ms/api/gst/list_Pagination');

//       var headers = {
//         'x-access-token':
//             'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyLCJjb21wYW55X2lkIjoyLCJpYXQiOjE3NDM1Nzc0NTcsImV4cCI6MTc3NTExMzQ1N30.ZVYbLAf4G1cOQQQnEu8EJHaXyyAkSUHVr42x0i7Gjac',
//         'Content-type': 'application/json',
//       };

//       var body = jsonEncode({
//         "pagination": {
//           "page": pageNo,
//           "rowsPerPage": 10,
//         },
//         "filter": {
//           "query": "",
//           "company_id": "2",
//         }
//         // "pagination": {
//         //   "recordPerPage": 7,
//         //   "pageNo": pageNo,
//         // },
//         // "is_admin": 1,
//       });

//       var response = await http.post(url, headers: headers, body: body);

//       if (response.statusCode == 200) {
//         Gst categoryList = gstFromJson(response.body);

//         // print('Status:${categoryList.status}');
//         // print('Message: ${categoryList.message}');
//         // print('Total Records: ${categoryList.totalRecord}');
//         print('Total Pages: ${categoryList.totalPages}');

//         // for (var data in categoryList.data) {
//         //   print('Category ID: ${data.id}');
//         //   print('Category Name: ${data.name}');
//         //   print('is Enable: ${data.isEnable}');
//         //   print('Upload ID: ${data.uploadId}');
//         //   print('Created At: ${data.createdAt}');
//         //   print('Image URL: ${data.uploadInfo.image}');
//         // }

//         return categoryList;
//       } else if (response.statusCode == 404) {
//         print('Link is broken');
//       } else {
//         print('Failed with status:${response.statusCode}');
//         print('Response body:${response.body}');
//       }
//     } catch (e) {
//       print('Error:$e');

//       print('brokenLink Error:$e');
//     }

//     return Gst(
//       status: 0,
//       data: [],
//       totalRecords: 0,
//       totalPages: 0,
//       currentPage: 0,
//     );
//   }

//   Future<void> uploadData(BuildContext context,
//       {required String name,
//       required String tax,
//       required InternetProvider networkManager}) async {
//     if (networkManager.connectionType.value == 0) {
//       print('API calling update inside if:${networkManager.connectionType}');
//       return getDialogBox(context,
//           title: 'No Internet', message: 'Please check your connection.');
//     }
//     try {
//       var url =
//           Uri.parse('https://pmsvrfzg-9171.inc1.devtunnels.ms/api/gst/add');

//       var headers = {
//         'x-access-token':
//             'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyLCJjb21wYW55X2lkIjoyLCJpYXQiOjE3NDM1Nzc0NTcsImV4cCI6MTc3NTExMzQ1N30.ZVYbLAf4G1cOQQQnEu8EJHaXyyAkSUHVr42x0i7Gjac',
//         'Content-Type': 'application/json',
//       };

//       var body = jsonEncode({
//         'name': name,
//         'tax': tax,
//         'company_id': 2,
//         'financial_year_id': 1,
//       });

//       print(body);

//       var response = await http.post(url, headers: headers, body: body);

//       if (!context.mounted) return;

//       var jsonResponse = jsonDecode(response.body);

//       if (response.statusCode == 200 && jsonResponse['status'] == 1) {
//         await await getDialogBox(context,
//             title: 'Success', message: jsonResponse['message']);
//       } else if (response.statusCode == 400) {
//         await getDialogBox(context,
//             title: 'Failed', message: jsonResponse['message']);
//       } else {
//         print('Upload failed: ${jsonResponse['message']}');
//       }
//     } catch (e) {
//       if (!context.mounted) return;

//       if (e is SocketException) {
//         getDialogBox(context,
//             title: 'Network Error',
//             message:
//                 'Failed to connect to server. Please check your internet connection.');

//       }
//       print('Error: $e');
//     }
//   }

//   Future<void> deleteData(
//     BuildContext context, {
//     required id,
//   }) async {
//     try {
//       print('delete called');
//       var url = Uri.parse(
//           'https://pmsvrfzg-9171.inc1.devtunnels.ms/api/gst/delete?id=$id');

//       var headers = {
//         'x-access-token':
//             'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyLCJjb21wYW55X2lkIjoyLCJpYXQiOjE3NDM1Nzc0NTcsImV4cCI6MTc3NTExMzQ1N30.ZVYbLAf4G1cOQQQnEu8EJHaXyyAkSUHVr42x0i7Gjac',
//       };
//       // var body = {};

//       var response = await http.delete(url, headers: headers);
//       var jsonResponse = jsonDecode(response.body);

//       if (!context.mounted) return;

//       if (response.statusCode == 200) {
//         print('delete called 2');
//         await getDialogBox(context,
//             title: 'Success', message: jsonResponse['message']);

//         print('deleted successfully');
//       } else {
//         await getDialogBox(context,
//             title: 'Failed', message: 'Failed to delete the data');

//         print('failed to delete the data');
//       }
//     } catch (e) {
//       print('Error:$e');
//     }
//   }

//   Future<void> updateData(
//     BuildContext context, {
//     required id,
//     required name,
//     required tax,
//   }) async {
//     try {
//       var url =
//           Uri.parse('https://pmsvrfzg-9171.inc1.devtunnels.ms/api/gst/edit');

//       var headers = {
//         'x-access-token':
//             'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyLCJjb21wYW55X2lkIjoyLCJpYXQiOjE3NDM1Nzc0NTcsImV4cCI6MTc3NTExMzQ1N30.ZVYbLAf4G1cOQQQnEu8EJHaXyyAkSUHVr42x0i7Gjac',
//         'Content-Type': 'application/json'
//       };
//       var body = jsonEncode({
//         "id": id,
//         "name": name,
//         "tax": tax,
//         "company_id": "2",
//         "financial_year_id": "1"
//       });

//       print(body);

//       var response = await http.put(url, headers: headers, body: body);

//       if (!context.mounted) return;
//       var jsonResponse = jsonDecode(response.body);

//       if (response.statusCode == 200 && jsonResponse['status'] == 1) {
//         await getDialogBox(context,
//             title: 'Success', message: 'data updated successfully');

//         print('data updated successfully');
//       } else {
//         await getDialogBox(context,
//             title: 'Failure', message: 'data updated failed');

//         print('Update failed:${jsonResponse['message']}');
//       }
//     } catch (e) {
//       print('Error:$e');
//     }
//   }

//   getDialogBox(BuildContext context, {required title, required message}) {
//     return showCupertinoDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CupertinoAlertDialog(
//             title: Text(
//               title,
//             ),
//             content: Text(message),
//             actions: [
//               CupertinoDialogAction(
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(color: black),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               CupertinoDialogAction(
//                 child: Text(
//                   'Confirm',
//                   style: TextStyle(color: green),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               )
//             ],
//           );
//         });
//   }
// }
