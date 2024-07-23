import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/auth_screen/login_screen/login_screen.dart';
import 'package:hufniture/ui/screens/order_screen/order_list_screen/order_list_screen.dart';
import 'package:hufniture/ui/screens/profile_screen/profile_information/profile_information.dart';
import 'package:hufniture/ui/screens/profile_screen/profile_information/profile_update_screen.dart';
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
                _buildAvatar(context),
                SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
                _buildUserInfo(context, user),
                _buildUserPanel(context, user),
                SizedBox(height: ConstraintConfig.kSpaceBetweenItemsMedium),
                _buildUserAction(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, Map<String, dynamic> user) {
    return Column(
      children: [
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
      ],
    );
  }

  Expanded _buildUserAction(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildListTile(
            context,
            icon: Ionicons.settings_outline,
            title: 'Cài Đặt',
            onTap: () {
              RouteConfig.navigateTo(context, const ProfileSetting());
            },
          ),
          _buildListTile(
            context,
            icon: Ionicons.information_circle_outline,
            title: 'Trợ Giúp',
            onTap: () {},
          ),
          _buildListTile(
            context,
            icon: Ionicons.log_out_outline,
            title: 'Đăng Xuất',
            onTap: () => _showLogoutBottomSheet(context),
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      splashColor: ColorConfig.primaryColor.withOpacity(0.25),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: ColorConfig.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: Icon(
          icon,
          size: 25,
          color: ColorConfig.secondaryColor,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
      ),
    );
  }

  Future<void> _showLogoutBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      barrierColor: ColorConfig.primaryColor.withOpacity(0.2),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.2, // 20% of the screen height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Bạn có chắc muốn đăng xuất tài khoản ?'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        SharedPreferencesHelper.clear();
                        RouteConfig.navigateTo(
                          context,
                          LoginScreen(),
                          pushScreenType: PushScreenType.pushAndRemoveUntil,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Container _buildUserPanel(BuildContext context, Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPanelItem(
            context,
            icon: Ionicons.person,
            title: 'Cá Nhân',
            onTap: () {
              RouteConfig.navigateTo(
                context,
                const ProfileUpdateScreen(),
              );
            },
          ),
          Container(
            width: 2,
            height: 50,
            color: ColorConfig.secondaryColor,
          ),
          _buildPanelItem(
            context,
            icon: Ionicons.reader,
            title: 'Đơn Hàng',
            onTap: () {
              RouteConfig.navigateTo(context, OrderListScreen());
            },
          ),
        ],
      ),
    );
  }

  Column _buildPanelItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Icon(
            icon,
            color: ColorConfig.secondaryColor,
            size: 30,
          ),
        ),
        Text(
          title,
          style: TextStyle(color: ColorConfig.secondaryColor),
        ),
      ],
    );
  }

  Align _buildAvatar(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: CachedNetworkImage(
          width: ConstraintConfig.responsive(context, 150.0, 130.0, 120.0),
          height: ConstraintConfig.responsive(context, 150.0, 130.0, 120.0),
          fit: BoxFit.contain,
          imageUrl: 'https://loremflickr.com/320/240/user,face',
          placeholder: (context, url) => const LoadingIndicator(),
        ),
      ),
    );
  }
}
