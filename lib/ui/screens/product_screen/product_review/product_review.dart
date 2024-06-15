import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/product_screen/product_review/product_post_review.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';

class ProductReview extends StatefulWidget {
  const ProductReview({super.key});

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Đánh giá sản phẩm'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total reviews
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('20 đánh giá'),
                GestureDetector(
                    onTap: () {
                      RouteConfig.navigateTo(
                          context, const ProductPostReview());
                    },
                    child: const Text(
                      'Viết đánh giá',
                      style: TextStyle(
                          color: ColorConfig.primaryColor,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),

            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor: ColorConfig.secondaryColor,
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436200.jpg?size=338&ext=jpg&ga=GA1.1.1141335507.1717891200&semt=ais_user',
                        ),
                      ),
                    ),
                    title: const Text('Jason Huỳnh'),
                    titleTextStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    subtitle: const Text(
                        'Ghế có màu rất đẹp,Ghế có màu rất đẹp,Ghế có màu rất đẹp'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
