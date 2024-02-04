import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.onGrantedCallback(() async {
      await Permission.manageExternalStorage.onGrantedCallback(() async {
        runApp(const NotesApp());
      }).request();
    }).request();
  } else {
    runApp(const NotesApp());
  }
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      theme: ThemeData(
        fontFamily: "Montserrat",
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage());
}
