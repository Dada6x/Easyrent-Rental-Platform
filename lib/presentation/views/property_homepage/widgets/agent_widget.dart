import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AgentWidget extends StatelessWidget {
  final String agentName;
  final String agentRole;
  final String agentImage;
  const AgentWidget(
      {super.key,
      required this.agentName,
      required this.agentRole,
      required this.agentImage});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // showAgentInfoDialog(context, agentImage);
      },
      leading: CircleAvatar(
        radius: 23.sp,
        backgroundColor: Colors.transparent,
        child: ClipOval(
            child: FancyShimmerImage(
                boxFit: BoxFit.cover,
                imageUrl: agentImage,
                errorWidget: const ErrorLoadingWidget())),
      ),
      title: Text(
        agentName,
        style: AppTextStyles.h18semi,
      ),
      subtitle: Text(
        agentRole,
        style: AppTextStyles.h14medium.copyWith(color: grey),
      ),
      trailing: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.chat,
                  size: 25.r, color: Theme.of(context).colorScheme.primary),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.phone_enabled,
                  size: 25.r, color: Theme.of(context).colorScheme.primary),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// void showAgentInfoDialog(BuildContext context, String agentImage) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Motion(
//         filterQuality: FilterQuality.high,
//         controller: MotionController(maxAngle: 50, damping: 0.2),
//         glare: const GlareConfiguration(maxOpacity: 0),
//         shadow:
//             const ShadowConfiguration(color: Colors.transparent, opacity: 0),
//         translation: const TranslationConfiguration(maxOffset: Offset(100, 80)),
//         child: Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircleAvatar(
//                   radius: 50.sp,
//                   backgroundColor: Colors.transparent,
//                   child: ClipOval(
//                       child: FancyShimmerImage(
//                           boxFit: BoxFit.cover,
//                           // imageUrl: agentImage,
//                           imageUrl:
//                               "https://images.unsplash.com/photo-1505691723518-36a5ac3be353?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
//                           errorWidget: const ErrorLoadingWidget())),
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   'Agent Name ',
//                   style: AppTextStyles.h14regular,
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 24.h),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

//! two Choice buttons 
/*
Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text('Cancel',
                                style: AppTextStyles.h16medium
                                    .copyWith(color: white)))),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Yes, Logout',
                            style:
                                AppTextStyles.h16medium.copyWith(color: white)),
                      ),
                    ),
                  ],
                )


*/