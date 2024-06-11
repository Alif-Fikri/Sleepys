import 'package:flutter/material.dart';
import '../pages/singup.dart';
import 'package:provider/provider.dart';
import '../pages/splashscreen.dart';
import '../widgets/signupprovider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupFormProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      theme: ThemeData(
        fontFamily: 'Urbanist',
      ),
    );
  }
}
