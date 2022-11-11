import 'dart:async';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';

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
  double progress = 1.0;
  dynamic sub;
  bool paused = true;
  dynamic controller;
  String path = "assets/audio/audio.mp3";
  final AudioPlayer player = AudioPlayer();
  var bytes; //load audio from assets
/*
    - E`richiesta la gestione della subscription degli stream.
    - Lo studente realizzerà un opprotuno StreamController che, come un oscillatore, 
      genererà i tick (eventi di trigger).
    - Lo stream di tick servirà per gestire, possibilmente trasformandolo in un altro stream di numeri, 
      l'avanzamento del conto alla rovescia.
*/

  play() async {
    controller = StreamController<int>(
      onPause: () => print('Paused'),
      onResume: () => print('Resumed'),
      onCancel: () => progress = 1.0,
      onListen: () => print('Listens'),
    );

    int count = (_currentValueHours * 24) +
        (_currentValueMinutes * 60) +
        _currentValueSeconds;

    sub = controller.stream.listen(
        (int data) async {
          setState(() {
            progress = ((progress) -
                    1 /
                        ((_currentValueHours * 24) +
                            (_currentValueMinutes * 60) +
                            _currentValueSeconds))
                .toDouble();
            if (_currentValueSeconds != 0) {
              _currentValueSeconds--;
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
          });
        },
        onError: (error) {},
        onDone: () {
          print("object");
        });

    if (!controller.isClosed) {
      final stream = Stream.periodic(const Duration(seconds: 1), (x) {
        return x;
      }).take(count);

      await controller.addStream(stream);

      if (_currentValueSeconds == 0) {
        bytes = await rootBundle.load(path); //load audio from assets
        Uint8List audiobytes =
            bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
        await player.playBytes(audiobytes);
      }
    }
    sub.cancel();
    paused = true;
  }

  finish() {}

  pause() {
    sub.pause();
  }

  stop() {
    sub.cancel();
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
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: 300,
            height: 300,
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey.shade300,
              value: progress,
              strokeWidth: 6,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            NumberPicker(
              minValue: 0,
              maxValue: 24,
              value: _currentValueHours,
              onChanged: (value) => setState(() => _currentValueHours = value),
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
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // IconButton(
            //     onPressed: paused
            //         ? () {
            //             setState(() {
            //               paused = false;
            //             });
            //           }
            //         : null,
            //     icon: const Icon(Icons.play_arrow,
            //         size: 50, color: Colors.white)),
            IconButton(
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
                )),
            IconButton(
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
                    size: 50, color: Colors.white)),
          ])
        ],
      )),
    );
  }
}
