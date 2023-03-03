import 'package:floor/floor.dart';

import 'model.dart';

@dao
abstract class TripDao {
  @Query('SELECT * FROM Trip')
  Future<List<Trip>> getAllTrips();

  @Query('SELECT * FROM Trip WHERE id = :id')
  Future<Trip?> getTripById(int id);

  @Query('SELECT id FROM trip ORDER BY id DESC LIMIT 1')
  Future<int?> getLastTrip();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTrip(Trip trip);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateTrip(Trip trip);

  @delete
  Future<void> deleteTrip(Trip trip);
}

@dao
abstract class StopDao {
  @Query('SELECT * FROM Stop')
  Future<List<Stop>> getAllStops();

  @Query('SELECT * FROM Stop WHERE id = :id')
  Future<Stop?> getStopById(int id);

  @Query('SELECT id FROM stop ORDER BY id DESC LIMIT 1')
  Future<int?> getLastStop();

  @Query(
      'SELECT * FROM Stop INNER JOIN TripStop ON Stop.id = TripStop.stop_id WHERE TripStop.trip_id = :tripId')
  Future<List<Stop>> getStopsByTripId(int tripId);

  @Query('SELECT * FROM Stop WHERE latitude = :lat AND longitude = :lng')
  Future<Stop?> getStopByLatLng(double lat, double lng);

  @Query('SELECT * FROM Stop WHERE name = :n')
  Future<Stop?> getStopByName(String n);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertStop(Stop stop);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateStop(Stop stop);

  @delete
  Future<void> deleteStop(Stop stop);

  @Query('DELETE FROM stop WHERE id = :id')
  Future<int?> deleteStopById(int id);
}

@dao
abstract class TripStopDao {
  @Query('SELECT * FROM TripStop')
  Future<List<TripStop>> getAllTripStops();

  @Query('SELECT * FROM TripStop WHERE trip_id = :tripId')
  Future<List<TripStop>> getTripStopsByTripId(int tripId);

  @Query('SELECT * FROM TripStop WHERE stop_id = :stopId')
  Future<List<TripStop>> getTripStopsByStopId(int stopId);

  @Query(
      'SELECT * FROM Stop INNER JOIN TripStop ON Stop.id = TripStop.stop_id WHERE TripStop.trip_id = :tripId')
  Future<List<Stop>> getStopsByTripId(int tripId);

  @Query('DELETE FROM TripStop WHERE id = :id')
  Future<int?> deleteTripStopById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTripStop(TripStop tripStop);

  @delete
  Future<void> deleteTripStop(TripStop tripStop);
}
