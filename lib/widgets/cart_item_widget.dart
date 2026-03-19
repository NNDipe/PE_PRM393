// lib/widgets/cart_item_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends ConsumerWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(cartProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // ── Ảnh sản phẩm ──────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 65,
                    height: 65,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // ── Thông tin ──────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tên sản phẩm (padding right để tránh nút X)
                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Giá gốc (gạch) + giá sale
                    Row(
                      children: [
                        Text(
                          '\$${item.originalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '\$${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Subtotal + nút tăng/giảm
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Subtotal của item
                        Text(
                          '\$${item.subtotal.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),

                        // Quantity controls: [ - | qty | + ]
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Nút giảm
                              GestureDetector(
                                onTap: () => vm.decreaseQuantity(item),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.remove,
                                    size: 14,
                                    color: item.quantity <= 1
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                              ),

                              // Số lượng
                              SizedBox(
                                width: 26,
                                child: Text(
                                  '${item.quantity}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                              // Nút tăng
                              GestureDetector(
                                onTap: () => vm.increaseQuantity(item),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.add,
                                      size: 14, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Nút X góc phải trên ───────────────────────────────
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => vm.removeItem(item.id!),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}