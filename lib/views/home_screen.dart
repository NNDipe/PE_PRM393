// lib/views/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import '../widgets/app_bottom_nav.dart';
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(itemCountProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'Home Screen\n(Chưa thiết kế giao diện)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: 0),
    );
  }
}