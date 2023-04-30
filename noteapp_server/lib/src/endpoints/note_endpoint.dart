import 'package:noteapp_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class NoteEndpoint extends Endpoint {
  /// Create new note on the database
  Future<bool> createNote(Session session, Note note) async {
    await Note.insert(session, note);
    return true;
  }

  /// Delete note from database
  Future<bool> deleteNote(Session session, int id) async {
    final response =
        await Note.delete(session, where: (note) => note.id.equals(id));
    return response == 1;
  }

  /// Update an existing not with the given note object
  Future<bool> updateNote(Session session, Note note) async {
    final response = await Note.update(session, note);
    return response;
  }

  /// Retrieve all saved notes from the database
  Future<List<Note>> getNotes(Session session) async {
    final notes = Note.find(session);
    return notes;
  }
}
