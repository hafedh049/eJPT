import 'package:ejpt/utils/shared.dart';
import 'package:ejpt/views/side_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void dispose() {
    screensController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: <Widget>[
            const SideBar(),
            const SizedBox(width: 20),
            Expanded(
              child: PageView.builder(
                controller: screensController,
                itemBuilder: (BuildContext context, int index) => screens[index],
                itemCount: screens.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
