class ApiUrl {
  // LOCAL
  static const baseUrl = "http://192.168.1.30/indian_business_hub/";
  // static const buildApiUrl = '${baseUrl}swooosh_admin/api/';
  // static const imageUrl = '${baseUrl}swooosh_admin/public/storage/';

  //LIVE
  // static const liveUrl = "https://indianbusinesshub.in/";

  //  "https://indianbusinesshub.in/";

  static const buildApiUrl = '${baseUrl}api/';
  static const imageUrl = '${baseUrl}public/storage';

  //AUTH
  static const login = "login";
  static const profile = "profile";
  static const forgotPass = "forgot-password-otp";
  static const verifyForgotOtp = "verify-otp";
  static const updateForgotPassword = "reset-password";
  static const changePassword = "change-password";
  static const getState = 'states/dropdown';
  static const getCity = 'cities/dropdown';
  static const getCategories = 'categories/dropdown';
  static const getCategorieList = 'categories/list';
  static const getSearch = 'searchlist';
  static const logout = 'logout';
  static const getServiceList = 'services/list';
  static const addService = 'services/create';
  static const businessesList = 'businesses/list';
  static const reviewList = 'businesses/review/list';
  static const addReview = 'businesses/review/create';
  // static const getState = 'state_list';
  // static const getCity = 'city_list';
  static const register = 'register';
  static const pdfDownload = 'user/visiting-card';
  static const states = 'states/dropdown';
  static const city = 'cities/dropdown/';
  static const createservice = 'services/create';
  static const updateService = 'services/edit/';
  static const deleteService = 'services/delete/';
  static const updateProfile = 'profile/update';
  static const addToFav = 'businesses/favorite/create';
  static const removeToFav = 'businesses/favorite/delete';
  static const favList = 'businesses/favorite/list';
  static const appUpdate = 'app_updates';
  static const emailVerificationOtp = 'email-verification-otp';
  static const emailVerificationVerifyOtp = 'email-verification-verify-otp';
  static const changeStatus = 'services/change-status';
  static const verification = 'document-upload/type/list';

  //modified
  static const updateLOgo = 'profile/update-logo';
  static const updateBussiness = 'profile/update-business';
  static const documentcreate = 'document-upload/create';
  static const documentupdate = 'document-upload/edit/';
  static const deleterequest = 'delete-request';

  //notification
  static const notification = 'notification/list';
  static const notificationDelete = 'notification/delete/';

  //google auth
  static const authCallback = 'auth/google/callback';

  static const contactUS = 'customer-care/create';

  // /auth/google/callback
}
