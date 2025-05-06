import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:ibh/configs/app_constants.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/models/login_model.dart';
import 'package:ibh/preference/UserPreference.dart';
import 'package:ibh/utils/log.dart';
import 'package:ibh/views/sigin_signup/signinScreen.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

bool isDarkMode() {
  return false;
  // var data = GetStorage().read(GetStorageKey.IS_DARK_MODE);
  // return data == 1; // If stored value is 1, return true (dark mode enabled)
}

// bool isDarkMode() {
//   bool isDark;
//   var data = GetStorage().read(GetStorageKey.IS_DARK_MODE);
//   if (data == null || data.toString().isEmpty) {
//     isDark = false;
//   } else if (GetStorage().read(GetStorageKey.IS_DARK_MODE) == 1) {
//     isDark = false;
//   } else {
//     isDark = true;
//   }
//   return isDark;
// }

Future<DateTime?> getDateTimePicker(context) async {
  DateTime? value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100));
  return value;
}

PageRouteBuilder customPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

String convert24HourTo12Hour(String time24Hour) {
  DateFormat format24Hour = DateFormat('HH:mm:ss');
  DateFormat format12Hour = DateFormat('hh:mm:ss a');

  DateTime dateTime = format24Hour.parse(time24Hour);
  String time12Hour = format12Hour.format(dateTime);

  return time12Hour;
}

String getFormateDate(String date) {
  String formattedData = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  return formattedData;
}

String getFormatedDate(String date) {
  String formattedData = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
  return formattedData;
}

String formatPrice(String priceString) {
  try {
    double price = double.parse(priceString);
    return formatPriceDouble(price);
  } catch (e) {
    logcat("Error parsing price:", e);
    return 'Invalid Price';
  }
}

String formatPriceDouble(double price) {
  NumberFormat numberFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 2,
    locale: 'en_IN',
  );
  return numberFormat.format(price);
}

double commonHeight({bool? isSmall}) {
  return isSmall == true ? 4.h : 5.h;
}

String getCurrentDate() {
  DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

String getCurrentTime() {
  DateTime now = DateTime.now();
  return DateFormat('HH:mm:ss').format(now);
}

// futureDelay(Function onPerform, {bool? fromSplash, bool? isOneSecond}) async {
//   return Future.delayed(
//     fromSplash == true
//         ? const Duration(seconds: 3)
//         : isOneSecond == true
//             ? const Duration(seconds: 1)
//             : Duration.zero,
//     () => onPerform(),
//   );
// }

futureDelay(Function onPerform,
    {bool? fromSplash = false,
    bool? isOneSecond = false,
    bool? milliseconds = false}) async {
  return Future.delayed(
    fromSplash == true
        ? const Duration(seconds: 3)
        : isOneSecond == true
            ? const Duration(seconds: 1)
            : milliseconds == true
                ? const Duration(milliseconds: 200)
                : Duration.zero,
    () => onPerform(),
  );
}

futureOrderDelay(Function onPerform) async {
  return await Future.delayed(
    const Duration(milliseconds: 100),
    () => onPerform(),
  );
}

getDarkModeDatePicker() {
  return ThemeData.dark().copyWith(
      primaryColor: white,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Set your border radius
        ),
      ),
      colorScheme: const ColorScheme.dark());
}

getLightModeDatePicker() {
  return ThemeData.light().copyWith(
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Set your border radius
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor, // Set your primary color
      background: white,
    ).copyWith(secondary: white), // Set date selected color to white
  );
}

screenOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void hideKeyboard(context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

getPinTheme() {
  return PinTheme(
    width: 16.w,
    height: 7.8.h,
    textStyle: TextStyle(fontSize: 16.sp),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(222, 231, 240, .57),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: transparent),
    ),
  );
}

DataColumn setColumn(title) {
  return DataColumn(
      label: Expanded(
    child: Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: fontMedium,
            fontSize: 2.h,
            color: isDarkMode() ? black : white),
      ),
    ),
  ));
}

Future<bool> isAnyFieldEmpty() async {
  User? retrievedObject = await UserPreferences().getSignInInfo();

  String phone = retrievedObject?.phone ?? '';
  // String address = retrievedObject?.address ?? '';
  String city = retrievedObject?.city?.city.toString() ?? '';
  String states = retrievedObject?.state?.name.toString() ?? '';
  String pincode = retrievedObject?.pincode.toString() ?? '';
  String visitingCardUrl = retrievedObject?.visitingCardUrl ?? '';

  // logcat("address::", address);
  logcat("city::", city);
  logcat("states::", states);
  logcat("pincode::", pincode);
  logcat("visitingCardUrl::", visitingCardUrl);

  return phone.trim().isEmpty ||
      city.trim().isEmpty ||
      states.trim().isEmpty ||
      pincode.trim().isEmpty ||
      visitingCardUrl.trim().isEmpty;
}

