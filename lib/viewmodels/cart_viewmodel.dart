// lib/viewmodels/cart_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../utils/database_helper.dart';

class CartViewModel extends StateNotifier<AsyncValue<List<CartItem>>> {
  CartViewModel() : super(const AsyncValue.loading()) {
    loadCart();
  }

  final _db = DatabaseHelper.instance;

  // ── Load giỏ hàng từ DB ──────────────────────────────────────────
  Future<void> loadCart() async {
    state = const AsyncValue.loading();
    try {
      final items = await _db.getAllItems();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ── Thêm vào giỏ ────────────────────────────────────────────────
  Future<void> addItem(CartItem item) async {
    try {
      await _db.insertItem(item);
      await loadCart();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ── Tăng số lượng ────────────────────────────────────────────────
  Future<void> increaseQuantity(CartItem item) async {
    try {
      await _db.updateQuantity(item.id!, item.quantity + 1);
      await loadCart();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ── Giảm số lượng ────────────────────────────────────────────────
  Future<void> decreaseQuantity(CartItem item) async {
    try {
      await _db.updateQuantity(item.id!, item.quantity - 1);
      await loadCart();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ── Xóa 1 item ───────────────────────────────────────────────────
  Future<void> removeItem(int id) async {
    try {
      await _db.deleteItem(id);
      await loadCart();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ── Xóa toàn bộ giỏ hàng ────────────────────────────────────────
  Future<void> clearCart() async {
    try {
      await _db.clearCart();
      await loadCart();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ── Computed properties ──────────────────────────────────────────
  double get subtotal => state.maybeWhen(
    data: (items) => items.fold(0.0, (sum, i) => sum + i.subtotal),
    orElse: () => 0.0,
  );

  double get totalDiscount => state.maybeWhen(
    data: (items) => items.fold(0.0, (sum, i) => sum + i.discount),
    orElse: () => 0.0,
  );

  double get grandTotal => subtotal - totalDiscount;

  int get itemCount => state.maybeWhen(
    data: (items) => items.fold(0, (sum, i) => sum + i.quantity),
    orElse: () => 0,
  );
}