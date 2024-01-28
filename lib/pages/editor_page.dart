import 'package:flutter/material.dart';
import 'package:notes/pages/home_page.dart';

class EditPage extends StatefulWidget {
  final String path;
  final String fileName;

  const EditPage({required this.path, required this.fileName, super.key});

  @override
  State<EditPage> createState() =>
      // ignore: no_logic_in_create_state
      _EditPageState(path: path, fileName: fileName);
}

class _EditPageState extends State<EditPage> {
  final String path;
  final String fileName;

  _EditPageState({required this.path, required this.fileName});

  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    hintText: "Add content here",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    )),
              ),
            ],
          ))
        ]),
      ),
    );
  }
}
