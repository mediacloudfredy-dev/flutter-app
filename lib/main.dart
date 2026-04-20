import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteflow/app/app.dart';
import 'package:noteflow/core/services/database_service.dart';
import 'package:noteflow/core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();
  await NotificationService.instance.init();
  runApp(const ProviderScope(child: NoteFlowApp()));
}
