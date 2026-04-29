import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/article.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  static Database? _database;

  factory DbService() => _instance;

  DbService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'news_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE articles(
        id TEXT PRIMARY KEY,
        title TEXT,
        imageUrl TEXT,
        source TEXT,
        content TEXT,
        sentiment TEXT,
        summary TEXT
      )
    ''');
  }

  Future<void> insertArticles(List<Article> articles) async {
    final db = await database;
    Batch batch = db.batch();
    for (var article in articles) {
      batch.insert(
        'articles',
        article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> clearArticles() async {
    final db = await database;
    await db.delete('articles');
  }

  Future<List<Article>> getArticles({int limit = 20, int offset = 0}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'articles',
      limit: limit,
      offset: offset,
    );
    return List.generate(maps.length, (i) => Article.fromMap(maps[i]));
  }

  Future<void> updateArticle(Article article) async {
    final db = await database;
    await db.update(
      'articles',
      article.toMap(),
      where: 'id = ?',
      whereArgs: [article.id],
    );
  }

  Future<Map<String, int>> getAnalytics() async {
    final db = await database;
    int total = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM articles')) ?? 0;
    int positive = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM articles WHERE sentiment = "Positive"')) ?? 0;
    int negative = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM articles WHERE sentiment = "Negative"')) ?? 0;
    int neutral = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM articles WHERE sentiment = "Neutral"')) ?? 0;
    
    return {
      'total': total,
      'positive': positive,
      'negative': negative,
      'neutral': neutral,
    };
  }
}