launchPhoneCall(String phoneNumber) async {
  try {
    String url = 'tel:$phoneNumber'; // Add "+91" to the phone number
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    logcat("Error launching phone call:", e.toString());
  }
}

void lanchEmail(String email) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
  );
  // ignore: deprecated_member_use
  if (await canLaunch(emailLaunchUri.toString())) {
    // ignore: deprecated_member_use
    await launch(emailLaunchUri.toString());
  } else {
    throw 'Could not launch $emailLaunchUri';
  }
}

Future<void> launchWhatsApp(BuildContext context, String phoneNumber) async {
  // Sanitize phone number: remove spaces, dashes, parentheses, and '+' symbol
  String sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[\s-+()]+'), '');

  // Ensure the number is in international format with India's country code (+91)
  if (!sanitizedNumber.startsWith('91')) {
    // If the number doesn't start with '91', assume it's a local Indian number and add '+91'
    sanitizedNumber = '91$sanitizedNumber';
  }

  // Validate phone number length (India mobile numbers are typically 10 digits + country code)
  if (sanitizedNumber.length != 12) {
    // 2 for '91' + 10 digits
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Number'),
          content: const Text(
              'Please provide a valid 10-digit Indian mobile number.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    return;
  }

  final Uri whatsappUrl = Uri.parse('https://wa.me/+$sanitizedNumber');

  try {
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'WhatsApp is not installed.';
    }
  } catch (e) {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
            'WhatsApp is not installed. Please install it to continue.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

/// Shares business details (business name, email, phone, address) via WhatsApp.
/// Returns true if the operation is successful, false otherwise.
Future<bool> shareBusinessDetailsOnWhatsApp({
  required BuildContext context,
  required String phoneNumber,
  required String businessName,
  required String email,
  required String address,
}) async {
  // Sanitize phone number: remove spaces, dashes, parentheses, and '+' symbol
  String sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[\s-+()]+'), '');

  // Ensure the number is in international format with India's country code (+91)
  if (!sanitizedNumber.startsWith('91')) {
    sanitizedNumber = '91$sanitizedNumber';
  }

  // Validate phone number length (India mobile numbers are typically 10 digits + country code)
  if (sanitizedNumber.length != 12) {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Number'),
          content: const Text(
              'Please provide a valid 10-digit Indian mobile number.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  }

  // Construct the WhatsApp message with all details
  final String message = '''
*Business Details:*
*Name*: $businessName
*Email*: $email
*Phone*: $phoneNumber
*Address*: $address
'''
      .trim();

  // Construct the WhatsApp URL
  final Uri whatsappUrl = Uri.parse(
    'https://wa.me/$sanitizedNumber?text=${Uri.encodeComponent(message)}',
  );

  // Launch WhatsApp
  try {
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );
      return true;
    } else {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'WhatsApp is not installed. Please install it to continue.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return false;
    }
  } catch (e) {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Error opening WhatsApp: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  }
}

Future<bool> openBusinessLinkedIn({
  required BuildContext context,
  required String linkedInProfileUrl,
}) async {
  // Validate LinkedIn URL
  if (!linkedInProfileUrl.startsWith('https://www.linkedin.com/')) {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid URL'),
          content: const Text('Please provide a valid LinkedIn profile URL.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  }

  // Launch the LinkedIn profile
  try {
    final Uri uri = Uri.parse(linkedInProfileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } else {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Could not open LinkedIn profile.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return false;
    }
  } catch (e) {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content:
              const Text('An error occurred while opening LinkedIn profile.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  }
}

Future<bool> openBusinessFacebook({
  required BuildContext context,
  required String facebookProfileUrl,
}) async {
  // Validate Facebook URL
  if (!facebookProfileUrl.startsWith('https://www.facebook.com/')) {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid URL'),
          content: const Text('Please provide a valid Facebook profile URL.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  }

  // Launch the Facebook profile
  try {
    final Uri uri = Uri.parse(facebookProfileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } else {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Could not open Facebook profile.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return false;
    }
  } catch (e) {
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content:
              const Text('An error occurred while opening Facebook profile.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  }
}

String getStartDateOfCurrentMonth() {
  DateTime now = DateTime.now();

  // Start of the current month
  DateTime startDate = DateTime(now.year, now.month, 1);

  // Format start date
  String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);

  return formattedStartDate;
}

String getEndDateOfCurrentMonth() {
  DateTime now = DateTime.now();

  // End of the current month
  DateTime endDate = DateTime(now.year, now.month + 1, 0);

  // Format end date
  String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

  return formattedEndDate;
}

void shareOnWhatsApp(String message, String url) async {
  final whatsappUrl =
      Uri.parse("https://wa.me/?text=${Uri.encodeComponent('$message $url')}");

  if (await canLaunchUrl(whatsappUrl)) {
    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch WhatsApp';
  }
}

// Function to load the PNG image from the assets folder
Future<Uint8List> loadImageFromAssets(String assetName) async {
  final ByteData data = await rootBundle.load('assets/pngs/$assetName');
  return data.buffer.asUint8List();
}

Duration getAnimationDuration() {
  return const Duration(milliseconds: 10); // or any desired duration
}

bool isNewVersionAvailable(String currentVersion, String newVersion) {
  List<int> current = currentVersion.split('.').map(int.parse).toList();
  List<int> latest = newVersion.split('.').map(int.parse).toList();

  for (int i = 0; i < latest.length; i++) {
    if (i >= current.length || latest[i] > current[i]) return true;
    if (latest[i] < current[i]) return false;
  }
  return false;
}

getUnauthenticatedUser(BuildContext context, String key, String value) {
  if (key == value) {
    Navigator.pop(context);
    UserPreferences().logout();
    Get.offAll(const Signinscreen());
    return;
  }
}

Future<String?> getFirebaseToken() async {
  final openFirebaseTokenBox =
      await Hive.openBox<String>(AppConstants.openFirebaseTokenBox);
  var firebaseToken = openFirebaseTokenBox.get(AppConstants.storeFirebaseToken,
      defaultValue: '');
  return firebaseToken;
}

String extractPdfNameFromUrl(String url) {
  // Assuming the URL structure is like: http://example.com/indian_business_hub/storage/visiting_card_pdfs/JohnDoe/visiting_card_1.pdf
  Uri uri = Uri.parse(url);
  String path = uri.path;

  // Split the path into segments
  List<String> pathSegments = path.split('/');

  // The PDF name should be the last segment (the filename)
  String pdfFileName = pathSegments.last;

  // Remove the file extension (.pdf)
  String pdfNameWithoutExtension = pdfFileName.replaceAll('.pdf', '');

  // Return the extracted PDF name
  return pdfNameWithoutExtension;
}

Future<String?> downloadPDF(String url, String fileName) async {
  try {
    // Make HTTP request to download the PDF
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      // Ensure the fileName has .pdf extension
      final filePath =
          '${directory.path}/${fileName.endsWith('.pdf') ? fileName : '$fileName.pdf'}';
      // Write the PDF to a file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      print('Failed to download PDF: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error downloading PDF: $e');
    return null;
  }
}

Future<String?> downloadFile(String url, String fileName) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();

      // Save with the original file name and extension
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      print('Failed to download file: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error downloading file: $e');
    return null;
  }
}

String extractFileNameFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String path = uri.path;
  return path.split('/').last; // e.g., visiting_card_1.pdf or image123.jpg
}

Future<void> shareFile(String filePath) async {
  try {
    String mimeType = '';

    if (filePath.endsWith('.pdf')) {
      mimeType = 'application/pdf';
    } else if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
      mimeType = 'image/jpeg';
    } else if (filePath.endsWith('.png')) {
      mimeType = 'image/png';
    } else {
      mimeType = 'application/octet-stream'; // fallback
    }

    await Share.shareXFiles(
      [XFile(filePath, mimeType: mimeType)],
      text: '',
      subject: 'Shared File',
    );
  } catch (e) {
    print('Error sharing file: $e');
  }
}

Future<void> sharePDF(String filePath) async {
  try {
    // ignore: deprecated_member_use
    await Share.shareXFiles(
      [XFile(filePath, mimeType: 'application/pdf')],
      text: 'Check out my profile PDF!',
      subject: 'Profile PDF',
    );
  } catch (e) {
    print('Error sharing PDF: $e');
  }
}
