import 'package:provider/provider.dart';

import '../trip_stop_provider.dart';
import 'maps.dart';
import 'package:flutter/material.dart';
import '../database/dao.dart';
import '../database/model.dart';
import '../database/widgets.dart';
import 'trip_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Trip> _trips = <Trip>[];
  late TripStopProvider tripStopProvider;
  @override
  void initState() {
    super.initState();
  }

  _updateTrips() async {
    final trips = await tripStopProvider.getAllTrips();
    setState(() {
      _trips.clear();
      _trips.addAll(trips);
    });
  }

  void _handleTripView(Trip trip) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PickerDemo(trip)),
    );
  }

  void _handleTripEdit(Trip trip) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(trip: trip)),
    );
  }

  void _handleTripDelete(Trip trip) async {
    // cancello tripstops del trip
    final tripStops = await tripStopProvider.getTripStopsByTripId(trip.id!);
    for (final ts in tripStops) {
      await tripStopProvider.deleteTripStop(ts);
      await tripStopProvider.deleteStopById(ts.stopId);
    }
    // cancello trip
    await tripStopProvider.deleteTrip(trip);
    setState(() {
      _trips.remove(trip);
    });
  }

  Widget _buildStopList(int tripId) {
    return FutureBuilder(
      future: tripStopProvider.getStopsByTripId(tripId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Stop> stops = snapshot.data as List<Stop>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: stops.length,
                itemBuilder: (context, index) {
                  return Text("- ${stops[index].name}");
                },
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    tripStopProvider = Provider.of<TripStopProvider>(context, listen: false);
    _updateTrips();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Journey"),
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _trips.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(_trips[index].name),
                onTap: () => _handleTripView(_trips[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _handleTripDelete(_trips[index]),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _handleTripEdit(_trips[index]),
                    ),
                  ],
                ),
                subtitle: _buildStopList(_trips[index].id!),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TripPage()),
          );
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}
