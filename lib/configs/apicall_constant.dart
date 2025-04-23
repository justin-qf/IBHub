class ApiUrl {
  // LOCAL
  // static const baseUrl = "http://192.168.1.2/";
  // static const buildApiUrl = '${baseUrl}swooosh_admin/api/';
  // static const imageUrl = '${baseUrl}swooosh_admin/public/storage/';

  //LIVE
  static const liveUrl = "https://queryfinders.com/swooosh_new/";
  static const buildApiUrl = '${liveUrl}api/';
  static const imageUrl = '${liveUrl}public/storage';

  //AUTH
  static const login = "login";
  static const forgotPass = "forgot_password";
  static const verifyForgotOtp = "check_forgot_password_otp";
  static const updateForgotPassword = "update_forgot_password";
  static const changePassword = "change_password";
  static const getState = 'state_list';
  static const getCity = 'city_list';
}
