// Base URL for the API
const String baseUrlDevelopment = 'https://stage-api.amarshoday.com/';
const String baseUrlProduction = 'https://api.amar-shodai.com/';

// Endpoint URLs
class ApiEndpoints {
 static const String login = '/user/login';
 static const String logout = '/user/logout';
 static const String signup = '/user/signup';
 static const String profile = '/user/profile';
 static const String addresses = '/user/addresses';
 static const String districts = '/user/districts';
 static const String thanas = '/user/thanas';
 static const String areas = '/user/areas';
 static const String carts = '/user/carts';
 static const String favourites = '/user/favourites';
 static const String orders = '/user/orders';
 static const String homePageImages = '/user/home_page/images';
 static const String homePageCategories = '/user/home_page/categories';
 static const String homePageSubCategories = '/user/home_page/sub_categories';
 static const String products = '/user/products';
 static const String productSuggestions = '/user/products/suggestions';
 static const String categories = '/user/categories';
 static const String subCategories = '/user/categories/sub_categories';
 static const String recipients = '/recipients';
 static const String addRecipient = '/recipients/add';
 static const String favouriteProducts = '/user/favourites/products';
 static const String sendOtp = '/user/send_otp';
 static const String verifyOtp = '/user/verify_otp';
 static const String checkAppUpdate = '/user/check_app_update';
 static const String requestResetOtp = '/user/request_reset_otp';
 static const String verifyResetOtp = '/user/verify_reset_otp';
 static const String resetPassword = '/user/reset_password';
 static const String search = 'https://amar-shodai.com/search';
}
