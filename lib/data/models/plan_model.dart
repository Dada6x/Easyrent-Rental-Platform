import 'package:easyrent/core/constants/utils/enums.dart';
import 'package:easyrent/core/services/api/end_points.dart';

class SubscriptionPlan {
  final int id;
  final String planDuration;
  final String description;
  final PlanType planType;
  final int planPrice;

  SubscriptionPlan({
    required this.id,
    required this.planDuration,
    required this.description,
    required this.planType,
    required this.planPrice,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      planDuration: json['planDuration'],
      description: json['description'],
      planType: PlanType.fromString(json['planType']),
      planPrice: json['planPrice'],
    );
  }
}

class PaymentRequest {
  final String planId;

  PaymentRequest({
    required this.planId,
  });

  Map<String, dynamic> toJson() {
    return {
      "planId": planId,
      "payment_Method_Type": "card",
      "dataAfterPayment": {
      "success_url": EndPoints.stripeSuccess,
      "cancel_url": EndPoints.stripeCancel,
      }
    };
  }
}
