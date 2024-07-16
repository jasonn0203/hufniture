import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/ui/screens/order_screen/track_order_screen/track_order_screen.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';

class OrderListScreen extends StatelessWidget {
  OrderListScreen({super.key});

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Chờ Xác Nhận'),
    Tab(text: 'Đã Xác Nhận'),
    Tab(text: 'Đang Giao'),
    Tab(text: 'Đã Giao'),
    Tab(text: 'Đã Hủy'),
  ];

  // Sample data for orders
  final List<String> awaitingConfirmation = ['Order 1', 'Order 2'];
  final List<String> confirmed = ['Order 3'];
  final List<String> delivering = ['Order 4', 'Order 5'];
  final List<String> delivered = [];
  final List<String> cancelled = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Đơn Hàng Của Bạn'),
      body: DefaultTabController(
        length: myTabs.length,
        child: Column(
          children: [
            const TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: ColorConfig.primaryColor,
              labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
              labelColor: ColorConfig.primaryColor,
              tabs: myTabs,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildOrderList(awaitingConfirmation),
                  buildOrderList(confirmed),
                  buildOrderList(delivering),
                  buildOrderList(delivered),
                  buildOrderList(cancelled),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderList(List<String> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('Không có đơn hàng nào !'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _buildOrderItem(context),
        );
      },
    );
  }

  GestureDetector _buildOrderItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RouteConfig.navigateTo(
            context, const TrackOrderScreen(orderStatus: 'shipping'));
      },
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: CachedNetworkImage(
            imageUrl:
                'https://th.bing.com/th/id/OIP.8Sbwf_y-3J7qOKL93Xil9wHaFj?rs=1&pid=ImgDetMain',
            fit: BoxFit.contain,
            alignment: Alignment.center,
            placeholder: (context, url) => const Center(
              // Placeholder when load images
              child: LoadingIndicator(),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error), // Widget hiển thị khi có lỗi
          ),
        ),
        title: const AppCustomText(content: 'Nội Thất'),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppCustomText(
              content: Helpers.formatPrice(140000).toString(),
            ),
            const AppCustomText(content: '1x'),
            AppCustomText(
              content: Helpers.formatPrice(140000).toString(),
              color: true,
            ),
          ],
        ),
      ),
    );
  }
}
