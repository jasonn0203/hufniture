import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/models/order_list_response.dart';
import 'package:hufniture/data/services/AuthService/auth_service.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
import 'package:hufniture/ui/screens/app_navigation/app_navigation.dart';
import 'package:hufniture/ui/widgets/buttons/app_button.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';
import 'package:ionicons/ionicons.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';

class TrackOrderScreen extends StatefulWidget {
  final String orderStatus;
  final List<OrderItem> orderItems;
  final DateTime orderStatusDate;
  final String orderId;

  const TrackOrderScreen({
    super.key,
    required this.orderStatus,
    required this.orderItems,
    required this.orderStatusDate,
    required this.orderId,
  });

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  final AuthService _authService = AuthService();
  String? userAddress;
  String? userPhoneNumber;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await SharedPreferencesHelper.getUser();
    if (user == null) {
      debugPrint('Không tìm thấy thông tin người dùng.');
      return;
    }

    final userInfo = await _authService.getUserInfo(user['id']);
    if (userInfo != null) {
      setState(() {
        userAddress = userInfo['address'];
        userPhoneNumber = userInfo['phoneNumber'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Theo Dõi Đơn Hàng'),
      body: SingleChildScrollView(
        child: Padding(
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
                        Flexible(
                          child: AppCustomText(content: userAddress ?? ''),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Ionicons.call_outline),
                        SizedBox(
                          width: ConstraintConfig.kSpaceBetweenItemsMedium,
                        ),
                        Flexible(
                          child: AppCustomText(content: userPhoneNumber ?? ''),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              const AppCustomText(
                content: 'Trạng Thái Đơn Hàng',
                isTitle: true,
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsMedium,
              ),
              Container(
                height: 2,
                color: ColorConfig.primaryColor,
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
              ),
              _buildOrderTracking(),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsUltraLarge,
              ),
              const AppCustomText(
                content: 'Sản Phẩm Trong Đơn Hàng',
                isTitle: true,
              ),
              SizedBox(
                height: ConstraintConfig.kSpaceBetweenItemsSmall,
              ),
              _buildProductList(),
              const SizedBox(height: 4), // Add some space before the button
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
      ),
    );
  }

  Widget _buildProductList() {
    List<Widget> productWidgets = [];

    // Show only the first product
    if (widget.orderItems.isNotEmpty) {
      final orderItem = widget.orderItems[0];
      productWidgets.add(_buildProductItem(orderItem));
    }

    // Show "See More" button if there are more than one product
    if (widget.orderItems.length > 1) {
      productWidgets.add(
        ListTile(
          title: TextButton(
            onPressed: () => _showMoreProducts(context),
            child: const AppCustomText(content: 'Xem thêm', isTitle: true),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: productWidgets,
    );
  }

  Widget _buildProductItem(OrderItem orderItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: CachedNetworkImage(
            imageUrl: orderItem.furnitureProduct.imageURL,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            placeholder: (context, url) => const Center(
              child: LoadingIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCustomText(content: orderItem.furnitureProduct.name),
            const SizedBox(height: 4),
            AppCustomText(
              content: Helpers.formatPrice(orderItem.furnitureProduct.price)
                  .toString(),
              color: true, // Giá sản phẩm
            ),
            const SizedBox(height: 4),
            AppCustomText(content: 'Số lượng: ${orderItem.quantity}x'),
            const SizedBox(height: 4),
            AppCustomText(
              content: Helpers.formatPrice(
                      orderItem.furnitureProduct.price * orderItem.quantity)
                  .toString(),
              color: true, // Tổng tiền
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreProducts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tất cả sản phẩm trong đơn hàng'),
          content: SizedBox(
            width: double.maxFinite,
            height: ConstraintConfig.getHeight(context) * 0.5,
            child: ListView.builder(
              itemCount: widget.orderItems.length,
              itemBuilder: (context, index) {
                final orderItem = widget.orderItems[index];
                return _buildProductItem(orderItem);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderTracking() {
    return OrderTrackerZen(
      isShrinked: true,
      animation_duration: 2000,
      success_color: ColorConfig.primaryColor,
      text_primary_color: ColorConfig.mainTextColor,
      text_secondary_color: ColorConfig.accentColor,
      tracker_data: _getTrackerData(widget.orderStatus, widget.orderStatusDate),
    );
  }

  List<TrackerData> _getTrackerData(String status, DateTime statusDate) {
    List<TrackerData> trackerData = [
      _buildTrackerData(
          "Đơn hàng đang chờ xác nhận", "Đặt thành công", statusDate),
    ];

    switch (status) {
      case 'Confirmed':
        trackerData.add(_buildTrackerData(
          "Đơn hàng đã được xác nhận",
          "Đơn hàng đã được xác nhận",
          statusDate, // Use single DateTime here
        ));
        break;
      case 'InDelivery':
        trackerData.add(_buildTrackerData(
          "Đơn hàng đã được xác nhận",
          "Đơn hàng đã được xác nhận",
          statusDate, // Use single DateTime here
        ));
        trackerData.add(_buildTrackerData(
          "Đang trên đường giao",
          "Đang trên đường giao",
          statusDate, // Use single DateTime here
        ));
        break;
      case 'Delivered':
        trackerData.add(_buildTrackerData(
          "Đơn hàng đã được xác nhận",
          "Đơn hàng đã được xác nhận",
          statusDate, // Use single DateTime here
        ));
        trackerData.add(_buildTrackerData(
          "Đang trên đường giao",
          "Đang trên đường giao",
          statusDate, // Use single DateTime here
        ));
        trackerData.add(_buildTrackerData(
          "Đơn hàng đã giao",
          "Đơn hàng đã giao",
          statusDate, // Use single DateTime here
        ));
        break;
    }

    return trackerData;
  }

  TrackerData _buildTrackerData(
      String title, String detail, DateTime statusChangedDate) {
    return TrackerData(
      title: title,
      date: Helpers.formatDate(
          statusChangedDate.toString()), // Format the DateTime
      tracker_details: [
        TrackerDetails(
          title: detail,
          datetime: Helpers.formatDate(
              statusChangedDate.toString()), // Format the DateTime
        ),
      ],
    );
  }
}
