import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:icons_plus/icons_plus.dart';

import '../utils/shared.dart';

class MessageShaker extends StatefulWidget {
  const MessageShaker({super.key, required this.item});
  final Map<dynamic, dynamic> item;
  @override
  State<MessageShaker> createState() => _MessageShakerState();
}

class _MessageShakerState extends State<MessageShaker> {
  String _computeTimestamp(DateTime timestamp) {
    final DateTime now = DateTime.now();
    if (now.subtract(0.days).day == timestamp.day) {
      return formatDate(timestamp, const <String>["Today at ", HH, ':', nn, ' ', am]);
    } else if (now.subtract(1.days).day == timestamp.day) {
      return formatDate(timestamp, const <String>["Yesterday at ", HH, ':', nn, ' ', am]);
    } else {
      return formatDate(timestamp, const <String>[dd, "/", mm, "/", yyyy, " ", HH, ":", nn, " ", am]);
    }
  }

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(_computeTimestamp(widget.item["timestamp"]), style: GoogleFonts.itim(fontSize: 12, fontWeight: FontWeight.w500, color: whiteColor.withOpacity(.8))),
            const SizedBox(height: 10),
            widget.item["type"] == "text"
                ? Text(widget.item["message"], style: GoogleFonts.itim(fontSize: 12, fontWeight: FontWeight.w500, color: whiteColor))
                : widget.item["type"] == "image"
                    ? InkWell(
                        splashColor: transparentColor,
                        hoverColor: transparentColor,
                        highlightColor: transparentColor,
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * .8, maxHeight: 200),
                            child: Image.memory(widget.item["message"]),
                          ),
                        ),
                      )
                    : widget.item["type"] == "json"
                        ? JsonView.string(widget.item["message"], theme: const JsonViewTheme(backgroundColor: scaffoldColor, viewType: JsonViewType.collapsible))
                        : HtmlWidget(widget.item["message"]),
          ],
        ),
        AnimatedOpacity(
          duration: 300.ms,
          opacity: _isHovered ? 1 : 0,
          child: IgnorePointer(
            ignoring: !_isHovered,
            child: InkWell(
              splashColor: transparentColor,
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              onHover: (bool value) => setState(() => _isHovered = value),
              onTap: () {},
              child: IconButton(onPressed: () {}, icon: const Icon(Bootstrap.emoji_smile, size: 25, color: pinkColor)),
            ),
          ),
        ),
      ],
    );
  }
}
