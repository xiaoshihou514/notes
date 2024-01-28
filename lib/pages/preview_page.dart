import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:notes/pages/editor_page.dart';
import 'package:notes/pages/home_page.dart';

const fg = Colors.white70;
final bg = Colors.grey.shade900;
final blue = Colors.blueGrey.shade400;
final cyan = Colors.cyan.shade200;

class MarkdownPreviewPage extends StatelessWidget {
  final String path;
  final String fileName;

  const MarkdownPreviewPage(
      {required this.path, required this.fileName, super.key});

  String readFile() => File(path).readAsStringSync();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const HomePage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              padding: const EdgeInsets.all(0),
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.shade800.withOpacity(.8),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white54,
                ),
              )),
          title: Text(fileName, style: const TextStyle(color: Colors.white)),
          backgroundColor: bg,
          scrolledUnderElevation: 0,
          elevation: 0),
      backgroundColor: bg,
      body: Markdown(
          data: readFile(),
          styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
          styleSheet: MarkdownStyleSheet(
              // link color
              a: TextStyle(
                  color: cyan,
                  decoration: TextDecoration.underline,
                  decorationColor: cyan),
              p: const TextStyle(
                color: fg,
              ),
              h1: TextStyle(color: blue),
              h2: TextStyle(color: blue),
              h3: TextStyle(color: blue),
              h4: TextStyle(color: blue),
              h5: TextStyle(color: blue),
              h6: TextStyle(color: blue),
              tableHead: const TextStyle(
                color: fg,
              ),
              tableBody: const TextStyle(
                color: fg,
              ),
              tableBorder: TableBorder.all(color: fg),
              code: TextStyle(backgroundColor: bg, color: Colors.grey),
              codeblockDecoration: BoxDecoration(color: bg))),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white54,
          foregroundColor: Colors.black,
          child: const Icon(Icons.edit_rounded),
          onPressed: () {
            // Navigator.pop and Navigator.push would result in animations
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    EditPage(path: path, fileName: fileName),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }));
}
