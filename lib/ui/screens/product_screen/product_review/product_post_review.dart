import 'package:flutter/material.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';

class ProductPostReview extends StatefulWidget {
  const ProductPostReview({super.key});

  @override
  State<ProductPostReview> createState() => _ProductPostReviewState();
}

class _ProductPostReviewState extends State<ProductPostReview> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppbar(title: 'Viết đánh giá'),
    );
  }
}
