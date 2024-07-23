import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/configs/route_config.dart';
import 'package:hufniture/data/models/order_list_response.dart';
import 'package:hufniture/data/services/OrderService/order_service.dart';
import 'package:hufniture/data/services/shared_preference_helper.dart';
import 'package:hufniture/ui/screens/order_screen/track_order_screen/track_order_screen.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';
import 'package:hufniture/ui/widgets/loading_indicator/loading_indicator.dart';
import 'package:hufniture/ui/widgets/text/app_custom_text.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Đã Xác Nhận'),
    Tab(text: 'Đang Giao'),
    Tab(text: 'Đã Giao'),
  ];

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final OrderService _orderService = OrderService();
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _loadOrders();
  }

  Future<List<Order>> _loadOrders() async {
    final user = await SharedPreferencesHelper.getUser();
    if (user != null) {
      return _orderService.getOrdersByUserId(user['id']);
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Đơn Hàng Của Bạn'),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có đơn hàng nào !'));
          } else {
            final orders = snapshot.data!;
            final confirmedOrders = orders
                .where(
                    (order) => order.orderStatuses.last.status == 'Confirmed')
                .toList();
            final deliveringOrders = orders
                .where(
                    (order) => order.orderStatuses.last.status == 'InDelivery')
                .toList();
            final deliveredOrders = orders
                .where(
                    (order) => order.orderStatuses.last.status == 'Delivered')
                .toList();

            return DefaultTabController(
              length: OrderListScreen.myTabs.length,
              child: Column(
                children: [
                  const TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: ColorConfig.primaryColor,
                    labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    labelColor: ColorConfig.primaryColor,
                    tabs: OrderListScreen.myTabs,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        buildOrderList(confirmedOrders),
                        buildOrderList(deliveringOrders),
                        buildOrderList(deliveredOrders),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('Không có đơn hàng nào !'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _buildOrderItem(context, order),
        );
      },
    );
  }

  GestureDetector _buildOrderItem(BuildContext context, Order order) {
    return GestureDetector(
      onTap: () {
        RouteConfig.navigateTo(
          context,
          TrackOrderScreen(
            orderId: order.id,
            orderStatus: order.orderStatuses.last.status,
            orderItems: order.orderItems,
            orderStatusDate: order.orderStatuses.last.statusChangedDate,
          ),
        );
      },
      child: ListTile(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Colors.blueGrey,
            width: 1,
          ),
        ),
        leading: SizedBox(
          width: 60,
          height: 60,
          child: CachedNetworkImage(
            imageUrl: order.orderItems.first.furnitureProduct.imageURL,
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
          children: order.orderItems.map((orderItem) {
            final productName = orderItem.furnitureProduct.name;
            final productPrice =
                Helpers.formatPrice(orderItem.furnitureProduct.price)
                    .toString();
            final productTotalPrice = Helpers.formatPrice(
                    orderItem.furnitureProduct.price * orderItem.quantity)
                .toString();
            final productQuantity = orderItem.quantity;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCustomText(content: productName),
                  AppCustomText(
                      content: productPrice, color: true), // Giá sản phẩm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppCustomText(content: 'Số lượng: $productQuantity x'),
                      AppCustomText(
                          content: productTotalPrice, color: true), // Tổng tiền
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
