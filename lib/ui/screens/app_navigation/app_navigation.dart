import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/ui/screens/cart_screen/cart_screen.dart';
import 'package:hufniture/ui/screens/category/category_screen/category_screen.dart';
import 'package:hufniture/ui/screens/home_screen/home_screen.dart';
import 'package:hufniture/ui/screens/profile_screen/profile_screen.dart';
import 'package:hufniture/ui/screens/wishlist_screen/wishlist_screen.dart';
import 'package:ionicons/ionicons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

// Bottom Navigation collection
List<Widget> pages = [
  const HomeScreen(),
  CategoryScreen(),
  const CartScreen(),
  const WishlistScreen(),
  const ProfileScreen()
];

class _AppNavigationState extends State<AppNavigation> {
  var _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        itemPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        unselectedItemColor: ColorConfig.accentColor,
        selectedItemColor: ColorConfig.primaryColor,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Ionicons.home_outline),
            activeIcon: const Icon(Ionicons.home_sharp),
            title: const Text("Trang Chủ"),
          ),

          /// Category
          SalomonBottomBarItem(
            icon: const Icon(Ionicons.list_outline),
            activeIcon: const Icon(Ionicons.list_sharp),
            title: const Text("Danh Mục"),
          ),

          /// Cart
          SalomonBottomBarItem(
            icon: const Icon(Ionicons.cart_outline),
            activeIcon: const Icon(Ionicons.cart_sharp),
            title: const Text("Giỏ Hàng"),
          ),

          /// Wishlist
          SalomonBottomBarItem(
            icon: const Icon(Ionicons.heart_outline),
            activeIcon: const Icon(Ionicons.heart_sharp),
            title: const Text("Wishlist"),
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Ionicons.person_outline),
            activeIcon: const Icon(Ionicons.person),
            title: const Text("Cá Nhân"),
          ),
        ],
      ),
    );
  }
}
