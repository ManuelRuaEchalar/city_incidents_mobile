import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_my_flutter_app/features/home/providers/incidents_provider.dart';
import 'app/app.dart';
import 'features/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
        ChangeNotifierProvider(create: (_) => IncidentsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
