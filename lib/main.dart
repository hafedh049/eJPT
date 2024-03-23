import 'package:ejpt/utils/callbacks.dart';
import 'package:flutter/material.dart';

import 'views/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(title: 'eJPT', debugShowCheckedModeBanner: false, home: Home());
}
