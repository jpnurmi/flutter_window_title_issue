import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

final dylib = DynamicLibrary.open('libgtk-3.so.0');

final g_application_get_default =
    dylib.lookupFunction<Pointer Function(), Pointer Function()>(
        'g_application_get_default');
final gtk_application_get_active_window =
    dylib.lookupFunction<Pointer Function(Pointer), Pointer Function(Pointer)>(
        'gtk_application_get_active_window');
final gtk_header_bar_set_title = dylib.lookupFunction<
    Void Function(Pointer, Pointer),
    void Function(Pointer, Pointer)>('gtk_header_bar_set_title');
final gtk_window_get_titlebar =
    dylib.lookupFunction<Pointer Function(Pointer), Pointer Function(Pointer)>(
        'gtk_window_get_titlebar');

void setWindowTitle(String title) {
  print('setWindowTitle: "$title"');

  using((arena) {
    final app = g_application_get_default();
    final window = gtk_application_get_active_window(app);
    final titlebar = gtk_window_get_titlebar(window);
    gtk_header_bar_set_title(titlebar, title.toNativeUtf8(allocator: arena));
  });
}

String formatWindowTitle(String document) {
  return document.isEmpty ? 'My App' : 'My App - $document';
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
