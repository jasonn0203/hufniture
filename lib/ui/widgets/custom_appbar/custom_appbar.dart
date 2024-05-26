import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:ionicons/ionicons.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  @override
  // ignore: todo
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const CustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Ionicons.arrow_back_outline,
          color: ColorConfig.darkIconColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: ColorConfig.appbarColor),
      ),
    );
  }
}
