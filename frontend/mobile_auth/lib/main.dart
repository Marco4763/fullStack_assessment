import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_auth/data/adapter/firebase_adapter.dart';
import 'package:mobile_auth/ui/presentation/splash/page/splash_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/.env');

  await FirebaseAdapter.initialize;

  runApp(const SetApp());
}

class SetApp extends StatelessWidget {
  const SetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Artico'),
      home: const SplashPage(),
    );
  }
}
