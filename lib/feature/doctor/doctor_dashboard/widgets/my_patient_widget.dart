import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/color_manger.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> messages;
  const NotificationsPage({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: ColorsManager.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: messages.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => ListTile(
          title: Text(
            messages[index],
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}
