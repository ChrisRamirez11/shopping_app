import 'package:app_tienda_comida/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {//TODO implement for ios
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon'); // Asegúrate de tener un icono en tu proyecto
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(); // Asegúrate de tener un icono en tu proyecto

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification(String title, String body) async {//TODO implement for ios
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'Orders',
            'Nuevo Pedido',
            channelDescription: 'Your channel description',
            importance: Importance.max,
            priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
    );
}

void listenToTableChanges() {
    supabase.channel('orders').onPostgresChanges(event: PostgresChangeEvent.insert, table: 'orders', callback: (payload) {
      showNotification('Pedidos', 'Tiene un nuevo pedido.');
    },).subscribe();
}