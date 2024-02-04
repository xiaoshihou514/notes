import 'dart:io';

import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final String absPath;
  final String fileName;

  const EditPage({required this.absPath, required this.fileName, super.key});

  @override
  State<EditPage> createState() =>
      // ignore: no_logic_in_create_state
      _EditPageState(path: absPath, fileName: fileName);
}

class _EditPageState extends State<EditPage> {
  final String path;
  final String fileName;
  late File file;

  _EditPageState({required this.path, required this.fileName});

  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    file = File(path);
    if (!file.existsSync()) {
      file.createSync();
    }
    _contentController = TextEditingController(text: file.readAsStringSync());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        file.writeAsStringSync(_contentController.text, flush: true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("$fileName saved!"), duration: Durations.long1));
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
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
            backgroundColor: Colors.grey.shade900,
            scrolledUnderElevation: 0,
            elevation: 0),
        backgroundColor: Colors.grey.shade900,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(children: [
            Expanded(
                child: ListView(
              children: [
                TextField(
                  controller: _contentController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      )),
                ),
              ],
            ))
          ]),
        ),
      ),
    );
  }
}
