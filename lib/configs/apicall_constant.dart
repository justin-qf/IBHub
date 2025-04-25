class ApiUrl {
  // LOCAL
  // static const baseUrl = "http://192.168.1.2/";
  // static const buildApiUrl = '${baseUrl}swooosh_admin/api/';
  // static const imageUrl = '${baseUrl}swooosh_admin/public/storage/';

  //LIVE
  static const liveUrl = "http://192.168.1.21/indian_business_hub/";
  static const buildApiUrl = '${liveUrl}api/';
  static const imageUrl = '${liveUrl}public/storage';

  //AUTH
  static const login = "login";
  static const forgotPass = "forgot-password-otp";
  static const verifyForgotOtp = "verify-otp";
  static const updateForgotPassword = "reset-password";
  static const changePassword = "change_password";
  static const getState = 'states/dropdown';
  static const getCity = 'cities/dropdown';
  static const getCategories = 'categories/dropdown';
  static const getCategorieList = 'categories/list';
  static const getSearch = 'searchlist';
  static const logout = 'logout';
  static const getServiceList = 'services/list';
  static const addService = 'services/create';
  static const businessesList = 'businesses/list';
}
