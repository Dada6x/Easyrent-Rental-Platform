// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easyrent/core/constants/utils/error_loading_mssg.dart';
import 'package:easyrent/data/models/agent_model.dart';
import 'package:easyrent/main.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:easyrent/presentation/views/agent/agent_page.dart';

class AgentSearchCard extends StatelessWidget {
  final int id;
  final String name;
  final String imageUrl;
  const AgentSearchCard({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        ),
        child: ListTile(
          onTap: () async {
            debug.w("get agent details by id : $id");
            final agent = Agent(
                id: 1,
                name: "  Yahea DADA",
                photo: "dwdawd",
                rating: 15,
                properties: []);
            // = await propertyDio.getAgentsByIdJson(id);
            Get.to(
              AgentPage(
                agent: agent,
              ),
            );
          },
          leading: CircleAvatar(
            radius: 35.4.sp,
            backgroundColor: Theme.of(context).colorScheme.outline,
            child: ClipOval(
              child: CircleAvatar(
                  radius: 32.sp,
                  child: ClipOval(
                    child: FancyShimmerImage(
                        errorWidget: const ErrorLoadingWidget(),
                        imageUrl: imageUrl),
                  )),
            ),
          ),
          title: Text(name),
          subtitle: Text('Tokyo, Japan id: $id'),
          trailing: Icon(Icons.arrow_forward_ios,
              size: 16, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
