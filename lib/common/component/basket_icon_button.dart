import 'package:badges/badges.dart' as badges;
import 'package:delivery_flutter_app/restaurant/view/basket_screen.dart';
import 'package:delivery_flutter_app/user/provider/basket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketIconButton extends ConsumerWidget {
  const BasketIconButton({
    super.key,
    this.isFloatingActionButton = false,
  });

  final bool isFloatingActionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    return IconButton(
      onPressed: () => context.pushNamed(BasketScreen.routeName),
      icon: badges.Badge(
        showBadge: basket.isNotEmpty,
        position: badges.BadgePosition.bottomEnd(),
        badgeStyle: badges.BadgeStyle(
            badgeColor: isFloatingActionButton
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary),
        badgeContent: Text(
          basket
              .fold(
                  0, (previousValue, element) => previousValue + element.count)
              .toString(),
          style: TextStyle(
              color: isFloatingActionButton
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 10),
        ),
        child: Icon(
          CupertinoIcons.shopping_cart,
          color: isFloatingActionButton
              ? Theme.of(context).colorScheme.onPrimary
              : null,
          size: isFloatingActionButton ? 30 : null,
        ),
      ),
    );
  }
}
