// lib/views/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import 'home_screen.dart'; // ← thêm import

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final subtotal = ref.watch(subtotalProvider);
    final discount = ref.watch(discountProvider);
    final grandTotal = ref.watch(grandTotalProvider);
    final itemCount = ref.watch(itemCountProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cart',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('$itemCount items',
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          // ← Đổi Clear thành icon Home
          IconButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
            ),
            icon: const Icon(Icons.home_outlined, color: Colors.black),
            tooltip: 'Về trang chủ',
          ),
        ],
      ),

      // ── Body: GridView + OrientationBuilder ──────────────────────
      body: cartState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Lỗi: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(cartProvider.notifier).loadCart(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('Giỏ hàng trống',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            );
          }

          // Dọc: 1 cột — Ngang: 2 cột
          return OrientationBuilder(
            builder: (context, orientation) {
              final isPortrait = orientation == Orientation.portrait;
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isPortrait ? 1 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 110,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) => CartItemWidget(item: items[i]),
              );
            },
          );
        },
      ),

      // ── Bottom cố định: Subtotal + Discount + Total + Checkout ───
      bottomNavigationBar: _CartSummary(
        subtotal: subtotal,
        discount: discount,
        grandTotal: grandTotal,
        itemCount: itemCount,
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa giỏ hàng'),
        content: const Text('Bạn có chắc muốn xóa toàn bộ giỏ hàng?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) ref.read(cartProvider.notifier).clearCart();
  }
}

// ── Widget tổng tiền + nút Checkout ─────────────────────────────────
class _CartSummary extends ConsumerWidget {
  final double subtotal;
  final double discount;
  final double grandTotal;
  final int itemCount;

  const _CartSummary({
    required this.subtotal,
    required this.discount,
    required this.grandTotal,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SummaryRow(label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(0)}'),
            const SizedBox(height: 6),
            _SummaryRow(
                label: 'Discount',
                value: '-\$${discount.toStringAsFixed(0)}',
                valueColor: Colors.red),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1),
            ),
            _SummaryRow(
                label: 'Total',
                value: '\$${grandTotal.toStringAsFixed(0)}',
                isBold: true,
                fontSize: 18),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: itemCount > 0
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Đặt hàng thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Checkout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final double fontSize;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isBold ? Colors.black : Colors.grey[600])),
        Text(value,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? Colors.black)),
      ],
    );
  }
}