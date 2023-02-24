import 'package:floor/floor.dart';

@entity
class Trip {
  Trip(this.id, {required this.name, this.lastUpdate});

  @PrimaryKey(autoGenerate: true)
  final int? id;

  String name;
  String? lastUpdate;

  Trip copyWith({int? id, String? name, String? lastUpdate}) {
    return Trip(
      id ?? this.id,
      name: name ?? this.name,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

@entity
class Stop {
  Stop(this.id,
      {required this.latitude,
      required this.longitude,
      required this.name,
      required this.info});

  @PrimaryKey(autoGenerate: true)
  int? id;

  final double latitude;
  final double longitude;
  final String name;
  String? info;
}

@Entity(
  tableName: 'TripStop',
  foreignKeys: [
    ForeignKey(
      childColumns: ['trip_id'],
      parentColumns: ['id'],
      entity: Trip,
    ),
    ForeignKey(
      childColumns: ['stop_id'],
      parentColumns: ['id'],
      entity: Stop,
    )
  ],
)
class TripStop {
  TripStop(this.id, {required this.tripId, required this.stopId});

  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'trip_id')
  final int tripId;

  @ColumnInfo(name: 'stop_id')
  final int stopId;
}
