import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:toastification/toastification.dart';

import 'shared.dart';

void showToast(BuildContext context, String message, Color color) {
  toastification.show(
    context: context,
    description: Text(message, style: GoogleFonts.itim(fontSize: 14, fontWeight: FontWeight.w500, color: darkColor)),
    title: Text("Notification", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: color)),
    autoCloseDuration: 5.seconds,
    backgroundColor: whiteColor,
    type: ToastificationType.info,
    primaryColor: color,
    style: ToastificationStyle.minimal,
    progressBarTheme: ProgressIndicatorThemeData(color: color, linearMinHeight: .5),
    foregroundColor: color,
  );
}

Future<void> init() async {
  Hive.init((await getApplicationDocumentsDirectory()).path);
  user = await Hive.openBox("user");
  if (!user!.containsKey("host 1")) {
    user!.put(
      "host 1",
      <String, dynamic>{
        "name": "First Host",
        "type": "Active",
        "messages": <Map<String, dynamic>>[],
      },
    );
  }
  if (!user!.containsKey("host 2")) {
    user!.put(
      "host 2",
      <String, dynamic>{
        "name": "Second Host",
        "type": "Active",
        "messages": <Map<String, dynamic>>[],
      },
    );
  }
  if (!user!.containsKey("host 3")) {
    user!.put(
      "host 3",
      <String, dynamic>{
        "name": "Third Host",
        "type": "Active",
        "messages": <Map<String, dynamic>>[],
      },
    );
  }
  if (!user!.containsKey("host 4")) {
    user!.put(
      "host 4",
      <String, dynamic>{
        "name": "Fourth Host",
        "type": "Active",
        "messages": <Map<String, dynamic>>[],
      },
    );
  }
  if (!user!.containsKey("host 5")) {
    user!.put(
      "host 5",
      <String, dynamic>{
        "name": "Fifth Host",
        "type": "Active",
        "messages": <Map<String, dynamic>>[],
      },
    );
  }
  if (!user!.containsKey("host 6")) {
    user!.put(
      "host 6",
      <String, dynamic>{
        "name": "Sixth Host",
        "type": "Active",
        "messages": <Map<String, dynamic>>[],
      },
    );
  }
}

Future<void> pasteClipboard(SystemClipboard clipboard, List<Map<dynamic, dynamic>> messages, void Function() callback) async {
  //showToast(context, "", greenColor);

  final ClipboardReader reader = await clipboard.read();
  if (reader.canProvide(Formats.htmlText)) {
    final String? html = await reader.readValue(Formats.htmlText);

    if (html != null && html.isNotEmpty) {
      final Map<String, dynamic> data = <String, dynamic>{
        "timestamp": DateTime.now(),
        "message": html,
        "is_last": true,
        "type": "video",
        "reacts": <String>[],
      };
      messages.insert(0, data);
      callback();
    }
  } else if (reader.canProvide(Formats.plainText)) {
    final String? text = await reader.readValue(Formats.plainText);

    if (text != null && text.isNotEmpty) {
      final Map<String, dynamic> data = <String, dynamic>{
        "timestamp": DateTime.now(),
        "message": text,
        "is_last": true,
        "type": "text",
        "reacts": <String>[],
      };
      messages.insert(0, data);
      callback();
    }
  } else if (reader.canProvide(Formats.png)) {
    reader.getFile(
      Formats.png,
      (DataReaderFile file) async {
        final Uint8List pngImage = await file.readAll();
        final Map<String, dynamic> data = <String, dynamic>{
          "timestamp": DateTime.now(),
          "message": pngImage,
          "is_last": true,
          "type": "image",
          "mime": "PNG",
          "name": file.fileName,
          "size": file.fileSize,
          "reacts": <String>[],
        };
        messages.insert(0, data);
        callback();
      },
    );
  } else if (reader.canProvide(Formats.jpeg)) {
    reader.getFile(
      Formats.jpeg,
      (DataReaderFile file) async {
        final Uint8List jpegImage = await file.readAll();
        final Map<String, dynamic> data = <String, dynamic>{
          "timestamp": DateTime.now(),
          "message": jpegImage,
          "is_last": true,
          "type": "image",
          "mime": "JPEG",
          "name": file.fileName,
          "size": file.fileSize,
          "reacts": <String>[],
        };
        messages.insert(0, data);
        callback();
      },
    );
  } else if (reader.canProvide(Formats.json)) {
    reader.getFile(
      Formats.json,
      (DataReaderFile file) async {
        final Uint8List jsonImage = await file.readAll();
        final Map<String, dynamic> data = <String, dynamic>{
          "timestamp": DateTime.now(),
          "message": String.fromCharCodes(jsonImage),
          "is_last": true,
          "type": "json",
          "name": file.fileName,
          "size": file.fileSize,
          "reacts": <String>[],
        };
        messages.insert(0, data);
        callback();
      },
    );
  } else if (reader.canProvide(Formats.mp4)) {
    reader.getFile(
      Formats.json,
      (DataReaderFile file) async {
        final Uint8List video = await file.readAll();
        final Map<String, dynamic> data = <String, dynamic>{
          "timestamp": DateTime.now(),
          "message": video,
          "is_last": true,
          "type": "video",
          "name": file.fileName,
          "size": file.fileSize,
          "reacts": <String>[],
        };
        messages.insert(0, data);
        callback();
      },
    );
  }
}
