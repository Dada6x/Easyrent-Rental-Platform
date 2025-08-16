import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const List<_Language> _languages = [
    _Language(emoji: "🇺🇸", locale: Locale('en'), nameKey: 'English'),
    _Language(emoji: "🇸🇦", locale: Locale('ar'), nameKey: 'Arabic'),
    _Language(emoji: "🇫🇷", locale: Locale('fr'), nameKey: 'French'),
    _Language(emoji: "🇪🇸", locale: Locale('es'), nameKey: 'Spanish'),
    _Language(emoji: "🇯🇵", locale: Locale('ja'), nameKey: 'Japanese'),
    _Language(emoji: "🇷🇺", locale: Locale('ru'), nameKey: 'Russian'),
    _Language(emoji: "🇹🇷", locale: Locale('tr'), nameKey: 'Turkish'),
    _Language(emoji: "🇩🇪", locale: Locale('de'), nameKey: 'German'),
    _Language(
      emoji: null,
      locale: Locale('mc'),
      nameKey: 'Minecraft',
      icon: Iconify(
        Mdi.microsoft_minecraft,
        color: green,
        size: 25,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocale = Get.locale ?? const Locale('en');

    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _languages.length,
              separatorBuilder: (_, __) => const CustomDivider(),
              itemBuilder: (context, index) {
                final lang = _languages[index];
                final isSelected = lang.locale == currentLocale;

                return LanguageListTile(
                  key: ValueKey(lang.locale.toString()),
                  language: lang,
                  isSelected: isSelected,
                  onTap: () {
                    if (!isSelected) {
                      Get.updateLocale(lang.locale);
                    }
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class LanguageListTile extends StatelessWidget {
  final _Language language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageListTile({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget leadingWidget = Container(
      padding: EdgeInsets.all(6.r),
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
      ),
      child: language.icon ??
          Text(
            language.emoji ?? '',
            style: TextStyle(fontSize: 25.sp),
          ),
    );

    return ListTile(
      leading: leadingWidget,
      title: Text(language.nameKey.tr),
      onTap: onTap,
      horizontalTitleGap: 12.w,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
    );
  }
}

class _Language {
  final String? emoji;
  final Locale locale;
  final String nameKey;
  final Widget? icon;

  const _Language({
    this.emoji,
    required this.locale,
    required this.nameKey,
    this.icon,
  });
}
