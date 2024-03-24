import 'package:ejpt/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      showToggleButton: true,
      controller: sideBarController,
      extendedTheme: SidebarXTheme(
        width: 200,
        selectedTextStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: pinkColor),
        textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
        hoverTextStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: pinkColor),
        selectedItemTextPadding: const EdgeInsets.only(left: 16),
        itemTextPadding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkColor),
        padding: const EdgeInsets.all(8),
        iconTheme: const IconThemeData(color: whiteColor, size: 25),
      ),
      theme: SidebarXTheme(
        selectedTextStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: pinkColor),
        textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
        hoverTextStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: pinkColor),
        selectedItemTextPadding: const EdgeInsets.only(left: 16),
        itemTextPadding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: darkColor),
        padding: const EdgeInsets.all(8),
        iconTheme: const IconThemeData(color: whiteColor, size: 25),
      ),
      items: <SidebarXItem>[
        for (int index = 0; index < screens.length; index += 1)
          SidebarXItem(
            iconWidget: Icon(
              FontAwesome.robot_solid,
              size: 25,
              color: index == currentIndex
                  ? pinkColor
                  : user!.get("host ${index + 1}")["type"] == "Rabbit Hole"
                      ? yellowColor
                      : user!.get("host ${index + 1}")["type"] == "Active"
                          ? greenColor
                          : redColor,
            ),
            label: user!.get("host ${index + 1}")["name"],
            onTap: () {
              currentIndex = index;
              setState(() {});
              screensController.jumpToPage(currentIndex);
            },
          ),
      ],
    );
  }
}
