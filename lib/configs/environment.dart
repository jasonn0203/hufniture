class Environment {
  static const String apiUrl = 'https://localhost:7245/api';
  static const String registerUrl = '$apiUrl/Authenticate/register';
  static const String loginUrl = '$apiUrl/Authenticate/login';

  static const String furnitureCategoryUrl = '$apiUrl/FurnitureCategory';
  static String furnitureCategoryProductUrl(String id) =>
      '$apiUrl/FurnitureCategory/GetFurnitureCategoryDetailsById/$id';
}
