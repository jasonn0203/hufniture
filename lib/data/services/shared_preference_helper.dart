import 'package:hufniture/data/helpers/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static const String _authTokenKey = 'token';
  static const String _userKey = 'user';
  static const String _cartKey = 'cart';

  static const String _wishlistKey = 'wishlist';

  // Save auth token
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  // Get auth token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // Save user information
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  // Get user information
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      return jsonDecode(userString) as Map<String, dynamic>;
    }
    return null;
  }

//--------CART
  // Save cart items
  static Future<void> saveCartItems(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartItemStrings =
        cartItems.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList(_cartKey, cartItemStrings);
  }

  // Get cart items
  static Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cartItemStrings = prefs.getStringList(_cartKey);
    if (cartItemStrings != null) {
      return cartItemStrings
          .map((itemString) => CartItem.fromMap(jsonDecode(itemString)))
          .toList();
    }
    return [];
  }

  // Clear cart items
  static Future<void> clearCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

// WISHLIST
  // Save wishlist items
  static Future<void> saveWishlistItems(List<String> wishlistItems) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_wishlistKey, wishlistItems);
  }

  // Get wishlist items
  static Future<List<String>> getWishlistItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_wishlistKey) ?? [];
  }

  // Clear wishlist items
  static Future<void> clearWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wishlistKey);
  }

  // Clear all stored data
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
