// lib/models/cart_item.dart

class CartItem {
  final int? id;
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final double originalPrice;
  int quantity;

  CartItem({
    this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.quantity,
  });

  // ── Computed properties ──────────────────────────────────────────
  double get subtotal => price * quantity;
  double get discount => (originalPrice - price) * quantity;
  double get total => subtotal;

  // ── copyWith ─────────────────────────────────────────────────────
  CartItem copyWith({
    int? id,
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    double? originalPrice,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  // ── SQLite serialization ─────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'originalPrice': originalPrice,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as int?,
      productId: map['productId'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      price: (map['price'] as num).toDouble(),
      originalPrice: (map['originalPrice'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }
}