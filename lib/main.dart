import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/splashscreen.dart';
import '../widgets/signupprovider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../models/user_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Hive.initFlutter();
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  } else {
    await Hive.initFlutter();
  }

  await Hive.openBox('userBox');

  await initializeDateFormatting('id', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupFormProvider()),
        ChangeNotifierProvider(create: (_) => UserData()), // Tambahkan ini
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
