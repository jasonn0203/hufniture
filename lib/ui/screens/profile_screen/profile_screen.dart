import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/auth_screen/login_screen/login_screen.dart';
import 'package:hufniture/ui/screens/order_screen/order_list_screen/order_list_screen.dart';
import 'package:hufniture/ui/screens/profile_screen/profile_information/profile_information.dart';
import 'package:hufniture/ui/screens/profile_screen/profile_setting/profile_setting.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:ionicons/ionicons.dart';

import 'package:hufniture/data/services/shared_preference_helper.dart'; // Import SharedPreferencesHelper

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Trang Cá Nhân'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: SharedPreferencesHelper.getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return Center(
                child: Text(
                  'Không thể tải thông tin người dùng',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            final user = snapshot.data!;

            return Column(
              children: [
                // Avatar
                //_buildAvatar(context),
                SizedBox(
                  height: ConstraintConfig.kSpaceBetweenItemsMedium,
                ),
                // Name and ID
                Text(
                  user['fullName'] ?? 'Tên người dùng',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'ID: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: user['id'] ?? 'ID người dùng',
                      ),
                    ],
                  ),
                ),
                // Profile custom and orders
                _buildUserPanel(context),
                SizedBox(
                  height: ConstraintConfig.kSpaceBetweenItemsMedium,
                ),
                // List of actions
                _buildUserAction(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Expanded _buildUserAction(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            splashColor: ColorConfig.primaryColor.withOpacity(0.25),
            onTap: () {
              RouteConfig.navigateTo(context, const ProfileSetting());
            },
            leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: ColorConfig.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: const Icon(
                  Ionicons.settings_outline,
                  size: 25,
                  color: ColorConfig.secondaryColor,
                )),
            title: Text(
              'Cài Đặt',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            splashColor: ColorConfig.primaryColor.withOpacity(0.25),
            onTap: () {},
            leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: ColorConfig.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: const Icon(
                  Ionicons.information_circle_outline,
                  size: 25,
                  color: ColorConfig.secondaryColor,
                )),
            title: Text(
              'Trợ Giúp',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            splashColor: ColorConfig.primaryColor.withOpacity(0.25),
            onTap: () {
              // Show log out bottom sheet confirm
              _showLogOuBottomSheet(context);
            },
            leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: ColorConfig.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: const Icon(
                  Ionicons.log_out_outline,
                  size: 25,
                  color: ColorConfig.secondaryColor,
                )),
            title: Text(
              'Đăng Xuất',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> _showLogOuBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      barrierColor: ColorConfig.primaryColor.withOpacity(0.2),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.2, //20% of the screen height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Bạn có chắc muốn đăng xuất tài khoản ?'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Không',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      isPrimary: false,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppButton(
                      text: 'Có',
                      onPressed: () {
                        // Handle Logout
                        SharedPreferencesHelper.clear();
                        RouteConfig.navigateTo(context, LoginScreen(),
                            pushScreenType: PushScreenType.pushAndRemoveUntil);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Container _buildUserPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
          color: ColorConfig.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              RouteConfig.navigateTo(context, const ProfileInformation());
            },
            child: const Column(
              children: [
                Icon(
                  Ionicons.person,
                  color: ColorConfig.secondaryColor,
                  size: 30,
                ),
                Text(
                  'Cá Nhân',
                  style: TextStyle(color: ColorConfig.secondaryColor),
                )
              ],
            ),
          ),
          Container(
            width: 2,
            height: 50,
            color: ColorConfig.secondaryColor,
          ),
          GestureDetector(
            onTap: () {
              RouteConfig.navigateTo(context, OrderListScreen());
            },
            child: const Column(
              children: [
                Icon(
                  Ionicons.reader,
                  color: ColorConfig.secondaryColor,
                  size: 30,
                ),
                Text(
                  'Đơn Hàng',
                  style: TextStyle(color: ColorConfig.secondaryColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Align _buildAvatar(BuildContext context) {
  //   return Align(
  //     alignment: Alignment.center,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(200),
  //       child: Image.network(
  //         'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436200.jpg?size=338&ext=jpg&ga=GA1.1.1141335507.1717891200&semt=ais_user',
  //         width: ConstraintConfig.responsive(context, 150.0, 130.0, 120.0),
  //         height: ConstraintConfig.responsive(context, 150.0, 130.0, 120.0),
  //         fit: BoxFit.contain,
  //         loadingBuilder: (context, child, loadingProgress) {
  //           if (loadingProgress == null) return child;
  //           return const LoadingIndicator();
  //         },
  //       ),
  //     ),
  //   );
  // }
}
