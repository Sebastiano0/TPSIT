// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TripDao? _tripDaoInstance;

  StopDao? _stopDaoInstance;

  TripStopDao? _tripStopDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Trip` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `lastUpdate` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Stop` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `latitude` REAL NOT NULL, `longitude` REAL NOT NULL, `name` TEXT NOT NULL, `info` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TripStop` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `trip_id` INTEGER NOT NULL, `stop_id` INTEGER NOT NULL, `position` INTEGER NOT NULL, FOREIGN KEY (`trip_id`) REFERENCES `Trip` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`stop_id`) REFERENCES `Stop` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TripDao get tripDao {
    return _tripDaoInstance ??= _$TripDao(database, changeListener);
  }

  @override
  StopDao get stopDao {
    return _stopDaoInstance ??= _$StopDao(database, changeListener);
  }

  @override
  TripStopDao get tripStopDao {
    return _tripStopDaoInstance ??= _$TripStopDao(database, changeListener);
  }
}

class _$TripDao extends TripDao {
  _$TripDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _tripInsertionAdapter = InsertionAdapter(
            database,
            'Trip',
            (Trip item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lastUpdate': item.lastUpdate
                }),
        _tripUpdateAdapter = UpdateAdapter(
            database,
            'Trip',
            ['id'],
            (Trip item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lastUpdate': item.lastUpdate
                }),
        _tripDeletionAdapter = DeletionAdapter(
            database,
            'Trip',
            ['id'],
            (Trip item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lastUpdate': item.lastUpdate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Trip> _tripInsertionAdapter;

  final UpdateAdapter<Trip> _tripUpdateAdapter;

  final DeletionAdapter<Trip> _tripDeletionAdapter;

  @override
  Future<List<Trip>> getAllTrips() async {
    return _queryAdapter.queryList('SELECT * FROM Trip',
        mapper: (Map<String, Object?> row) => Trip(row['id'] as int?,
            name: row['name'] as String,
            lastUpdate: row['lastUpdate'] as String?));
  }

  @override
  Future<Trip?> getTripById(int id) async {
    return _queryAdapter.query('SELECT * FROM Trip WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Trip(row['id'] as int?,
            name: row['name'] as String,
            lastUpdate: row['lastUpdate'] as String?),
        arguments: [id]);
  }

  @override
  Future<int?> getLastTrip() async {
    return _queryAdapter.query('SELECT id FROM trip ORDER BY id DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertTrip(Trip trip) async {
    await _tripInsertionAdapter.insert(trip, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    await _tripUpdateAdapter.update(trip, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteTrip(Trip trip) async {
    await _tripDeletionAdapter.delete(trip);
  }
}

class _$StopDao extends StopDao {
  _$StopDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _stopInsertionAdapter = InsertionAdapter(
            database,
            'Stop',
            (Stop item) => <String, Object?>{
                  'id': item.id,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'name': item.name,
                  'info': item.info
                }),
        _stopUpdateAdapter = UpdateAdapter(
            database,
            'Stop',
            ['id'],
            (Stop item) => <String, Object?>{
                  'id': item.id,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'name': item.name,
                  'info': item.info
                }),
        _stopDeletionAdapter = DeletionAdapter(
            database,
            'Stop',
            ['id'],
            (Stop item) => <String, Object?>{
                  'id': item.id,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'name': item.name,
                  'info': item.info
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Stop> _stopInsertionAdapter;

  final UpdateAdapter<Stop> _stopUpdateAdapter;

  final DeletionAdapter<Stop> _stopDeletionAdapter;

  @override
  Future<List<Stop>> getAllStops() async {
    return _queryAdapter.queryList('SELECT * FROM Stop',
        mapper: (Map<String, Object?> row) => Stop(row['id'] as int?,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            name: row['name'] as String,
            info: row['info'] as String?));
  }

  @override
  Future<Stop?> getStopById(int id) async {
    return _queryAdapter.query('SELECT * FROM Stop WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Stop(row['id'] as int?,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            name: row['name'] as String,
            info: row['info'] as String?),
        arguments: [id]);
  }

  @override
  Future<int?> getLastStop() async {
    return _queryAdapter.query('SELECT id FROM stop ORDER BY id DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<Stop>> getStopsByTripId(int tripId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Stop INNER JOIN TripStop ON Stop.id = TripStop.stop_id WHERE TripStop.trip_id = ?1',
        mapper: (Map<String, Object?> row) => Stop(row['id'] as int?, latitude: row['latitude'] as double, longitude: row['longitude'] as double, name: row['name'] as String, info: row['info'] as String?),
        arguments: [tripId]);
  }

  @override
  Future<Stop?> getStopByLatLng(
    double lat,
    double lng,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM Stop WHERE latitude = ?1 AND longitude = ?2',
        mapper: (Map<String, Object?> row) => Stop(row['id'] as int?,
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            name: row['name'] as String,
            info: row['info'] as String?),
        arguments: [lat, lng]);
  }

  @override
  Future<int?> deleteStopById(int id) async {
    return _queryAdapter.query('DELETE FROM stop WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> insertStop(Stop stop) async {
    await _stopInsertionAdapter.insert(stop, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateStop(Stop stop) async {
    await _stopUpdateAdapter.update(stop, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteStop(Stop stop) async {
    await _stopDeletionAdapter.delete(stop);
  }
}

class _$TripStopDao extends TripStopDao {
  _$TripStopDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _tripStopInsertionAdapter = InsertionAdapter(
            database,
            'TripStop',
            (TripStop item) => <String, Object?>{
                  'id': item.id,
                  'trip_id': item.tripId,
                  'stop_id': item.stopId,
                  'position': item.position
                }),
        _tripStopDeletionAdapter = DeletionAdapter(
            database,
            'TripStop',
            ['id'],
            (TripStop item) => <String, Object?>{
                  'id': item.id,
                  'trip_id': item.tripId,
                  'stop_id': item.stopId,
                  'position': item.position
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TripStop> _tripStopInsertionAdapter;

  final DeletionAdapter<TripStop> _tripStopDeletionAdapter;

  @override
  Future<List<TripStop>> getAllTripStops() async {
    return _queryAdapter.queryList('SELECT * FROM TripStop',
        mapper: (Map<String, Object?> row) => TripStop(row['id'] as int?,
            tripId: row['trip_id'] as int,
            stopId: row['stop_id'] as int,
            position: row['position'] as int));
  }

  @override
  Future<List<TripStop>> getTripStopsByTripId(int tripId) async {
    return _queryAdapter.queryList('SELECT * FROM TripStop WHERE trip_id = ?1',
        mapper: (Map<String, Object?> row) => TripStop(row['id'] as int?,
            tripId: row['trip_id'] as int,
            stopId: row['stop_id'] as int,
            position: row['position'] as int),
        arguments: [tripId]);
  }

  @override
  Future<List<TripStop>> getTripStopsByStopId(int stopId) async {
    return _queryAdapter.queryList('SELECT * FROM TripStop WHERE stop_id = ?1',
        mapper: (Map<String, Object?> row) => TripStop(row['id'] as int?,
            tripId: row['trip_id'] as int,
            stopId: row['stop_id'] as int,
            position: row['position'] as int),
        arguments: [stopId]);
  }

  @override
  Future<List<Stop>> getStopsByTripId(int tripId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Stop INNER JOIN TripStop ON Stop.id = TripStop.stop_id WHERE TripStop.trip_id = ?1',
        mapper: (Map<String, Object?> row) => Stop(row['id'] as int?, latitude: row['latitude'] as double, longitude: row['longitude'] as double, name: row['name'] as String, info: row['info'] as String?),
        arguments: [tripId]);
  }

  @override
  Future<int?> deleteTripStopById(int id) async {
    return _queryAdapter.query('DELETE FROM TripStop WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> insertTripStop(TripStop tripStop) async {
    await _tripStopInsertionAdapter.insert(
        tripStop, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteTripStop(TripStop tripStop) async {
    await _tripStopDeletionAdapter.delete(tripStop);
  }
}
