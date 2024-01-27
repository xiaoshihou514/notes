import 'dart:convert';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/colors.dart';
import 'package:notes/notes.dart';

import 'editor_page.dart';

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
    setState(() {
      shownNotes = allNotes
          .where((note) =>
              note.relativePath
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              note.preview.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    initializeNotes();
  }

  Future<void> initializeNotes() async {
    allNotes = await getNotes();
    setState(() {
      shownNotes = allNotes;
    });
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
        preview: await lines.join("\n"),
        modifiedTime: f.lastModifiedSync(),
      );
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 70, 16, 0),
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
              // list of notes
              ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 30),
                  itemCount: shownNotes.length,
                  itemBuilder: (ctx, idx) {
                    return Card(
                        margin: const EdgeInsets.only(bottom: 20),
                        color: Colors.blueGrey.shade900,
                        child: ListTile(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => EditPage(),
                              ),
                            );
                            if (result != null) {
                              // TODO
                            }
                          },
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Edited: ${DateFormat('yyyy MMM d, h:mm a').format(shownNotes[idx].modifiedTime)}',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white54),
                            ),
                          ),
                          title: RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: '${shownNotes[idx].relativePath}\n',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      height: 1.5),
                                  children: [
                                    TextSpan(
                                      text: shownNotes[idx].preview,
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          height: 1.5),
                                    )
                                  ])),
                        ));
                  })
            ])));
  }
}
