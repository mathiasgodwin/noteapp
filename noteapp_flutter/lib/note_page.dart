import 'package:flutter/material.dart';
import 'package:noteapp_client/noteapp_client.dart';
import 'package:noteapp_flutter/account_page.dart';
import 'package:noteapp_flutter/serverpod_client.dart';

/// TODO: Finish the docs
/// NotePage to...
class NotePage extends StatefulWidget {
  /// Static named route for page
  static const String route = 'Note';

  /// Static method to return the widget as a PageRoute
  static Route go() => MaterialPageRoute<void>(builder: (_) => NotePage());

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _textEditingController = TextEditingController();

  // Calls the `createNote` method of the `note` endpoint. Will set `_errorMessage` field,
  void _callNote() async {
    try {
      await client.note.createNote(Note(
        data: _textEditingController.text,
        date: DateTime.now(),
      ));
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take Note'), actions: [
        IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(AccountPage.go());
            })
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Enter your Note',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _callNote,
                child: const Text('Send to Server'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
