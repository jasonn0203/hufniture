import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/models/review_response.dart';
import 'package:hufniture/data/services/ReviewService/review_service.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
import 'package:hufniture/ui/screens/product_screen/product_review/product_post_review.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';

class ProductReview extends StatefulWidget {
  final String productId;

  const ProductReview({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  late Future<List<ReviewResponse>> _reviewsFuture;
  late Future<Map<String, dynamic>?> _userFuture;

  Future<void> _refreshReviews() async {
    setState(() {
      _reviewsFuture =
          ReviewService.getReviewsByProductId(widget.productId).then((reviews) {
        // Sắp xếp đánh giá theo thời gian tạo từ mới nhất đến cũ nhất
        reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return reviews;
      });
    });
  }

  Future<void> _deleteReview(String reviewId) async {
    try {
      await ReviewService.deleteReview(reviewId);
      _refreshReviews(); // Refresh reviews after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa đánh giá: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshReviews(); // Gọi hàm để tải và sắp xếp đánh giá ngay từ đầu
    _userFuture = SharedPreferencesHelper.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Đánh giá sản phẩm'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<List<ReviewResponse>>(
                  future: _reviewsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('0 đánh giá');
                    } else {
                      return Text('${snapshot.data!.length} đánh giá');
                    }
                  },
                ),
                GestureDetector(
                  onTap: () {
                    RouteConfig.navigateTo(
                      context,
                      ProductPostReview(
                        productId: widget.productId,
                        onReviewSubmitted: _refreshReviews,
                      ),
                    );
                  },
                  child: const Text(
                    'Viết đánh giá',
                    style: TextStyle(
                      color: ColorConfig.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            Expanded(
              child: FutureBuilder<List<ReviewResponse>>(
                future: _reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            '${Helpers.imgUrl}/no_review.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Text('Chưa có đánh giá nào')
                        ],
                      ),
                    );
                  } else {
                    return FutureBuilder<Map<String, dynamic>?>(
                      future: _userFuture,
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (!userSnapshot.hasData) {
                          return const Center(
                              child:
                                  Text('Không thể lấy thông tin người dùng'));
                        } else {
                          final user = userSnapshot.data;
                          final userId = user?['id'] ?? '';

                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final review = snapshot.data![index];
                              final canDelete = review.userId == userId;

                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  tileColor: ColorConfig.secondaryColor,
                                  leading: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://loremflickr.com/320/240/user,face',
                                      placeholder: (context, url) =>
                                          const SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Center(
                                          child: LoadingIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Center(
                                          child: Icon(Icons.error),
                                        ),
                                      ),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(review.userFullName),
                                  titleTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  subtitle: Text(review.content),
                                  trailing: canDelete
                                      ? IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            final confirmed = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Xóa đánh giá'),
                                                  content: const Text(
                                                      'Bạn có chắc chắn muốn xóa đánh giá này?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: const Text('Hủy'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child: const Text('Xóa'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirmed) {
                                              await _deleteReview(review.id);
                                            }
                                          },
                                        )
                                      : null,
                                  onLongPress: canDelete
                                      ? () async {
                                          final confirmed = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Xóa đánh giá'),
                                                content: const Text(
                                                    'Bạn có chắc chắn muốn xóa đánh giá này?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: const Text('Hủy'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: const Text('Xóa'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (confirmed) {
                                            await _deleteReview(review.id);
                                          }
                                        }
                                      : null,
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
