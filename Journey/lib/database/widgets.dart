import 'package:flutter/material.dart';

import 'model.dart';

class TripItem extends StatelessWidget {
  TripItem({
    required this.trip,
    required this.onTodoChanged,
    required this.onTodoDelete,
  }) : super(key: ObjectKey(trip));

  final Trip trip;
  final Function onTodoChanged;
  final Function onTodoDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(trip);
      },
      onLongPress: (() {
        onTodoDelete(trip);
      }),
      leading: CircleAvatar(child: Text(trip.name[0])),
      title: Text(trip.name + trip.id!.toString()),
    );
  }
}
