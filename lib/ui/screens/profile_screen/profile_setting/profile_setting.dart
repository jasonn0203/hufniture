import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/profile_screen/password_setting/password_setting.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:ionicons/ionicons.dart';

class ProfileSetting extends StatelessWidget {
  const ProfileSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Cài Đặt'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              splashColor: ColorConfig.primaryColor.withOpacity(0.25),
              onTap: () {
                // Navigate password setting
                RouteConfig.navigateTo(context, const PasswordSetting());
              },
              leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: ColorConfig.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: const Icon(
                    Ionicons.key_outline,
                    size: 25,
                    color: ColorConfig.secondaryColor,
                  )),
              title: Text(
                'Cài Đặt Mật Khẩu',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              trailing: const Icon(Ionicons.chevron_forward_outline),
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              splashColor: ColorConfig.primaryColor.withOpacity(0.25),
              onTap: () {
                _showRemoveAccountBottomSheet(context);
              },
              leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: ColorConfig.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: const Icon(
                    Ionicons.person_remove_outline,
                    size: 25,
                    color: ColorConfig.secondaryColor,
                  )),
              title: Text(
                'Xóa tài khoản',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              trailing: const Icon(Ionicons.chevron_forward_outline),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showRemoveAccountBottomSheet(BuildContext context) {
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
              const Text('Bạn có chắc muốn xóa tài khoản ?'),
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
}
