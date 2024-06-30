import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/app_navigation/app_navigation.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';
import 'package:ionicons/ionicons.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderStatus;

  const TrackOrderScreen({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Theo Dõi Đơn Hàng'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              width: ConstraintConfig.getWidth(context),
              height: ConstraintConfig.getHeight(context) * 0.116,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  color: ColorConfig.secondaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Ionicons.location_outline),
                      SizedBox(
                        width: ConstraintConfig.kSpaceBetweenItemsMedium,
                      ),
                      const AppCustomText(content: '828 Sư Vạn Hạnh, Quận 10'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Ionicons.call_outline),
                      SizedBox(
                        width: ConstraintConfig.kSpaceBetweenItemsMedium,
                      ),
                      const AppCustomText(content: '858 2881 470'),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
            ),
            const AppCustomText(
              content: 'Trạng Thái Đơn Hàng',
              isTitle: true,
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
            ),
            Container(
              height: 2,
              color: ColorConfig.primaryColor,
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
            ),
            _buildOrderTracking(),
            const Spacer(),
            AppButton(
                text: 'Quay Về',
                onPressed: () {
                  RouteConfig.navigateTo(
                      context,
                      const AppNavigation(
                        index: 0,
                      ));
                })
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTracking() {
    return OrderTrackerZen(
      isShrinked: true,
      animation_duration: 2000,
      success_color: ColorConfig.primaryColor,
      text_primary_color: ColorConfig.mainTextColor,
      text_secondary_color: ColorConfig.accentColor,
      tracker_data: _getTrackerData(orderStatus),
    );
  }

  // Get order tracker base on order status
  List<TrackerData> _getTrackerData(String status) {
    List<TrackerData> trackerData = [
      _buildTrackerData("Đơn hàng đang chờ xác nhận", "Đặt thành công"),
    ];

    switch (status) {
      case 'confirmed':
        trackerData.add(_buildTrackerData(
            "Đơn hàng đã được xác nhận", "Đơn hàng đã được xác nhận"));
        break;
      case 'shipping':
        trackerData.add(_buildTrackerData(
            "Đơn hàng đã được xác nhận", "Đơn hàng đã được xác nhận"));
        trackerData.add(
            _buildTrackerData("Đang trên đường giao", "Đang trên đường giao"));
        break;
      case 'delivered':
        trackerData.add(_buildTrackerData(
            "Đơn hàng đã được xác nhận", "Đơn hàng đã được xác nhận"));
        trackerData.add(
            _buildTrackerData("Đang trên đường giao", "Đang trên đường giao"));
        trackerData.add(_buildTrackerData("Đơn hàng giao thành công", ""));
        break;
      default:
        break;
    }

    return trackerData;
  }

  // Hàm tạo TrackerData
  TrackerData _buildTrackerData(String title, String detail) {
    return TrackerData(
      title: title,
      date: Helpers.formatOrderDate(),
      tracker_details: [
        TrackerDetails(
          title: detail,
          datetime: Helpers.formatOrderDate(),
        ),
      ],
    );
  }
}
