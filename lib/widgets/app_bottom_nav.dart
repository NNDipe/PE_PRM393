// lib/widgets/app_bottom_nav.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../views/home_screen.dart';
import '../views/product_detail_screen.dart';
import '../views/cart_screen.dart';

class AppBottomNav extends ConsumerWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(itemCountProvider);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == currentIndex) return;
        switch (index) {
          case 0:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const HomeScreen()));
            break;
          case 1:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const ProductDetailScreen()));
            break;
          case 2:
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CartScreen()));
            break;
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          activeIcon: Icon(Icons.list_alt),
          label: 'ProductDetail',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: itemCount > 0,
            label: Text('$itemCount'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          activeIcon: Badge(
            isLabelVisible: itemCount > 0,
            label: Text('$itemCount'),
            child: const Icon(Icons.shopping_cart),
          ),
          label: 'Cart',
        ),
      ],
    );
  }
}