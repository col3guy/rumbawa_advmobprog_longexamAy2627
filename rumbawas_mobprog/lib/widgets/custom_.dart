import '../widgets/custom_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // fixed import

class NotificationTile extends StatelessWidget {
  // renamed to avoid conflict with Flutter's Notification class
  const NotificationTile({
    super.key,
    required this.name,
    required this.post,
    required this.description,
  });

  final String name;
  final String post;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      child: Row(
        children: [
          Icon(Icons.person, size: 50.sp),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // fixed case
            children: [
              CustomFont(
                text: name,
                fontSize: 20.sp,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              CustomFont(
                text: description,
                fontSize: 12.sp,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}
