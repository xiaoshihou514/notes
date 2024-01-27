import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:notes/colors.dart';

class MarkdownPreviewPage extends StatelessWidget {
  // TODO: change attr to file path
  final String data;

  const MarkdownPreviewPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title:
              const Text('Simple Markdown Demo', style: TextStyle(color: fg)),
          backgroundColor: bg,
          scrolledUnderElevation: 0,
          elevation: 0),
      backgroundColor: bg,
      body: Markdown(
          data: data,
          styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
          styleSheet: MarkdownStyleSheet(
              // link color
              a: const TextStyle(
                  color: cyan,
                  decoration: TextDecoration.underline,
                  decorationColor: cyan),
              p: const TextStyle(
                color: fg,
              ),
              h1: const TextStyle(color: blue),
              h2: const TextStyle(color: blue),
              h3: const TextStyle(color: blue),
              h4: const TextStyle(color: blue),
              h5: const TextStyle(color: blue),
              h6: const TextStyle(color: blue),
              tableHead: const TextStyle(
                color: fg,
              ),
              tableBody: const TextStyle(
                color: fg,
              ),
              tableBorder: TableBorder.all(color: fg),
              code: const TextStyle(backgroundColor: bg, color: shade_5),
              codeblockDecoration: const BoxDecoration(color: bg))),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white54,
          foregroundColor: Colors.black,
          child: const Icon(Icons.edit_rounded),
          // TODO
          onPressed: () {}));
}
