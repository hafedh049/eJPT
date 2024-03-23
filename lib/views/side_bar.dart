import 'package:ejpt/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sidebarx/sidebarx.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  void dispose() {
    sideBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: sideBarController,
      theme: SidebarXTheme(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkColor),
        padding: const EdgeInsets.all(8),
        hoverColor: tealColor,
        iconTheme: const IconThemeData(color: whiteColor, size: 25),
      ),
      items: <SidebarXItem>[
        for (int index = 0; index < screens.length; index += 1)
          SidebarXItem(
            iconWidget: Icon(
              FontAwesome.robot_solid,
              size: 25,
              color: user!.get("host ${index + 1}")["type"] == "Rabbit Hole"
                  ? yellowColor
                  : user!.get("host ${index + 1}")["type"] == "Active"
                      ? greenColor
                      : redColor,
            ),
            label: user!.get("host ${index + 1}")["name"],
            onTap: () => screensController.jumpToPage(index),
          ),
      ],
    );
  }
}
