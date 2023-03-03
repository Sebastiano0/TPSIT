import '../database/dao.dart';
import '../database/database.dart';
import '../database/model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TripStopProvider extends ChangeNotifier {
  late TripDao _tripDao;
  late StopDao _stopDao;
  late TripStopDao _tripStopDao;

  TripStopProvider(AppDatabase database) {
    _tripDao = database.tripDao;
    _stopDao = database.stopDao;
    _tripStopDao = database.tripStopDao;
  }

// TripDao
  Future<List<Trip>> getAllTrips() async {
    return _tripDao.getAllTrips();
  }

  Future<Trip?> getTripById(int id) async {
    return _tripDao.getTripById(id);
  }

  Future<int?> getLastTrip() async {
    return _tripDao.getLastTrip();
  }

  Future<void> insertTrip(Trip trip) async {
    _tripDao.insertTrip(trip);
    notifyListeners();
    return;
  }

  Future<void> updateTrip(Trip trip) async {
    _tripDao.updateTrip(trip);
    notifyListeners();
    return;
  }

  Future<void> deleteTrip(Trip trip) async {
    _tripDao.deleteTrip(trip);
    notifyListeners();
    return;
  }

// StopDao
  Future<List<Stop>> getAllStops() async {
    return _stopDao.getAllStops();
  }

  Future<Stop?> getStopById(int id) async {
    return _stopDao.getStopById(id);
  }

  Future<int?> getLastStop() async {
    return _stopDao.getLastStop();
  }

  Future<List<Stop>> getStopsByTripId(int tripId) async {
    return _stopDao.getStopsByTripId(tripId);
  }

  Future<Stop?> getStopByLatLng(double lat, double lng) async {
    return _stopDao.getStopByLatLng(lat, lng);
  }

  Future<Stop?> getStopByName(String n) async {
    return _stopDao.getStopByName(n);
  }

  Future<void> insertStop(Stop stop) async {
    _stopDao.insertStop(stop);
    notifyListeners();
    return;
  }

  Future<void> updateStop(Stop stop) async {
    _stopDao.updateStop(stop);
    notifyListeners();
    return;
  }

  Future<void> deleteStop(Stop stop) async {
    _stopDao.deleteStop(stop);
    notifyListeners();
    return;
  }

  Future<int?> deleteStopById(int id) async {
    int? c = await _stopDao.deleteStopById(id);
    notifyListeners();
    return c;
  }

// TripStopDao
  Future<List<TripStop>> getAllTripStops() async {
    return _tripStopDao.getAllTripStops();
  }

  Future<List<TripStop>> getTripStopsByTripId(int tripId) async {
    return _tripStopDao.getTripStopsByTripId(tripId);
  }

  Future<List<TripStop>> getTripStopsByStopId(int stopId) async {
    return _tripStopDao.getTripStopsByStopId(stopId);
  }

  Future<int?> deleteTripStopById(int id) async {
    var c = _tripStopDao.deleteTripStopById(id);
    notifyListeners();
    return c;
  }

  Future<void> insertTripStop(TripStop tripStop) async {
    _tripStopDao.insertTripStop(tripStop);
    notifyListeners();
    return;
  }

  Future<void> deleteTripStop(TripStop tripStop) async {
    _tripStopDao.deleteTripStop(tripStop);
    notifyListeners();
    return;
  }
}
