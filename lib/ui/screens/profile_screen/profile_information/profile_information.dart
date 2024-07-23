// // ignore_for_file: constant_identifier_names

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hufniture/configs/color_config.dart';
// import 'package:hufniture/configs/constraint_config.dart';
// import 'package:hufniture/configs/regex_validation.dart';
// import 'package:hufniture/data/services/AuthService/auth_service.dart';
// import 'package:hufniture/ui/widgets/buttons/app_button.dart';
// import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
// import 'package:hufniture/ui/widgets/input/app_input.dart';
// import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';

// enum Gender { Male, Female }

// class ProfileInformation extends StatefulWidget {
//   const ProfileInformation({super.key, required this.userId});

//   final String userId;

//   @override
//   State<ProfileInformation> createState() => _ProfileInformationState();
// }

// class _ProfileInformationState extends State<ProfileInformation> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _birthdateController = TextEditingController();

//   Gender? _gender;
//   final AuthService _authService = AuthService();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _birthdateController.dispose();
//     super.dispose();
//   }

//   Future<void> _updateUserInfo() async {
//     final Map<String, dynamic> userInfo = {
//       'FullName': _nameController.text,
//       'PhoneNumber': _phoneController.text,
//       'BirthDate': _birthdateController.text.isNotEmpty
//           ? DateFormat('dd-MM-yyyy')
//               .parse(_birthdateController.text)
//               .toIso8601String()
//           : null,
//       'Gender': _gender?.toString().split('.').last,
//     };

//     final bool success = await _authService.updateUser(widget.userId, userInfo);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(success
//             ? 'Cập nhật thông tin thành công!'
//             : 'Cập nhật thông tin thất bại!'),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppbar(title: 'Thông tin cá nhân'),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           _buildUserAvatar(context),
//           SizedBox(height: ConstraintConfig.kSpaceBetweenItemsLarge),
//           _buildUserNameAndID(context),
//           SizedBox(height: ConstraintConfig.kSpaceBetweenItemsLarge),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildInputField(
//                       controller: _nameController,
//                       label: 'Tên',
//                       hintText: 'Jathan Đỗ'),
//                   SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
//                   _buildInputField(
//                     controller: _emailController,
//                     label: 'Email',
//                     hintText: 'abc@gmail.com',
//                     inputType: TextInputType.emailAddress,
//                   ),
//                   SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
//                   _buildInputField(
//                     controller: _phoneController,
//                     label: 'Số điện thoại',
//                     hintText: '0909 255 761',
//                     inputType: TextInputType.phone,
//                     formatter: [
//                       FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                       FilteringTextInputFormatter.digitsOnly,
//                     ],
//                   ),
//                   SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
//                   _buildDateInputField(context),
//                   SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
//                   _buildGenderSelection(),
//                   SizedBox(height: ConstraintConfig.kSpaceBetweenItemsLarge),
//                   AppButton(text: 'Cập Nhật', onPressed: _updateUserInfo),
//                   SizedBox(height: ConstraintConfig.kSpaceBetweenItemsLarge),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required String hintText,
//     TextInputType inputType = TextInputType.text,
//     List<TextInputFormatter>? formatter,
//     String? Function(String?)? validator,
//     VoidCallback? onTap,
//   }) {
//     return AppInput(
//       controller: controller,
//       label: label,
//       hintText: hintText,
//       inputType: inputType,
//       formatter: formatter,
//       validator: validator,
//       onTap: onTap,
//     );
//   }

//   Widget _buildDateInputField(BuildContext context) {
//     return AppInput(
//       suffixIcon: const Icon(Ionicons.calendar_outline),
//       controller: _birthdateController,
//       label: 'Ngày sinh',
//       hintText: 'Ngày sinh',
//       validator: (value) => (value?.isEmpty ?? true) ? 'Hãy chọn ngày!' : null,
//       onTap: () async =>
//           await RegexValidation.formatDate(context, _birthdateController),
//     );
//   }

//   Widget _buildGenderSelection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Giới tính',
//           style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                 color: ColorConfig.mainTextColor,
//                 fontWeight: FontWeight.w600,
//               ),
//         ),
//         SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             _buildRadioGender(Gender.Male, 'Nam'),
//             _buildRadioGender(Gender.Female, 'Nữ'),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRadioGender(Gender gender, String title) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
//         decoration: const BoxDecoration(
//           color: ColorConfig.secondaryColor,
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Radio<Gender>(
//               fillColor: MaterialStateProperty.all(ColorConfig.primaryColor),
//               value: gender,
//               groupValue: _gender,
//               onChanged: (Gender? value) => setState(() => _gender = value),
//             ),
//             Text(title),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUserAvatar(BuildContext context) {
//     return Stack(
//       children: [
//         Align(
//           alignment: Alignment.center,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(200),
//             child: CachedNetworkImage(
//               width: ConstraintConfig.responsive(context, 150.0, 130.0, 120.0),
//               height: ConstraintConfig.responsive(context, 150.0, 130.0, 120.0),
//               fit: BoxFit.contain,
//               imageUrl: 'https://i.postimg.cc/9F20MjSX/image.png',
//               placeholder: (context, url) => const LoadingIndicator(),
//             ),
//           ),
//         ),
//         Positioned(
//           right: ConstraintConfig.getWidth(context) / 2 - 50,
//           bottom: 0,
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: ColorConfig.primaryColor,
//               borderRadius: BorderRadius.circular(100),
//             ),
//             child: IconButton(
//               iconSize: 20,
//               onPressed: () {},
//               icon: const Icon(Ionicons.camera_outline,
//                   color: ColorConfig.accentColor),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildUserNameAndID(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       width: double.infinity,
//       color: ColorConfig.secondaryColor,
//       child: Column(
//         children: [
//           Text(
//             '',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           RichText(
//             text: TextSpan(
//               style: Theme.of(context).textTheme.bodyMedium,
//               children: <TextSpan>[
//                 const TextSpan(
//                   text: 'ID: ',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 TextSpan(
//                   text: widget.userId,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
