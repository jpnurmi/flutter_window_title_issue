import 'dart:async';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'libgtk.g.dart';

final libgtk = LibGtk(ffi.DynamicLibrary.open('libgtk-3.so.0'));

const methodChannel = MethodChannel('flutter_window_title_issue');

String formatWindowTitle(String document) {
  return document.isEmpty ? 'My App' : 'My App - $document';
}

void setWindowTitle(String title) {
  print('setWindowTitle: "$title"');

  ffi.using((arena) {
    final app = libgtk.g_application_get_default();
    final window = libgtk.gtk_application_get_active_window(app.cast());

    final str = title.toNativeUtf8(allocator: arena);
    final titlebar = libgtk.gtk_window_get_titlebar(window);
    libgtk.gtk_header_bar_set_title(titlebar.cast(), str.cast());
  });
}

void main() {
  final document = ValueNotifier<String>('');

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    final name = List.generate(timer.tick % 6, (i) => '${i + 1}').join();
    document.value = name;
    setWindowTitle(formatWindowTitle(name));
  });

  runApp(
    ValueListenableBuilder<String>(
      valueListenable: document,
      builder: (context, value, child) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text(formatWindowTitle(value))),
            body: Center(child: Text(value)),
          ),
        );
      },
    ),
  );
}
