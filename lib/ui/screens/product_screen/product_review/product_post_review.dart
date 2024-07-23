import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/data/services/ReviewService/review_service.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';

class ProductPostReview extends StatefulWidget {
  final String productId;
  final VoidCallback onReviewSubmitted;

  const ProductPostReview({
    Key? key,
    required this.productId,
    required this.onReviewSubmitted,
  }) : super(key: key);

  @override
  State<ProductPostReview> createState() => _ProductPostReviewState();
}

class _ProductPostReviewState extends State<ProductPostReview> {
  final TextEditingController reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final user = await SharedPreferencesHelper.getUser();
      if (user != null) {
        final userId = user['id']; // Adjust based on your user model
        final content = reviewController.text;
        try {
          await ReviewService.addReview(widget.productId, userId, content);
          // Handle success, e.g., show a confirmation message
          widget.onReviewSubmitted(); // Notify that review was submitted
          Navigator.pop(context);
        } catch (e) {
          // Handle error, e.g., show an error message
          print('Failed to submit review: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Viết đánh giá'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
              ),
              Expanded(
                child: TextFormField(
                  controller: reviewController,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  cursorColor: ColorConfig.primaryColor,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      filled: true,
                      fillColor: ColorConfig.secondaryColor,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(18)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: ColorConfig.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hãy nhập nội dung để đánh giá';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
              ),
              AppButton(text: 'Gửi đánh giá', onPressed: _submitReview),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
