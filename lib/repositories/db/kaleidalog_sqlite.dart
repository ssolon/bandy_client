import 'dart:io';

import 'package:bandy_client/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

// Table/field name names

const tagsTable = "tags";
const tagIdColumn = "tag_id";
const tagNameColumn = "tag_name";
const tagDescriptionColumn = "tag_description";

const eventTypesTable = "event_types";
const eventTypeIdColumn = "event_type_id";
const eventTypeNameColumn = "event_type_name";
const eventTypeDescriptionColumn = "event_type_description";
const eventTypeDetailsColumn = "event_type_details";

const eventsTable = "events";
const eventIdColumn = "event_id";
const eventAtColumn = "event_at";
const eventParentIdColumn = "event_parent_id";
const eventDetailsColumn = "event_details";

const tagsForEventTable = "tags_for_event";

const tagsForEventTypeTable = "tags_for_event_type";

const userSettingsTable = "user_settings";
const settingIdColumn = "setting_id";
const settingsColumn = "settings";

final kaleidaLogDbProvider =
    Provider<DB>((_) => throw Exception('KaleidalogDB not initialized'));

typedef TableRow = Map<String, Object?>;
typedef QueryResult = List<TableRow>;

enum DateOrder {
  oldest('ASC'),
  newest('DESC');

  const DateOrder(this.order);

  final String order;
}

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

  /// Create an event for the parameters created a UUID for the eventId if
  /// not provided.
  /// Returns eventId
  Future<UuidValue> createEvent({
    UuidValue? eventId,
    required DateTime at,
    required UuidValue eventTypeId,
    UuidValue? parentId,
    String? jsonDetails,
  });

  /// Fetch
  // FIXME Make [order] work -- was getting an error passing parameters
  Future<QueryResult> fetchSessions({DateOrder order = DateOrder.newest}) {
    const sql = '''
      SELECT e.event_id, et.event_type_name, e.event_at
        FROM events e
        JOIN event_types et USING(event_type_id)
        JOIN tags_for_event_type tfet USING(event_type_id)
        JOIN tags t USING(tag_id)
      WHERE et.event_type_name = 'Session' AND t.tag_name = 'bandy'
      ORDER BY e.event_at DESC''';

    return executeQuery(sql, []); //['DESC']);
  }

  Future<QueryResult> fetchSession(UuidValue sessionId) {
    const sql = '''
      WITH RECURSIVE workout AS (
        SELECT e.event_id, e.event_type_id, et.event_type_name, e.event_at, e.event_parent_id, e.event_details, 1 as level
          FROM events e
          JOIN event_types et USING(event_type_id)
          WHERE event_id = ?
          UNION ALL
          SELECT this.event_id, this.event_type_id, et.event_type_name, this.event_at, this.event_parent_id, this.event_details, level + 1
            FROM events this
            JOIN event_types et USING(event_type_id)
            INNER JOIN workout prior ON this.event_parent_id = prior.event_id
      )
      SELECT w.event_type_name, w.event_type_id, w.event_id, w.event_at, w.level, w.event_details
      FROM workout w
      ORDER BY w.event_at''';

    return executeQuery(sql, [sessionId.toString()]);
  }
}

/// Kaleidalog specific database operations
class KaleidaLogDb extends DB {
  late final String dbName;
  Database? _db;
  final Uuid uuid = const Uuid();

  Database get db =>
      _db != null ? _db! : throw Exception("Uninitialized/closed database");

  KaleidaLogDb([String? databaseName]) {
    dbName = databaseName ?? join(storageDirectory!.path, 'kaleidalog.db');
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
    CREATE TABLE $tagsTable(
      $tagIdColumn UUID PRIMARY KEY,
      $tagNameColumn TEXT,
      $tagDescriptionColumn TEXT
    );

    CREATE TABLE $eventTypesTable(
      $eventTypeIdColumn UUID PRIMARY KEY,
      $eventTypeNameColumn TEXT NOT NULL,
      $eventTypeDescriptionColumn TEXT,
      $eventTypeDetailsColumn TEXT
    );

    CREATE TABLE $eventsTable(
      $eventIdColumn UUID PRIMARY KEY,
      $eventAtColumn TIMESTAMP NOT NULL,
      $eventTypeIdColumn UUID NOT NULL REFERENCES $eventTypesTable($eventTypeIdColumn),
      $eventParentIdColumn UUID REFERENCES $eventsTable($eventIdColumn),
      $eventDetailsColumn TEXT
      );

    CREATE TABLE $tagsForEventTable(
      $eventIdColumn UUID NOT NULL REFERENCES $eventsTable($eventIdColumn),
      $tagIdColumn UUID NOT NULL REFERENCES $tagsTable($tagIdColumn),
      PRIMARY KEY ($eventIdColumn, $tagIdColumn)
    );

    CREATE TABLE $tagsForEventTypeTable(
      $eventTypeIdColumn UUID NOT NULL REFERENCES $eventTypesTable($eventIdColumn),
      $tagIdColumn UUID NOT NULL REFERENCES $tagsTable($tagIdColumn),
      PRIMARY KEY ($eventTypeIdColumn, $tagIdColumn)
    );

    CREATE TABLE $userSettingsTable(
      $settingIdColumn UUID PRIMARY KEY,
      $settingsColumn TEXT
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

  @override
  Future<UuidValue> createEvent({
    UuidValue? eventId,
    DateTime? at,
    required UuidValue eventTypeId,
    UuidValue? parentId,
    String? jsonDetails,
  }) async {
    final id = eventId?.uuid ?? uuid.v4();

    db.insert(eventsTable, {
      eventIdColumn: id,
      eventAtColumn: (at ?? DateTime.now()).toIso8601String(),
      eventTypeIdColumn: eventTypeId.uuid,
      eventParentIdColumn: parentId?.uuid,
      eventDetailsColumn: jsonDetails,
    });

    return UuidValue(id);
  }
}
