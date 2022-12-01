import 'dart:io';

import 'package:bandy_client/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final kaleidaLogDbProvider =
    Provider<DB>((_) => throw Exception('KaleidalogDB not initialized'));

typedef QueryResult = List<Map<String, Object?>>;

/// All the methods that we'll need any database to provide
abstract class DB {
  /// Execute [sql] using [arguments].
  Future<QueryResult> executeQuery(String sql, List<Object?> arguments);

  /// Return the event types that match ALL of [tags].
  Future<QueryResult> fetchEventTypesByTags(List<String> tags) {
    final tagPlaceholders = List.filled(tags.length, '?').join(',');
    final arguments = [...tags, tags.length];

    final sql = '''
        SELECT et.event_type_name, et.event_type_id, group_concat(t.tag_name)  
          FROM event_types et 
          JOIN tags_for_event_type tfet USING(event_type_id)
          JOIN tags t USING(tag_id) WHERE t.tag_name IN ($tagPlaceholders)
          GROUP BY et.event_type_id
          HAVING COUNT(*) = ?''';

    return executeQuery(sql, arguments);
  }
}

/// Kaleidalog specific database operations
class KaleidaLogDb extends DB {
  late final String dbName;
  Database? _db;

  Database get db =>
      _db != null ? _db! : throw Exception("Uninitialized/closed database");

  KaleidaLogDb([String? databaseName]) {
    dbName = databaseName ??
        join(storageDirectory!.path, 'bandy_client', 'kaleidalog.db');
  }

  open() async {
    final dbFile = File(dbName);

    // await Sqflite.devSetDebugModeOn();
    // await databaseFactory.debugSetLogLevel(sqfliteLogLevelVerbose);

    if (await dbFile.exists()) {
      talker.info("Database $dbName already exists!!!!");
    } else {
      talker.info("Database $dbName doesn't exist");
    }

    _db = await openDatabase(
      dbName,
      version: 1,
      onCreate: _createSchema,
    );

    if (_db == null) {
      talker.error("Failed to open kaleidaLog=$dbName");
    } else {
      talker.info("KaleidaLog opened on path=${_db?.path}");
    }
  }

  /// Create the schema
  _createSchema(Database db, int version) async {
    const sql = '''
    CREATE TABLE tags(
      tag_id UUID PRIMARY KEY,
      tag_name TEXT,
      tag_description TEXT
    );

    CREATE TABLE event_types(
      event_type_id UUID PRIMARY KEY,
      event_type_name TEXT NOT NULL,
      event_type_description TEXT,
      event_type_details JSON
    );

    CREATE TABLE events(
      event_id UUID PRIMARY KEY,
      event_at DATETIME NOT NULL,
      event_type_id UUID NOT NULL,
      event_parent_id UUID REFERENCES events(event_id),
      event_details JSON
      );

    CREATE TABLE tags_for_event(
      event_id UUID NOT NULL REFERENCES events(event_id),
      tag_id UUID NOT NULL REFERENCES tags(tag_id),
      PRIMARY KEY (event_id, tag_id)
    );

    CREATE TABLE tags_for_event_type(
      event_type_id UUID NOT NULL REFERENCES event_types(event_type_id),
      tag_id UUID NOT NULL REFERENCES tags(tag_id),
      PRIMARY KEY (event_type_id, tag_id)
    );

    CREATE TABLE user_settings(
      setting_id UUID PRIMARY KEY,
      settings TEXT
    );
    ''';

    talker.info("Creating db schema for ${db.path}");
    await executeStatements(db, sql);
    talker.info("Schema SQL executed");

    await initTags(db);
    await initEventTypes(db);
  }

  /// Subclasses should override
  initTags(Database db) {}

  /// Subclasses should override
  initEventTypes(Database db) {}

  /// Create a tag table entry
  createTag(Database db, String tagUUID, String tagName,
      String? tagDescription) async {
    talker.info('CreateTag uuid=$tagUUID name=$tagName');

    return await db.insert(
      'tags',
      {
        'tag_id': tagUUID,
        'tag_name': tagName,
        'tag_description': tagDescription,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /// Create an eventType and associate it with [tags] uuid strings.
  createEventType(Database db, String eventTypeUUID, String eventTypeName,
      String? eventTypeDescription, List<String> tags) async {
    final batch = db.batch();

    talker.info("Create event uuid=$eventTypeUUID name=$eventTypeName");

    await db.insert(
      'event_types',
      {
        'event_type_id': eventTypeUUID,
        'event_type_name': eventTypeName,
        'event_type_description': eventTypeDescription,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    for (final id in tags) {
      await db.insert(
        'tags_for_event_type',
        {
          'event_type_id': eventTypeUUID,
          'tag_id': id,
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      batch.commit();
    }
  }

  /// Execute a string with multiple SQL statements separated by semicolons
  executeStatements(Database db, String sql) async {
    for (final s in sql.split(';')) {
      final cmd = s.trim();
      if (cmd.isNotEmpty) {
        logDebug("Execute $cmd");
        await db.execute(cmd);
      }
    }
  }

  @override
  Future<QueryResult> executeQuery(String sql, List<Object?> arguments) {
    return db.rawQuery(sql, arguments);
  }
}
