import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:timer/pages/edit_timer_page.dart';
import '../db/timer_database.dart';
import '../model/timers.dart';
import '../widget/noti.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MainPageState extends State<MainPage> {
  late List<Timers> timers;
  bool isLoading = false;
  var _currentValueMinutes = 0;
  var _currentValueSeconds = 0;
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

  @override
  void initState() {
    super.initState();
    refreshTimers();
  }

  @override
  void dispose() {
    TimerDatabase.instance.close();

    super.dispose();
  }

  Future refreshTimers() async {
    setState(() => isLoading = true);

    timers = await TimerDatabase.instance.readAllTimers();
    //await TimerDatabase.instance.deleteAll();
    setState(() => isLoading = false);
    return;
  }

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
      count = (_currentValueHours * 3600) +
          (_currentValueMinutes * 60) +
          _currentValueSeconds;

      fractionProgress = 1 / count / 10;
      hasBeenPaused = false;
    } else {
      count = (_currentValueHours * 3600) +
          (_currentValueMinutes * 60) +
          _currentValueSeconds;
    }
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
    initialCount = 0;
    sub.cancel();
    paused = true;
    numberPickerVisibility = true;
    Noti.initialize(flutterLocalNotificationsPlugin);

    if (!stopped && count != 0) {
      Noti.showBigTextNotification(
          title: "Timer terminato",
          body: "Il tuo timer è terminato",
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
      _currentValueSeconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30)),
                    )
                  ]),
                )),
            Visibility(
                visible: numberPickerVisibility,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  NumberPicker(
                    zeroPad: true, //2 cifre
                    minValue: 0,
                    maxValue: 23,
                    value: _currentValueHours,
                    onChanged: (value) =>
                        setState(() => _currentValueHours = value),
                    haptics: true,
                    infiniteLoop: true,
                    textStyle:
                        const TextStyle(fontSize: 15, color: Colors.white),
                    selectedTextStyle:
                        const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  const Text(
                    ":",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  NumberPicker(
                    zeroPad: true,
                    minValue: 0,
                    maxValue: 59,
                    value: _currentValueMinutes,
                    onChanged: (value) =>
                        setState(() => _currentValueMinutes = value),
                    haptics: true,
                    infiniteLoop: true,
                    textStyle:
                        const TextStyle(fontSize: 15, color: Colors.white),
                    selectedTextStyle:
                        const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  const Text(
                    ":",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  NumberPicker(
                    zeroPad: true,
                    minValue: 0,
                    maxValue: 59,
                    value: _currentValueSeconds,
                    onChanged: (value1) => setState(() {
                      _currentValueSeconds = value1;
                    }),
                    haptics: true,
                    infiniteLoop: true,
                    textStyle:
                        const TextStyle(fontSize: 15, color: Colors.white),
                    selectedTextStyle:
                        const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ])),
            Visibility(
              visible: numberPickerVisibility,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          child:
                              const Text("Inserisci un nuovo timer permanente"),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddEditTimerPage()),
                            );
                            refreshTimers();
                          }),
                    ],
                  ),
                  SizedBox(
                    width: 350,
                    height: 200,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : ListView.builder(
                            reverse: true,
                            itemCount: timers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          TimerDatabase.instance
                                              .delete(timers[index].id);
                                          setState(() {
                                            refreshTimers();
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )),
                                    Container(
                                      width: 300,
                                      constraints:
                                          const BoxConstraints(maxWidth: 300),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey.shade800,
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                            )),
                                        onPressed: () {
                                          numberPickerVisibility = false;
                                          _currentValueHours = int.parse(
                                              showTime(index).substring(0, 2));
                                          _currentValueMinutes = int.parse(
                                              showTime(index).substring(3, 5));
                                          _currentValueSeconds = int.parse(
                                              showTime(index).substring(6, 8));
                                          paused = false;
                                          play();
                                        },
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(timers[index].title),
                                              Text(showTime(index))
                                            ]),
                                      ),
                                    )
                                  ]);
                            },
                          ),
                  )
                ],
              ),
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
                      icon: Icon(
                          paused == false ? Icons.pause : Icons.play_arrow,
                          size: 50,
                          color: Colors.white))),
            ])
          ],
        )),
      );

  String showTime(index) {
    switch (timers[index].duration.length) {
      case 1:
        {
          return "00:00:0${timers[index].duration}";
        }
      case 2:
        {
          return "00:00:${timers[index].duration}";
        }
      case 3:
        {
          return "00:0${timers[index].duration[0]}:${timers[index].duration.substring(1)}";
        }
      case 4:
        {
          return "00:${timers[index].duration.substring(0, 2)}:${timers[index].duration.substring(2, 4)}";
        }
      case 5:
        {
          return "0${timers[index].duration[0]}:${timers[index].duration.substring(1, 3)}:${timers[index].duration.substring(3, 5)}";
        }
      default:
        {
          return "${timers[index].duration.substring(0, 2)}:${timers[index].duration.substring(2, 4)}:${timers[index].duration.substring(4, 6)}";
        }
    }
  }
}
