class Environment {
  static const String apiUrl = 'https://localhost:7245/api';
  static const String registerUrl = '$apiUrl/Authenticate/register';
  static const String loginUrl = '$apiUrl/Authenticate/login';
  static const String checkEmailUrl = '$apiUrl/Authenticate/CheckEmail';
  static const String forgotPasswordUrl = '$apiUrl/Authenticate/ForgotPassword';
  static const String bestSellingProductUrl =
      '$apiUrl/FurnitureProduct/GetBestSellingProduct';

  static const String furnitureCategoryUrl = '$apiUrl/FurnitureCategory';
  static String furnitureCategoryProductUrl(String id) =>
      '$apiUrl/FurnitureCategory/GetFurnitureCategoryDetailsById/$id';

  static String furnitureProductDetailUrl(String id) =>
      '$apiUrl/FurnitureProduct/GetFurnitureProductById/$id';

  static String getRandomProductList(int take) =>
      '$apiUrl/FurnitureProduct/GetRandomFurnitureProducts?take=$take';

  static String filterProductUrl =
      '$apiUrl/FurnitureProduct/GetFilteredProducts';

  static String addReviewUrl = '$apiUrl/Review/AddReview';
  static String getReviewByProductId(String id) =>
      '$apiUrl/Review/GetReviewsByProductId/$id';
  static String deleteReviewUrl(String id) => '$apiUrl/Review/DeleteReview/$id';

  static String updateUserInfo(String userId) =>
      '$apiUrl/Authenticate/UpdateUser/$userId';

  static String getUserInfo(String userId) =>
      '$apiUrl/Authenticate/GetUserInfo/$userId';

  static String placeOrder = '$apiUrl/Order/PlaceOrder';
  static String getOrderListByUserId(String userId) =>
      '$apiUrl/Order/GetOrdersByUserId/$userId';

  static String changePasswordUrl(String userId) =>
      '$apiUrl/Authenticate/ChangePassword/$userId';
}
