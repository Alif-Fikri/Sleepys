import 'package:flutter/material.dart';
import 'package:sleepys/pages/genderpage.dart';
import 'package:sleepys/widgets/bloodpressure.dart';
import 'package:sleepys/widgets/dailystep.dart';
import 'package:sleepys/widgets/sleeppage.dart';
import '../pages/singup.dart';
import 'package:provider/provider.dart';
import '../pages/splashscreen.dart';
import '../widgets/signupprovider.dart';
import '../pages/loginpage.dart';
import '../pages/heightselection.dart';
import '../pages/namepage.dart';
import '../pages/datepicker.dart';
import '../pages/home.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sleepys/widgets/profilepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for the 'id' locale
  await initializeDateFormatting('id', null);
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
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
      },
      theme: ThemeData(
        fontFamily: 'Urbanist',
      ),
    );
  }
}
