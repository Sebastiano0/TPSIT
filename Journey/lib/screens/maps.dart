import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../database/trip_stop_provider.dart';
import 'package:flutter/material.dart';
import '../database/model.dart';

class PickerDemo extends StatefulWidget {
  final Trip trip;

  PickerDemo(this.trip, {Key? key});

  @override
  State<StatefulWidget> createState() => PickerDemoState();
}

class PickerDemoState extends State<PickerDemo> {
  late GoogleMapController controller;
  // List<Polyline> polylines = [];
  List<LatLng> points = [];
  Set<Marker> markers = {}; //markers for google map
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBxI-We0hHKqKhaV1JZZxYrC6gOX8_qJjA";
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late TripStopProvider tripStopProvider;
  final List<String> transportModes = [
    TravelMode.driving.toString(),
    TravelMode.walking.toString(),
    TravelMode.transit.toString(),
  ];

  final List<Icon> transportIcons = [
    const Icon(Icons.directions_car),
    const Icon(Icons.directions_walk),
    const Icon(Icons.directions_bus),
  ];
  TravelMode selectedTransportMode = TravelMode.driving;

  @override
  void initState() {
    super.initState();
    tripStopProvider = Provider.of<TripStopProvider>(context, listen: false);
    _loadPoints();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadPoints() async {
    List<Stop> stops = await tripStopProvider.getStopsByTripId(widget.trip.id!);
    for (int i = 0; i < stops.length; i++) {
      markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position:
            LatLng(stops.elementAt(i).latitude, stops.elementAt(i).longitude),
        infoWindow: InfoWindow(
            title: stops.elementAt(i).name,
            snippet: "info: ${stops.elementAt(i).info}"),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      if (i != 0) {
        String polylineIdVal = "${stops[i - 1].id}-${stops[i].id}";
        getDirections(
            stops.elementAt(i - 1), stops.elementAt(i), polylineIdVal);
      }
    }
    points =
        stops.map((stop) => LatLng(stop.latitude, stop.longitude)).toList();
  }

  Future<void> _onTransportModeChanged(Icon? mode) async {
    if (mode != null) {
      final int index = transportIcons.indexOf(mode);
      print(index);
      print(transportModes[index]);
      String transport = transportModes[index];
      setState(() {
        selectedTransportMode = TravelMode.values
            .firstWhere((element) => element.toString() == transport);
        _loadPoints();
      });
    }
  }

  getDirections(startLocation, endLocation, polylineIdVal) async {
    List<LatLng> polylineCoordinates = [];

    if (polylines.containsKey(polylineIdVal)) {
      // Polyline già presente, non è necessario crearne una nuova
      return;
    }

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: selectedTransportMode,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      debugPrint(result.errorMessage);
    }
    addPolyLine(polylineCoordinates, polylineIdVal);
  }

  addPolyLine(List<LatLng> polylineCoordinates, polylineIdVal) {
    PolylineId id = PolylineId(polylineIdVal);
    Polyline polyline = Polyline(
      polylineId: id,
      color: const Color.fromARGB(255, 116, 167, 255),
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    if (mounted) {
      setState(() {});
    }
  }

  void _onMapCreated(GoogleMapController c) {
    controller = c;
    if (points.isNotEmpty) {
      c.animateCamera(CameraUpdate.newLatLngZoom(points.first, 12));
    }
  }

  @override
  Widget build(BuildContext context) {
    // tripStopProvider precedente
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.name),
        actions: [
          DropdownButton<Icon>(
            value: transportIcons[
                transportModes.indexOf(selectedTransportMode.toString())],
            onChanged: _onTransportModeChanged,
            dropdownColor: Colors.red,
            items: transportIcons
                .map(
                  (mode) => DropdownMenuItem(
                    value: mode,
                    child: mode,
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _loadPoints(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (points.isNotEmpty) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: points.first,
                zoom: 12,
              ),
              markers: markers,
              mapType: MapType.hybrid,
              onMapCreated: _onMapCreated,
              polylines: Set<Polyline>.of(polylines.values),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
