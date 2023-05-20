/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:noteapp_client/src/protocol/note.dart' as _i3;
import 'package:serverpod_auth_client/module.dart' as _i4;
import 'dart:io' as _i5;
import 'protocol.dart' as _i6;

class _EndpointNote extends _i1.EndpointRef {
  _EndpointNote(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'note';

  /// Create new note on the database
  _i2.Future<bool> createNote(_i3.Note note) => caller.callServerEndpoint<bool>(
        'note',
        'createNote',
        {'note': note},
      );

  /// Delete note from database
  _i2.Future<bool> deleteNote(int id) => caller.callServerEndpoint<bool>(
        'note',
        'deleteNote',
        {'id': id},
      );

  /// Update an existing not with the given note object
  _i2.Future<bool> updateNote(_i3.Note note) => caller.callServerEndpoint<bool>(
        'note',
        'updateNote',
        {'note': note},
      );

  /// Retrieve all saved notes from the database
  _i2.Future<List<_i3.Note>> getNotes() =>
      caller.callServerEndpoint<List<_i3.Note>>(
        'note',
        'getNotes',
        {},
      );
}

class _Modules {
  _Modules(Client client) {
    auth = _i4.Caller(client);
  }

  late final _i4.Caller auth;
}

class Client extends _i1.ServerpodClient {
  Client(
    String host, {
    _i5.SecurityContext? context,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
  }) : super(
          host,
          _i6.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
        ) {
    note = _EndpointNote(this);
    modules = _Modules(this);
  }

  late final _EndpointNote note;

  late final _Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {'note': note};
  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
