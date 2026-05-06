class ShoppingItem {
  const ShoppingItem({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    this.isPurchased = false,
    required this.source,
    this.notes,
  });

  final int? id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final bool isPurchased;
  final String source;
  final String? notes;

  factory ShoppingItem.fromMap(Map<String, Object?> map) {
    return ShoppingItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unit: map['unit'] as String,
      isPurchased: (map['is_purchased'] as int) == 1,
      source: map['source'] as String,
      notes: map['notes'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'is_purchased': isPurchased ? 1 : 0,
      'source': source,
      'notes': notes,
    };
  }

  ShoppingItem copyWith({
    int? id,
    String? name,
    String? category,
    double? quantity,
    String? unit,
    bool? isPurchased,
    String? source,
    String? notes,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isPurchased: isPurchased ?? this.isPurchased,
      source: source ?? this.source,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'ShoppingItem(id: $id, name: $name, quantity: $quantity, unit: $unit, source: $source)';
  }
}
