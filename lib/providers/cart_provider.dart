// lib/providers/cart_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../viewmodels/cart_viewmodel.dart';

/// Provider chính quản lý giỏ hàng
final cartProvider =
StateNotifierProvider<CartViewModel, AsyncValue<List<CartItem>>>(
      (ref) => CartViewModel(),
);

/// Tổng tiền trước giảm giá
final subtotalProvider = Provider<double>((ref) {
  ref.watch(cartProvider); // ← watch để rebuild khi cart thay đổi
  return ref.read(cartProvider.notifier).subtotal;
});

/// Tổng tiền giảm giá
final discountProvider = Provider<double>((ref) {
  ref.watch(cartProvider); // ← watch để rebuild khi cart thay đổi
  return ref.read(cartProvider.notifier).totalDiscount;
});

/// Tổng tiền phải trả
final grandTotalProvider = Provider<double>((ref) {
  ref.watch(cartProvider); // ← watch để rebuild khi cart thay đổi
  return ref.read(cartProvider.notifier).grandTotal;
});

/// Số lượng sản phẩm trong giỏ
final itemCountProvider = Provider<int>((ref) {
  ref.watch(cartProvider); // ← watch để rebuild khi cart thay đổi
  return ref.read(cartProvider.notifier).itemCount;
});