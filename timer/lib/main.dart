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
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
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
  var _currentValueSeconds = 0;
  var _currentValueHours = 0;
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
      onCancel: () => print('Cancelled'),
      onListen: () => print('Listens'),
    );

    int count = (_currentValueHours * 24) +
        (_currentValueMinutes * 60) +
        _currentValueSeconds;

    sub = controller.stream.listen((int data) async {
      setState(() {
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
    }, onError: (error) {}, onDone: () {});

    if (!controller.isClosed) {
      final stream = Stream.periodic(const Duration(seconds: 1), (x) {
        return x;
      }).take(count);

      await controller.addStream(stream);
      // controller.close();
    }

    bytes = await rootBundle.load(path); //load audio from assets
    Uint8List audiobytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    await player.playBytes(audiobytes);

    sub.cancel();
    paused = true;
  }

  pause() {
    sub.pause();
  }

  stop() {
    sub.cancel();
    setState(() {
      _currentValueHours = 0;
      _currentValueMinutes = 0;
      _currentValueSeconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            NumberPicker(
              minValue: 0,
              maxValue: 24,
              value: _currentValueHours,
              onChanged: (value) => setState(() => _currentValueHours = value),
              haptics: true,
              infiniteLoop: true,
            ),
            const Text(":", style: TextStyle(fontSize: 40)),
            NumberPicker(
              minValue: 0,
              maxValue: 59,
              value: _currentValueMinutes,
              onChanged: (value) =>
                  setState(() => _currentValueMinutes = value),
              haptics: true,
              infiniteLoop: true,
            ),
            const Text(":", style: TextStyle(fontSize: 40)),
            NumberPicker(
              minValue: 0,
              maxValue: 59,
              value: _currentValueSeconds,
              onChanged: (value1) =>
                  setState(() => _currentValueSeconds = value1),
              haptics: true,
              infiniteLoop: true,
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                onPressed: paused
                    ? () {
                        setState(() {
                          paused = false;
                        });
                        play();
                      }
                    : null,
                icon:
                    const Icon(Icons.play_arrow, size: 50, color: Colors.blue)),
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
                  color: Colors.blue,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    paused = true;
                  });
                  pause();
                },
                icon: const Icon(Icons.pause, size: 50, color: Colors.blue)),
          ])
        ],
      )),
    );
  }
}
