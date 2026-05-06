import 'package:flutter/material.dart';

import '../../core/app_date_utils.dart';
import '../../core/enums.dart';
import '../../models/pantry_item.dart';

class ExpiryBadge extends StatelessWidget {
  const ExpiryBadge({super.key, required this.item});

  final PantryItem item;

  static ExpiryStatus statusFor(PantryItem item) {
    final expiryDate = item.expiryDate;
    if (expiryDate == null) {
      return ExpiryStatus.noDate;
    }

    final today = AppDateUtils.startOfDay(DateTime.now());
    final expiry = AppDateUtils.startOfDay(expiryDate);
    final days = expiry.difference(today).inDays;

    if (days < 0) {
      return ExpiryStatus.expired;
    }
    if (days <= 3) {
      return ExpiryStatus.expiring;
    }
    if (days <= 7) {
      return ExpiryStatus.consumeSoon;
    }
    return ExpiryStatus.ok;
  }

  @override
  Widget build(BuildContext context) {
    final status = statusFor(item);
    final colors = _colorsFor(context, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  _BadgeColors _colorsFor(BuildContext context, ExpiryStatus status) {
    final scheme = Theme.of(context).colorScheme;

    return switch (status) {
      ExpiryStatus.expired => _BadgeColors(
        background: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
      ),
      ExpiryStatus.expiring => const _BadgeColors(
        background: Color(0xFFFFE1D6),
        foreground: Color(0xFF8A2F16),
      ),
      ExpiryStatus.consumeSoon => const _BadgeColors(
        background: Color(0xFFFFE9B5),
        foreground: Color(0xFF6B4A00),
      ),
      ExpiryStatus.ok => const _BadgeColors(
        background: Color(0xFFDCECDD),
        foreground: Color(0xFF264D3C),
      ),
      ExpiryStatus.noDate => _BadgeColors(
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurfaceVariant,
      ),
    };
  }
}

class _BadgeColors {
  const _BadgeColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}
