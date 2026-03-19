// lib/views/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import '../widgets/app_bottom_nav.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Product Detail',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Product Detail Screen\n(Chưa thiết kế giao diện)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: 1),
    );
  }
}

