import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';

import '../database/trip_stop_provider.dart';
import '../database/model.dart';

class TripPage extends StatefulWidget {
  final Trip? trip;

  const TripPage({
    Key? key,
    this.trip,
  });

  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final List<Stop> _stopsId = [];
  late TripStopProvider tripStopProvider =
      Provider.of<TripStopProvider>(context, listen: false);

  bool _tripNameEntered = false;
  final _tripNameController = TextEditingController();

  @override
  void dispose() {
    _tripNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      _tripNameEntered = true;
      _tripNameController.text = widget.trip!.name;
      tripStopProvider.getStopsByTripId(widget.trip!.id!).then((stops) {
        setState(() {
          _stopsId.addAll(stops);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip != null ? 'Edit trip' : 'New trip'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed:
                _stopsId.length > 1 && _tripNameEntered ? _saveTrip : null,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: _tripNameController,
              decoration: const InputDecoration(
                labelText: 'Trip',
              ),
              onChanged: (value) {
                setState(() {
                  _tripNameEntered = value.isNotEmpty;
                });
              },
            ),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Stop stop = _stopsId.removeAt(oldIndex);
                  _stopsId.insert(newIndex, stop);
                });
              },
              children: _stopsId
                  .asMap()
                  .entries
                  .map((entry) => buildStopTile(entry.key, entry.value))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tripNameEntered
            ? () {
                showPlacePicker();
              }
            : null,
        backgroundColor: _tripNameEntered ? null : Colors.grey,
        child: const SizedBox(
          width: 40.0,
          height: 40.0,
          child: Center(
            child: Text(
              "Add stop",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStopTile(int index, Stop stop) {
    return Dismissible(
      key: Key('$stop$index'),
      onDismissed: (direction) {
        setState(() {
          _stopsId.removeAt(index);
        });
      },
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController _textEditingController =
                    TextEditingController(text: _stopsId[index].info);
                int tempIndex = index;

                return AlertDialog(
                  title: const Text('Info'),
                  content: TextField(
                    controller: _textEditingController,

                    // onChanged: (value) {
                    //   textFieldValue = value;
                    // },
                  ),
                  actions: [
                    TextButton(
                      child: Text("OK"),
                      onPressed: () async {
                        setState(() {
                          _stopsId[tempIndex].info =
                              _textEditingController.text;
                        });
                        await tripStopProvider.updateStop(_stopsId[index]);
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Annulla"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: Text(stop.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _stopsId.removeAt(index);
                });
              },
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.menu),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTrip() async {
    if (_tripNameController.text.isNotEmpty && _stopsId.length > 1) {
      var currentTrip = widget.trip;
      if (currentTrip == null) {
        final trip = Trip(
          null,
          name: _tripNameController.text,
          lastUpdate: DateTime.now().toString(),
        );
        await tripStopProvider.insertTrip(trip);
        int? tripId = await tripStopProvider.getLastTrip();
        for (var i = 0; i < _stopsId.length; i++) {
          final stop = _stopsId[i];
          final stopId = await tripStopProvider.insertStop(stop);
          final tripStop = TripStop(
            null,
            tripId: tripId!,
            stopId: stop.id!,
            position: i,
          );
          await tripStopProvider.insertTripStop(tripStop);
        }
      } else {
        currentTrip.name = _tripNameController.text;
        currentTrip.lastUpdate = DateTime.now().toString();
        await tripStopProvider.updateTrip(currentTrip);

        final tripStops =
            await tripStopProvider.getTripStopsByTripId(currentTrip.id!);
        final stopIds = _stopsId.map((stop) => stop.id).toSet();
        final tripStopIds = tripStops.map((tripStop) => tripStop.id).toSet();
        final stopsToAdd = stopIds
            .difference(tripStops.map((tripStop) => tripStop.stopId).toSet());
        final stopsToRemove = tripStopIds.difference(stopIds
            .map((id) {
              final tripStop =
                  tripStops.where((tripStop) => tripStop.stopId == id);

              return tripStop.isNotEmpty ? tripStop.first.id : null;
            })
            .where((id) => id != null)
            .toSet());
        for (var i = 0; i < _stopsId.length; i++) {
          final stop = _stopsId[i];
          final stopId = await tripStopProvider.insertStop(stop);
          final tripStop = TripStop(
            null,
            tripId: currentTrip.id!,
            stopId: stop.id!,
            position: i,
          );
          await tripStopProvider.insertTripStop(tripStop);
        }
        for (var tripStopId in stopsToRemove) {
          await tripStopProvider.deleteTripStopById(tripStopId!);
        }
      }
      Navigator.pop(context);
    }
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyBxI-We0hHKqKhaV1JZZxYrC6gOX8_qJjA")));

    var existingStop = await tripStopProvider.getStopByName(result.name!);

    if (existingStop == null) {
      var newStop = Stop(
        null,
        latitude: result.latLng!.latitude,
        longitude: result.latLng!.longitude,
        name: result.name!,
        info: null,
      );
      await tripStopProvider.insertStop(newStop);
      newStop.id = await tripStopProvider.getLastStop();
      setState(() {
        _stopsId.add(newStop);
        _stopsId.sort((a, b) => _stopsId.indexOf(a) - _stopsId.indexOf(b));
      });
    } else {
      setState(() {
        _stopsId.add(existingStop);
        _stopsId.sort((a, b) => _stopsId.indexOf(a) - _stopsId.indexOf(b));
      });
    }
  }
}
