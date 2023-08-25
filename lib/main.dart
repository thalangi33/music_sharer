import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_sharer/models/myUser.dart';
import 'package:music_sharer/provider/music_provider.dart';
import 'package:music_sharer/screens/wrapper.dart';
import 'package:music_sharer/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
        initialData: null,
        value: AuthService().user,
        child: ChangeNotifierProvider<MusicProvider>(
            create: (context) => MusicProvider(),
            child: MaterialApp(
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home: Wrapper())));
  }
}
