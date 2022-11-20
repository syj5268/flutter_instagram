import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
          builder: (context) => Text('아직수정중'),
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
    '인스타그램 알람 예시',
    '핳핳 일이나 해...',
    NotificationDetails(android: androidDetails, iOS: iosDetails),
  );
}

showNotification2() async {
  tz.initializeTimeZones();

  var androidDetails = const AndroidNotificationDetails(
    '유니크한 알람 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = const IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  notifications.zonedSchedule(
      2,
      '제목2',
      '내용2',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 3)), //3초 후 알람
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}
