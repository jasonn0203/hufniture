import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:ionicons/ionicons.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isCenterTitle;
  final bool isHomePage;

  @override
  // ignore: todo
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const CustomAppbar(
      {super.key,
      required this.title,
      this.isCenterTitle = true,
      this.isHomePage = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: IconButton(
      //   icon: const Icon(
      //     Ionicons.arrow_back_outline,
      //     color: ColorConfig.darkIconColor,
      //   ),
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      // ),
      surfaceTintColor: ColorConfig.primaryColor,
      automaticallyImplyLeading: true,
      centerTitle: isCenterTitle,
      actions: [
        if (isHomePage == true)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorConfig.primaryColor,
                  borderRadius: BorderRadius.circular(30.0)),
              child: IconButton(
                icon: const Icon(
                  Ionicons.search,
                  color: ColorConfig.secondaryColor,
                ),
                onPressed: () {},
              ),
            ),
          )
      ],
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: ColorConfig.accentColor),
        ),
      ),
    );
  }
}
