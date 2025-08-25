import 'package:flutter/material.dart';

enum PlanType {
  trial('Trial'),
  basic('Basic'),
  platinum('Platinum'),
  vip('Vip');

  const PlanType(this.value);
  final String value;

  static PlanType fromString(String value) {
    return PlanType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => PlanType.basic,
    );
  }
}

extension PlanTypeIcon on PlanType {
  IconData get icon {
    switch (this) {
      case PlanType.basic:
        return Icons.lock_open_rounded;
      case PlanType.trial:
        return Icons.timer_outlined;
      case PlanType.platinum:
        return Icons.workspace_premium_outlined;
      case PlanType.vip:
        return Icons.verified_user_outlined;
    }
  }
}
