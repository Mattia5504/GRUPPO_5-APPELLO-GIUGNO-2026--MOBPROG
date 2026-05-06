class PantryItem {
  const PantryItem({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    this.expiryDate,
    required this.lowStockThreshold,
    this.notes,
  });

  final int? id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final DateTime? expiryDate;
  final double lowStockThreshold;
  final String? notes;

  factory PantryItem.fromMap(Map<String, Object?> map) {
    final rawExpiryDate = map['expiry_date'] as String?;

    return PantryItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unit: map['unit'] as String,
      expiryDate: rawExpiryDate == null ? null : DateTime.parse(rawExpiryDate),
      lowStockThreshold: (map['low_stock_threshold'] as num).toDouble(),
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
      'expiry_date': expiryDate?.toIso8601String(),
      'low_stock_threshold': lowStockThreshold,
      'notes': notes,
    };
  }

  PantryItem copyWith({
    int? id,
    String? name,
    String? category,
    double? quantity,
    String? unit,
    DateTime? expiryDate,
    double? lowStockThreshold,
    String? notes,
  }) {
    return PantryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'PantryItem(id: $id, name: $name, quantity: $quantity, unit: $unit)';
  }
}
