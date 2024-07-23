import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/models/category.dart';
import 'package:hufniture/ui/screens/category/category_by_room_screen/category_room_by_name_type.dart';

class CategoryHome extends StatelessWidget {
  const CategoryHome({super.key, required this.category});
  final FurnitureCategoryList category;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          RouteConfig.navigateTo(
              context,
              CategoryRoomByNameTypeScreen(
                categoryName: category.name,
                categoryId: category.id,
              ));
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
              color: ColorConfig.secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          height: 60,
          width: 60,
          child: Image.network(
            category.categoryIcon!,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
