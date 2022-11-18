const String tableTimers = 'timers';

class TimerFields {
  static final List<String> values = [
    /// Add all fields
    id, title, duration
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String duration = 'duration';
}

class Timers {
  final int? id;
  final String title;
  final String duration;

  const Timers({
    this.id,
    required this.title,
    required this.duration,
  });

  Timers copy({
    int? id,
    String? duration,
    String? title,
  }) =>
      Timers(
        id: id ?? this.id,
        duration: duration ?? this.duration,
        title: title ?? this.title,
      );

  static Timers fromJson(Map<String, Object?> json) => Timers(
        id: json[TimerFields.id] as int?,
        duration: json[TimerFields.duration].toString(),
        title: json[TimerFields.title] as String,
      );

  Map<String, Object?> toJson() => {
        TimerFields.id: id,
        TimerFields.title: title,
        TimerFields.duration: duration,
      };
}
