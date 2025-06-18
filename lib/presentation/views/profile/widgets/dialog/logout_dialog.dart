import 'package:dio/dio.dart';
import 'package:easyrent/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/core/services/api/dio_consumer.dart';
import 'package:easyrent/data/repos/userRepo.dart';

void showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are You sure to logout ?', style: AppTextStyles.h20medium),
              SizedBox(height: 12.h),
              Text(
                'You will be missed  🥺',
                style: AppTextStyles.h14regular,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
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
                      onPressed: () {
                        userREPO.logoutUser();
                      },
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
            ],
          ),
        ),
      );
    },
  );
}
