import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hufniture/configs/color_config.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key, required this.item, required this.function});
  final List<String> item;
  final Function(String) function;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: item.length,
      gridDelegate:
          // Number of column
          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
      itemBuilder: (context, index) {
        // bool isLast = index == 7 - 1; // config length later
        // double screenWidth = ConstraintConfig.getWidth(context);

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {
              function(item[index]);
            },
            child: Container(
              decoration: const BoxDecoration(
                color: ColorConfig.appbarColor,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              height: index % 2 == 0
                  ? 128
                  : 256, // adjust height base on odd / even
              child: Center(
                  child: Text(
                textAlign: TextAlign.center,
                item[index],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w400),
              )),
            ),
          ),
        );
      },
    );
  }
}
