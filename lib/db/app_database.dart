
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'memo.dart';
import 'comment.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init() {
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gc_memo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: _onCreate,
      ),
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE memos(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user TEXT,
      content TEXT,
      timestamp TEXT
    )
    ''');

    await db.execute('''
  CREATE TABLE comments(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    memoId INTEGER,
    user TEXT,
    content TEXT,
    timestamp TEXT,
    FOREIGN KEY (memoId) REFERENCES memos (id) ON DELETE CASCADE
  )
  ''');
    print('Database created and tables are initialized.');
  }


  Future<int> insertMemo(Memo memo) async {
    final db = await instance.database;
    return await _insertMemoBackground(db, memo);
  }

  Future<int> _insertMemoBackground(Database db, Memo memo) async {
    return await db.insert('memos', memo.toMap());
  }

  Future<List<Memo>> getMemos() async {
    final db = await instance.database;
    return await _getMemosBackground(db);
  }

  Future<List<Memo>> _getMemosBackground(Database db) async {
    final result = await db.query('memos');
    return result.map((e) => Memo.fromMap(e)).toList();
  }

  Future<int> deleteMemo(int id) async {
    final db = await instance.database;
    return await db.delete(
      'memos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> _insertCommentBackground(Database db, Comment comment) async {
    return await db.insert('comments', comment.toMap());
  }

  Future<List<Comment>> _getCommentsBackground(Database db, int memoId) async {
    final result = await db.query(
      'comments',
      where: 'memoId = ?',
      whereArgs: [memoId],
    );
    return result.map((e) => Comment.fromMap(e)).toList();
  }

  Future<int> insertComment(Comment comment) async {
    final db = await instance.database;
    return await _insertCommentBackground(db, comment);
  }

  Future<List<Comment>> getComments(int memoId) async {
    final db = await instance.database;
    return await _getCommentsBackground(db, memoId);
  }

  Future<int> _deleteCommentBackground(Database db, int id) async {
    return await db.delete(
      'comments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteComment(int id) async {
    final db = await instance.database;
    return await _deleteCommentBackground(db, id);
  }

// 특정 메모에 연결된 모든 댓글 삭제 (메모 삭제 시 필요)
  Future<int> deleteCommentsByMemo(int memoId) async {
    final db = await instance.database;
    return await db.delete(
      'comments',
      where: 'memoId = ?',
      whereArgs: [memoId],
    );
  }
  Future<int> updateMemo(Memo memo) async {
    final db = await instance.database;
    return await _updateMemoBackground(db, memo);
  }

  Future<int> _updateMemoBackground(Database db, Memo memo) async {
    return await db.update(
      'memos',
      memo.toMap(),
      where: 'id = ?',
      whereArgs: [memo.id],
    );
  }

  Future<int> updateComment(Comment comment) async {
    final db = await instance.database;
    return await _updateCommentBackground(db, comment);
  }

  Future<int> _updateCommentBackground(Database db, Comment comment) async {
    return await db.update(
      'comments',
      comment.toMap(),
      where: 'id = ?',
      whereArgs: [comment.id],
    );
  }

}
