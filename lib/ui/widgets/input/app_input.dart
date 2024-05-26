import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:ionicons/ionicons.dart';

class AppInput extends StatefulWidget {
  final String label;
  final String hintText;
  final TextInputType inputType;
  final bool isObscure;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? formatter;

  const AppInput({
    super.key,
    required this.label,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.isObscure = false,
    this.suffixIcon,
    required this.controller,
    this.validator,
    this.onChanged,
    this.formatter,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    // Init value of isObscure ( default is false )
    isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: ColorConfig.mainTextColor, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: ConstraintConfig.kSpaceBetweenItemsSmall,
        ),
        // Field
        TextFormField(
          controller: widget.controller,
          cursorColor: Colors.black,
          style: const TextStyle(color: ColorConfig.mainTextColor),
          maxLines: 1,
          obscureText: isObscure,
          validator: widget.validator,
          onChanged: widget.onChanged,
          keyboardType: widget.inputType,
          inputFormatters: widget.formatter,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
            // Handle toggle suffix icon
            suffixIcon: widget.suffixIcon ??
                (widget.isObscure
                    ? IconButton(
                        icon: Icon(
                          isObscure ? Ionicons.eye : Ionicons.eye_off,
                        ),
                        onPressed: () {
                          // Handle show/hide password
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      )
                    : null),
            hintText: widget.hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: ColorConfig.accentColor),
            filled: true,
            fillColor: ColorConfig.secondaryColor,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: ColorConfig.primaryColor, width: 1),
              borderRadius: BorderRadius.circular(18.0),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(18)),
          ),
        )
      ],
    );
  }
}
