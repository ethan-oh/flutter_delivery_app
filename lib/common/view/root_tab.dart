import 'package:delivery_flutter_app/common/component/basket_icon_button.dart';
import 'package:delivery_flutter_app/common/layout/default_layout.dart';
import 'package:delivery_flutter_app/order/view/order_screen.dart';
import 'package:delivery_flutter_app/product/view/product_screen.dart';
import 'package:delivery_flutter_app/restaurant/view/restaurant_screen.dart';
import 'package:delivery_flutter_app/user/view/profile_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  static get routeName => 'root';
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this)
      ..addListener(tabListener);
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'Ethan\'s Delivery',
      actions: const [
        BasketIconButton(),
        SizedBox(width: 10),
      ],
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: index,
        indicatorColor: Theme.of(context).colorScheme.surfaceBright,
        onDestinationSelected: (index) => controller.animateTo(index),
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.restaurant_outlined,
            ),
            label: '음식',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.receipt_long_outlined,
            ),
            label: '주문',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
            ),
            label: '프로필',
          ),
        ],
      ),
      child: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          RestaurantScreen(),
          ProductScreen(),
          OrderScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
