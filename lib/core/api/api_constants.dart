class ApiConstants {
  static const String baseUrl = 'https://ecommerce.routemisr.com/api/v1/';

  // Auth Endpoints
  static const String signIn = 'auth/signin';
  static const String signUp = 'auth/signup';
  static const String forgotPassword = 'auth/forgotPasswords';
  static const String verifyOtp = 'auth/verifyResetCode';
  static const String resetPassword = 'auth/resetPassword';

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

  // Cart Endpoints
  static const String cart = 'cart'; // GET, POST
  static const String addToCart = 'cart'; // POST
  static const String clearCart = 'cart'; // DELETE
  static const String removeCartItem = 'cart/'; // + itemId
  static const String updateCartItem = 'cart/'; // + itemId

  // Timeout
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
