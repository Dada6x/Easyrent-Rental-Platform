import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyrent/core/constants/utils/divider.dart';
import 'package:easyrent/data/Session/app_session.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/notifications/views/zero_notifications.dart';
import 'package:easyrent/presentation/views/profile/view/profile_pages/notifications/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: 300.w,
        height: double.infinity,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 20.r,
              ),
            ),
            centerTitle: true,
          ),
          body: StreamBuilder<QuerySnapshot>(
            //! this is the Firebase shit
            stream: FirebaseFirestore.instance
                .collection("notifications")
                .where("userId", isEqualTo: AppSession().user?.id ?? 0)
                //! id
                .orderBy("timestamp", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const ZeroNotifications();
              }
              final docs = snapshot.data!.docs;

              return Padding(
                padding: EdgeInsets.all(5.0.r),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: docs.length,
                  separatorBuilder: (context, index) => CustomDivider(),
                  itemBuilder: (context, index) {
                    final notification =
                        docs[index].data() as Map<String, dynamic>;

                    return NotificationWidget(
                      title: notification["title"] ?? "No title",
                      body: notification["body"] ?? "No content",
                      time: notification["time"] ?? "",
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
