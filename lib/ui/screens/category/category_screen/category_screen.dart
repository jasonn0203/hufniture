import 'package:flutter/material.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/category/category_by_room_screen/category_by_room_screen.dart';
import 'package:hufniture/ui/widgets/category/category_grid/category_grid.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});
  final List<String> rooms = [
    "Phòng Ngủ",
    "Phòng Bếp",
    "Phòng Tắm",
    "Phòng Khách",
    "Phòng Thờ",
    "Phòng Làm Việc",
    "Phòng Ăn",
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Scaffold(
          appBar: const CustomAppbar(title: 'Danh Mục Phòng'),
          body: CategoryGrid(
            item: rooms,
            function: (String room) {
              RouteConfig.navigateTo(
                  context, CategoryByRoomScreen(roomName: room));
            },
          ),
        ),
      ),
    );
  }
}
