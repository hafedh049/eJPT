import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:ejpt/utils/shared.dart';
import 'package:ejpt/views/message_shaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:super_clipboard/super_clipboard.dart';

import '../utils/callbacks.dart';

class Host extends StatefulWidget {
  const Host({super.key, required this.number});
  final int number;
  @override
  State<Host> createState() => _HostState();
}

class _HostState extends State<Host> {
  final List<String> _types = const <String>["Active", "Rabbit Hole", "Disabled"];

  final TextEditingController _promptController = TextEditingController();

  final GlobalKey<State<StatefulWidget>> _buttonsState = GlobalKey<State<StatefulWidget>>();
  final GlobalKey<State<StatefulWidget>> _messagesKey = GlobalKey<State<StatefulWidget>>();

  final List<Map<dynamic, dynamic>> _messages = <Map<dynamic, dynamic>>[];

  final SystemClipboard? clipboard = SystemClipboard.instance;

  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    _messages.addAll((user!.get("host ${widget.number}")["messages"] as List<dynamic>).cast<Map<dynamic, dynamic>>());
    super.initState();
  }

  Future<void> _add() async {
    if (_promptController.text.isNotEmpty) {
      final Map<String, dynamic> data = <String, dynamic>{
        "timestamp": DateTime.now(),
        "message": _promptController.text.trim(),
        "is_last": true,
        "type": "text",
        "reacts": <String>[],
      };
      _messages.insert(0, data);
      _promptController.text = "";

      await user!.put("host ${widget.number}", user!.get("host ${widget.number}")..update("messages", (dynamic value) => _messages));
      _messagesKey.currentState!.setState(() {});
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent value) async {
        if (value is KeyDownEvent && HardwareKeyboard.instance.isControlPressed && value.logicalKey == LogicalKeyboardKey.keyV) {
          await pasteClipboard(
            clipboard!,
            _messages,
            () async {
              _promptController.text = "";
              await user!.put("host ${widget.number}", user!.get("host ${widget.number}")..update("messages", (dynamic value) => _messages));
              _messagesKey.currentState!.setState(() {});
            },
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(user!.get("host ${widget.number}")["name"], style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: whiteColor))
              .animate(
                onComplete: (AnimationController controller) => controller.repeat(reverse: true),
              )
              .shimmer(color: pinkColor.withOpacity(.6), duration: 2.seconds),
          const SizedBox(height: 20),
          Divider(thickness: .5, height: .5, color: whiteColor.withOpacity(.6)),
          const SizedBox(height: 20),
          AnimatedToggleSwitch<int>.rolling(
            current: _types.indexOf(user!.get("host ${widget.number}")["type"]),
            values: const <int>[0, 1, 2],
            onChanged: (int index) {
              user!.put("host ${widget.number}", user!.get("host ${widget.number}")..update("type", (dynamic value) => _types[index]));
              setState(() {});
            },
            iconList: const <Tooltip>[
              Tooltip(message: "Active", child: Icon(FontAwesome.basketball_solid, color: greenColor, size: 25)),
              Tooltip(message: "Rabbit Hole", child: Icon(FontAwesome.frog_solid, color: yellowColor, size: 25)),
              Tooltip(message: "Disabled", child: Icon(FontAwesome.circle_chevron_down_solid, color: redColor, size: 25)),
            ],
            style: ToggleStyle(backgroundColor: scaffoldColor, borderRadius: BorderRadius.circular(15)),
          ),
          const SizedBox(height: 20),
          Divider(thickness: .5, height: .5, color: whiteColor.withOpacity(.6)),
          const SizedBox(height: 20),
          Expanded(
            child: StatefulBuilder(
              key: _messagesKey,
              builder: (BuildContext context, void Function(void Function()) _) {
                return ListView.separated(
                  reverse: true,
                  itemBuilder: (BuildContext context, int index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(backgroundImage: AssetImage(profilePPath), backgroundColor: transparentColor, radius: 20),
                      const SizedBox(width: 10),
                      Expanded(child: MessageShaker(item: _messages[index])),
                    ],
                  ),
                  separatorBuilder: (BuildContext context, int index) => Container(padding: const EdgeInsets.symmetric(vertical: 10), child: Divider(thickness: .3, height: .3, color: whiteColor.withOpacity(.6))),
                  itemCount: _messages.length,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: scaffoldColor, border: Border.all(width: 2, color: whiteColor.withOpacity(.5))),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                        controller: _promptController,
                        onChanged: (String? value) {
                          if (value!.length <= 1) {
                            _(() {});
                            _buttonsState.currentState!.setState(() {});
                          }
                        },
                        onEditingComplete: () async => await _add(),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          border: InputBorder.none,
                          hintText: "Prompt something...",
                          prefixIcon: _promptController.text.isEmpty ? null : const Icon(FontAwesome.circle_check, size: 15, color: pinkColor),
                          hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                        ),
                      );
                    },
                  ),
                ),
                StatefulBuilder(
                  key: _buttonsState,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return _promptController.text.isNotEmpty
                        ? IconButton(onPressed: () async => await _add(), icon: const Icon(FontAwesome.paper_plane_solid, size: 15, color: pinkColor))
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(onPressed: () {}, icon: const Icon(FontAwesome.file_code_solid, size: 15, color: pinkColor)),
                              IconButton(onPressed: () {}, icon: const Icon(FontAwesome.image_solid, size: 15, color: pinkColor)),
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
