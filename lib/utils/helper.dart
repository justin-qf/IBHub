import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibh/configs/colors_constant.dart';
import 'package:ibh/configs/font_constant.dart';
import 'package:ibh/utils/log.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

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

String getCurrentDate() {
  DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

String getCurrentTime() {
  DateTime now = DateTime.now();
  return DateFormat('HH:mm:ss').format(now);
}

futureDelay(Function onPerform, {bool? fromSplash, bool? isOneSecond}) async {
  return Future.delayed(
    fromSplash == true
        ? const Duration(seconds: 3)
        : isOneSecond == true
            ? const Duration(seconds: 1)
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

// launchPhoneCall(String phoneNumber) async {
//   try {
//     String url = 'tel:$phoneNumber'; // Add "+91" to the phone number
//     // ignore: deprecated_member_use
//     if (await canLaunch(url)) {
//       // ignore: deprecated_member_use
//       await launch(url, forceSafariVC: false);
//     } else {
//       throw 'Could not launch $url';
//     }
//   } catch (e) {
//     logcat("Error launching phone call:", e.toString());
//   }
// }

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

// Function to load the PNG image from the assets folder
Future<Uint8List> loadImageFromAssets(String assetName) async {
  final ByteData data = await rootBundle.load('assets/pngs/$assetName');
  return data.buffer.asUint8List();
}

Duration getAnimationDuration() {
  return const Duration(milliseconds: 10); // or any desired duration
}
