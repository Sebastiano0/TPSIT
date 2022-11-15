import 'dart:async';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'noti.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer',
      theme: ThemeData(primaryColor: Colors.black),
      home: const MyHomePage(title: 'Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentValueMinutes = 0;
  var _currentValueSeconds = 1;
  var _currentValueHours = 0;

  String remainingTime = "";
  int initialCount = 0;
  double progress = 1.0;
  dynamic sub;
  bool paused = true;
  dynamic controller;
  bool numberPickerVisibility = true;
  bool stopped = false;
  var fractionProgress;
  bool hasBeenPaused = false;
  int count = 0;

  String path = "assets/audio/audio.mp3";
  final AudioPlayer player = AudioPlayer();
  var bytes; //load audio from assets

  createStringRemainingTime() {
    remainingTime = "";
    if (_currentValueHours < 10) {
      remainingTime += "0$_currentValueHours:";
    } else {
      remainingTime += "$_currentValueHours:";
    }
    if (_currentValueMinutes < 10) {
      remainingTime += "0$_currentValueMinutes:";
    } else {
      remainingTime += "$_currentValueMinutes:";
    }
    if (_currentValueSeconds < 10) {
      remainingTime += "0$_currentValueSeconds";
    } else {
      remainingTime += "$_currentValueSeconds";
    }
  }

  play() async {
    numberPickerVisibility = false;
    controller = StreamController<int>(
      onPause: () => hasBeenPaused = true,
      onResume: () => print('Resumed'),
      onCancel: () => {hasBeenPaused = false, progress = 1.0},
      onListen: () => print('Listens'),
    );

    if (!hasBeenPaused) {
      count = (_currentValueHours * 24) +
          (_currentValueMinutes * 60) +
          _currentValueSeconds;
      fractionProgress = 1 / count / 10;
      hasBeenPaused = false;
    } else {
      count = (_currentValueHours * 24) +
          (_currentValueMinutes * 60) +
          _currentValueSeconds;
    }
    print("object $fractionProgress");
    print("1 $count");
    sub = controller.stream.listen((int data) async {
      setState(() {
        progress = progress - fractionProgress;
        createStringRemainingTime();
        if (data % 10 == 0) {
          if (_currentValueSeconds != 0) {
            if (data != 0) {
              _currentValueSeconds--;
            }
          } else {
            _currentValueSeconds = 59;
            if (_currentValueMinutes != 0) {
              _currentValueMinutes--;
            } else {
              if (_currentValueHours != 0) {
                _currentValueMinutes = 59;
                _currentValueHours--;
              }
            }
          }
        }
      });
    }, onError: (error) {}, onDone: () {});

    if (!controller.isClosed) {
      final stream = Stream.periodic(const Duration(milliseconds: 100), (x) {
        return x;
      }).take(count * 10);

      await controller.addStream(stream);
    }
    // _currentValueSeconds--;
    initialCount = 0;
    sub.cancel();
    paused = true;
    numberPickerVisibility = true;
    Noti.initialize(flutterLocalNotificationsPlugin);

    if (!stopped && count != 0) {
      Noti.showBigTextNotification(
          title: "Times over",
          body: "Your timer is ended",
          fln: flutterLocalNotificationsPlugin);

      bytes = await rootBundle.load(path); //load audio from assets
      Uint8List audiobytes =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      await player.playBytes(audiobytes);
    } else {
      stopped = false;
    }
  }

  pause() {
    sub.pause();
    paused = true;
  }

  stop() {
    stopped = true;
    numberPickerVisibility = true;
    sub.cancel();
    initialCount = 0;
    setState(() {
      _currentValueHours = 0;
      _currentValueMinutes = 0;
      _currentValueSeconds = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Visibility(
              visible: !numberPickerVisibility,
              child: SizedBox(
                width: 300,
                height: 300,
                child: Stack(children: <Widget>[
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey.shade900,
                        value: progress,
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(remainingTime,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 30)),
                  )
                ]),
              )),
          Visibility(
              visible: numberPickerVisibility,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                NumberPicker(
                  minValue: 0,
                  maxValue: 23,
                  value: _currentValueHours,
                  onChanged: (value) =>
                      setState(() => _currentValueHours = value),
                  haptics: true,
                  infiniteLoop: true,
                  textStyle: const TextStyle(fontSize: 15, color: Colors.white),
                  selectedTextStyle:
                      const TextStyle(fontSize: 30, color: Colors.white),
                ),
                const Text(
                  ":",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: _currentValueMinutes,
                  onChanged: (value) =>
                      setState(() => _currentValueMinutes = value),
                  haptics: true,
                  infiniteLoop: true,
                  textStyle: const TextStyle(fontSize: 15, color: Colors.white),
                  selectedTextStyle:
                      const TextStyle(fontSize: 30, color: Colors.white),
                ),
                const Text(
                  ":",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: _currentValueSeconds,
                  onChanged: (value1) => setState(() {
                    _currentValueSeconds = value1;
                  }),
                  haptics: true,
                  infiniteLoop: true,
                  textStyle: const TextStyle(fontSize: 15, color: Colors.white),
                  selectedTextStyle:
                      const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                  visible: numberPickerVisibility,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        textStyle: const TextStyle(
                          color: Colors.white,
                        )),
                    onPressed: () {
                      numberPickerVisibility = false;
                      _currentValueHours = 0;
                      _currentValueMinutes = 2;
                      _currentValueSeconds = 0;
                      paused = false;
                      play();
                    },
                    child: const Text(
                        "Lava i denti:                                                           2 min"),
                  ))
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Visibility(
                visible: !numberPickerVisibility,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        paused = true;
                      });
                      stop();
                    },
                    icon: const Icon(
                      Icons.stop,
                      size: 50,
                      color: Colors.white,
                    ))),
            Visibility(
                visible: numberPickerVisibility,
                child: IconButton(
                    onPressed: paused
                        ? () {
                            setState(() {
                              paused = false;
                              play();
                            });
                          }
                        : null,
                    icon: const Icon(Icons.play_arrow,
                        size: 50, color: Colors.white))),
            Visibility(
                visible: !numberPickerVisibility,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (paused) {
                          paused = false;
                          play();
                        } else {
                          paused = true;
                          pause();
                        }
                      });
                    },
                    icon: Icon(paused == false ? Icons.pause : Icons.play_arrow,
                        size: 50, color: Colors.white))),
          ])
        ],
      )),
    );
  }
}
