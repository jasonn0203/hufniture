import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:ionicons/ionicons.dart';

class CategoryHome extends StatelessWidget {
  const CategoryHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
              color: ColorConfig.secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          height: 60,
          width: 60,
          child: const Icon(
            Ionicons.bed,
            color: ColorConfig.accentColor,
          ),
        ),
      ),
    );
  }
}
