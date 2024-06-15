import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';

class ProductPostReview extends StatefulWidget {
  const ProductPostReview({super.key});

  @override
  State<ProductPostReview> createState() => _ProductPostReviewState();
}

class _ProductPostReviewState extends State<ProductPostReview> {
  final TextEditingController reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
              AppButton(
                  text: 'Gửi đánh giá',
                  onPressed: () {
                    // Check valid form value
                    if (_formKey.currentState!.validate()) {
                      // ignore: avoid_print
                      print('OK');
                    }
                  }),
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
