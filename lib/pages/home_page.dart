import 'dart:convert';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:notes/colors.dart';
import 'package:notes/notes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> allNotes = [];
  List<Note> shownNotes = [];

  _HomePageState();

  void onSearchTextChanged(String searchText) {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            child: Column(children: [
              // search panel
              TextField(
                onChanged: onSearchTextChanged,
                style: const TextStyle(fontSize: 16, color: fg),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  fillColor: Colors.grey.shade800,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ])));
  }

  Future<List<Note>> getNotes() async {
    final documentsPath = await AndroidPathProvider.documentsPath;
    final files = await Directory(documentsPath).list(recursive: true).toList();
    return await Future.wait(
        files.whereType<File>().toList().map((File f) async {
      final lines = f
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .take(5);

      return Note(
        relativePath: f.path.replaceAll(documentsPath, ""),
        preview: await lines.join(),
        modifiedTime: f.lastModifiedSync(),
      );
    }).toList());
  }
}
