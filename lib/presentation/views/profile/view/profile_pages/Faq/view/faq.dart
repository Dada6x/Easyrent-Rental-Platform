import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/svgColorReplacer.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/Faq/widgets/faq_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ThemedSvgReplacer(
            assetPath: faq,
            themeColor: Theme.of(context).colorScheme.primary,
            height: 220.h,
            width: double.infinity),
        const FAQItem(
            question:
                "How do I list a property for sale or rent on your platform?",
            answer:
                '   To list a property, simply sign up for an account, go to your dashboard, and click "Add Property." Fill in the required details (location, price, amenities, photos, etc.), and submit for review. Once approved, your listing will go live and be visible to potential buyers or renters.'),
        const FAQItem(
            question:
                "What fees are involved when buying or renting through your app?",
            answer:
                "   For buyers/renters, our platform is free to use. For sellers/landlords, we charge a small commission (or a flat fee) upon a successful transaction. Exact pricing details can be found in our "
                "Pricing"
                " section or during the listing process."),
        const FAQItem(
            question: "How can I verify if a property listing is genuine?",
            answer:
                "   We verify listings through a multi-step process, including agent/license checks and manual reviews. Look for the "
                "Verified"
                " badge on listings. Additionally, we encourage users to report suspicious posts via the "
                "Report Listing"
                " button for further investigation."),
        const FAQItem(
          question: "Would You Rather ....",
          answer: "Yeah amma do it",
        ),
      ],
    );
  }
}
