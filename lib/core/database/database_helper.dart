import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/rotations/domain/models/match_state.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('volley_coach.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Table for the active match state (singleton)
    await db.execute('''
      CREATE TABLE active_match (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        data TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Table for point logs
    await db.execute('''
      CREATE TABLE point_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        match_roster_id TEXT,
        set_number INTEGER NOT NULL,
        home_score INTEGER NOT NULL,
        opponent_score INTEGER NOT NULL,
        type TEXT NOT NULL,
        home_player_ids TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        home_rotation INTEGER NOT NULL,
        opponent_rotation INTEGER NOT NULL
      )
    ''');
  }

  // --- Active Match Operations ---

  Future<void> saveMatchState(Map<String, dynamic> stateJson) async {
    final db = await database;
    await db.insert(
      'active_match',
      {
        'id': 1,
        'data': jsonEncode(stateJson),
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getMatchState() async {
    final db = await database;
    final maps = await db.query('active_match', where: 'id = ?', whereArgs: [1]);

    if (maps.isNotEmpty) {
      return jsonDecode(maps.first['data'] as String) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<void> clearMatchState() async {
    final db = await database;
    await db.delete('active_match', where: 'id = ?', whereArgs: [1]);
    // Optionally clear logs too if "reset match" implies clearing history
    // await db.delete('point_logs'); 
  }

  // --- Point Log Operations ---

  Future<void> addPointLog(PointLog log, String? matchRosterId) async {
    final db = await database;
    await db.insert('point_logs', {
      'match_roster_id': matchRosterId,
      'set_number': log.setNumber,
      'home_score': log.homeScore,
      'opponent_score': log.opponentScore,
      'type': log.type.name,
      'home_player_ids': log.homePlayerIds.join(','),
      'timestamp': log.timestamp.toIso8601String(),
      'home_rotation': log.homeRotation,
      'opponent_rotation': log.opponentRotation,
    });
  }

  Future<List<PointLog>> getPointLogs(String? matchRosterId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'point_logs',
      where: matchRosterId != null ? 'match_roster_id = ?' : null,
      whereArgs: matchRosterId != null ? [matchRosterId] : null,
      orderBy: 'timestamp ASC',
    );

    return List.generate(maps.length, (i) {
      return PointLog(
        homeScore: maps[i]['home_score'],
        opponentScore: maps[i]['opponent_score'],
        setNumber: maps[i]['set_number'],
        type: PointType.values.firstWhere((e) => e.name == maps[i]['type']),
        homePlayerIds: (maps[i]['home_player_ids'] as String).split(','),
        timestamp: DateTime.parse(maps[i]['timestamp']),
        homeRotation: maps[i]['home_rotation'],
        opponentRotation: maps[i]['opponent_rotation'],
      );
    });
  }
  
  Future<void> clearLogs() async {
    final db = await database;
    await db.delete('point_logs');
  }

  Future<void> deleteLastLog(String? matchRosterId) async {
    final db = await database;
    // Get the last log ID
    final lastLogList = await db.query(
      'point_logs',
      columns: ['id'],
      where: matchRosterId != null ? 'match_roster_id = ?' : null,
      whereArgs: matchRosterId != null ? [matchRosterId] : null,
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    
    if (lastLogList.isNotEmpty) {
      final id = lastLogList.first['id'];
      await db.delete('point_logs', where: 'id = ?', whereArgs: [id]);
    }
  }
}
