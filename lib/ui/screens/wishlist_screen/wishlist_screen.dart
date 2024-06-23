import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:ionicons/ionicons.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Danh Sách Yêu Thích'),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Slidable(
            endActionPane: ActionPane(
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  flex: 1,
                  onPressed: (context) {},
                  backgroundColor: ColorConfig.primaryColor,
                  foregroundColor: Colors.white,
                  icon: Ionicons.trash_bin,
                  label: 'Xóa',
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                height: 150,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: ColorConfig.secondaryColor,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        '${Helpers.imgUrl}/kitchen_cart_2.png',
                        fit: BoxFit.contain,
                        width: 120,
                        height: 150,
                      ),
                    ),
                    const Positioned(
                        bottom: 8,
                        right: 8,
                        child: Hero(
                          tag: 'favorite-icon',
                          child: Icon(
                            Ionicons.heart,
                            color: ColorConfig.primaryColor,
                          ),
                        )),
                  ],
                ),
              ),
              title: Text(
                'SOFA ABC',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}
