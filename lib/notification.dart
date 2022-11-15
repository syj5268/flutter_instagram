import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();

initNotification(context) async {
  var androidSetting = AndroidInitializationSettings('app_icon');
  var iosSetting = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings =
      InitializationSettings(android: androidSetting, iOS: iosSetting);

  await notifications.initialize(initializationSettings,
      onSelectNotification: (payload) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Text('새로운페이지'),
        ));
  });
}

showNotification() async {
  var androidDetails = AndroidNotificationDetails(
    '유니크한 알람 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0), //알림 아이콘 색상
  );

  var iosDetails = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  notifications.show(
    1, //개별알림의 ID 숫자
    '제목',
    '내용',
    NotificationDetails(android: androidDetails, iOS: iosDetails),
  );
}
