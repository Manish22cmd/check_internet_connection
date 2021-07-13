import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationBar {
  static void showNotificationBar(
          BuildContext context, String msg, Color notificationColor) =>
      showSimpleNotification(
        Text('Internet Connection Status'),
        subtitle: Text(msg),
        background: notificationColor,
      );
}
