import 'dart:convert';
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/notes.dart';
import 'package:notes/pages/preview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> allNotes = [];
  List<Note> shownNotes = [];
  String notesPath = "";

  _HomePageState();

  void onSearchTextChanged(String searchText) {
    setState(() {
      shownNotes = allNotes
          .where((note) =>
              note.fileName.toLowerCase().contains(searchText.toLowerCase()) ||
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
    notesPath = "$documentsPath/notes";
    final files = await Directory(notesPath).list(recursive: true).toList();
    final notes =
        await Future.wait(files.whereType<File>().toList().map((File f) async {
      final lines = f
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .take(5);
      final path = f.path;
      final temp = path.split("/").last;

      return Note(
        absPath: path,
        fileName: temp.substring(0, temp.length - 3), // remove .md postfix
        preview: await lines.join("\n"),
        modifiedTime: f.lastModifiedSync(),
      );
    }).toList());
    notes.sort((n1, n2) => n2.modifiedTime.compareTo(n1.modifiedTime));
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Column(
          children: [
            // search panel
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 50, 18, 12),
              child: TextField(
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
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(children: [
                // list of notes
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 16, right: 16, bottom: 0),
                    child: ListView.builder(
                        itemCount: shownNotes.length,
                        itemBuilder: (ctx, idx) {
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red.shade300,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              final note = shownNotes.removeAt(idx);
                              File(note.absPath).deleteSync();
                            },
                            confirmDismiss: (direction) async {
                              bool dismiss = false;
                              if (direction == DismissDirection.endToStart) {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Deleting this note?",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        backgroundColor: Colors.grey.shade900,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              dismiss = true;
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Yes",
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              dismiss = false;
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "No",
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }
                              return dismiss;
                            },
                            child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white54,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: ListTile(
                                  onTap: () async => Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                MarkdownPreviewPage(
                                          path: shownNotes[idx].absPath,
                                          fileName: shownNotes[idx].fileName,
                                        ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      )).then((refresh) {
                                    if (refresh != null && refresh) {
                                      setState(() {
                                        final current =
                                            shownNotes.removeAt(idx);
                                        shownNotes.insert(0, current);
                                      });
                                    }
                                  }),
                                  title: RichText(
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: '${shownNotes[idx].fileName}\n',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              height: 1.5),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${DateFormat('yyyy MMM d').format(shownNotes[idx].modifiedTime)}\n",
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.white54),
                                            ),
                                            TextSpan(
                                              text: shownNotes[idx].preview,
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  height: 1.5),
                                            )
                                          ])),
                                )),
                          );
                        }),
                  ),
                )
              ]),
            ),
          ],
        ));
  }
}
