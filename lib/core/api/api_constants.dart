class ApiConstants {
  static const String baseUrl = 'https://ecommerce.routemisr.com/api/v1/';

  // Auth Endpoints
  static const String signIn = 'auth/signin';
  static const String signUp = 'auth/signup';
  static const String forgotPassword = 'auth/forgotPasswords';
  static const String verifyOtp = 'auth/verifyResetCode';
  static const String resetPassword = 'auth/resetPassword';
  static const String updatePassword = 'users/changeMyPassword';
  static const String updateUserData = 'users/updateMe';
  static const String verifyToken = 'auth/verifyToken';

  // Categories
  static const String categories = 'categories';
  static const String categoryById = 'categories/';

  // SubCategories
  static const String subCategories = 'subcategories';
  static const String subCategoryById = 'subcategories/';
  static const String subCategoriesOnCategory = 'subcategories/category/';

  // Brands
  static const String brands = 'brands';
  static const String brandById = 'brands/';

  // Products
  static const String products = 'products';
  static const String productById = 'products/';

  // Wishlist
  static const String wishlist = 'wishlist';
  static const String addToWishlist = 'wishlist';
  static const String removeFromWishlist = 'wishlist/';
  static const String getUserWishlist = 'wishlist';

  // Addresses
  static const String addresses = 'addresses';

  // Cart Endpoints
  static const String cart = 'cart';
  static const String cartV2 = 'cart'; // Same endpoint usually, but V2 might differ in some APIs

  // Reviews
  static const String reviews = 'reviews';

  // Orders
  static const String orders = 'orders';
  static const String checkoutSession = 'orders/checkout-session/';

  // Timeout
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
