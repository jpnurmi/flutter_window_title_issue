import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const methodChannel = MethodChannel('flutter_window_title_issue');

String formatWindowTitle(String document) {
  return document.isEmpty ? 'My App' : 'My App - $document';
}

Future<void> setWindowTitle(String title) {
  print('setWindowTitle: "$title"');
  return methodChannel.invokeMethod('setWindowTitle', title);
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
