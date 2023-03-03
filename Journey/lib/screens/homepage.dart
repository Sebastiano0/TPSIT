import 'package:provider/provider.dart';

import '../logic/icon_weather.dart';
import '../database/trip_stop_provider.dart';
import 'maps.dart';
import 'package:flutter/material.dart';
import '../database/dao.dart';
import '../database/model.dart';
import 'trip_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Trip> _trips = <Trip>[];
  late TripStopProvider tripStopProvider =
      Provider.of<TripStopProvider>(context, listen: false);
  @override
  void initState() {
    super.initState();
    _updateTrips();
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
    ).then((value) => _updateTrips());
  }

  void _handleTripEdit(Trip trip) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(trip: trip)),
    ).then((value) => _updateTrips());
  }

  void _handleTripDelete(Trip trip) async {
    // cancello tripstops del trip
    final tripStops = await tripStopProvider.getTripStopsByTripId(trip.id!);
    for (final ts in tripStops) {
      await tripStopProvider.deleteTripStop(ts);
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
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: stops.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      FutureBuilder(
                        future: WeatherIcon.getStopWeather(
                            stops[index].latitude, stops[index].longitude),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            String? iconUrl = snapshot.data!
                                .substring(0, snapshot.data!.indexOf(":"));
                            double temp = double.parse(snapshot.data!.substring(
                                    snapshot.data!.indexOf(":") + 1)) -
                                273.15;

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Row(
                                children: [
                                  iconUrl != null
                                      ? Image.network(
                                          "http://openweathermap.org/img/wn/$iconUrl@2x.png",
                                          height: 24)
                                      : Container(),
                                  Text('${temp.toStringAsFixed(1)}°C',
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          "- ${stops[index].name}",
                        ),
                      ),
                    ],
                  );
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_trips[index].name),
                    Text(
                      _trips[index]
                          .lastUpdate!
                          .substring(0, _trips[index].lastUpdate!.indexOf(" ")),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                onTap: () => _handleTripView(_trips[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _handleTripDelete(_trips[index]),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
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
            MaterialPageRoute(builder: (context) => const TripPage()),
          ).then((value) => _updateTrips());
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
