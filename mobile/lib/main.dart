import 'package:flutter/material.dart';
import 'package:ilia_users/core/di/injector.dart';
import 'package:ilia_users/features/users/view/users_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IliaUsers',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blueAccent)),
      home: const UsersView(),
    );
  }
}
