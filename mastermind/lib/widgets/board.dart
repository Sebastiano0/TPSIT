import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  
  bool? checkboxValue10;
  bool? checkboxValue9;
  bool? checkboxValue11;
  bool? checkboxValue12;
  bool? checkboxValue1;
  bool? checkboxValue2;
  bool? checkboxValue3;
  bool? checkboxValue4;
  bool? checkboxValue5;
  bool? checkboxValue6;
  bool? checkboxValue7;
  bool? checkboxValue8;
  bool? checkboxValue13;
  bool? checkboxValue14;
  bool? checkboxValue15;
  bool? checkboxValue16;
  bool? checkboxValue17;
  bool? checkboxValue18;
  bool? checkboxValue19;
  bool? checkboxValue20;
  bool? checkboxValue21;
  bool? checkboxValue22;
  bool? checkboxValue23;
  bool? checkboxValue24;
  bool? checkboxValue25;
  bool? checkboxValue26;
  bool? checkboxValue27;
  bool? checkboxValue28;
  bool? checkboxValue29;
  bool? checkboxValue30;
  bool? checkboxValue31;
  bool? checkboxValue32;
  bool? checkboxValue33;
  bool? checkboxValue34;
  bool? checkboxValue35;
  bool? checkboxValue36;
  bool? checkboxValue37;
  bool? checkboxValue38;
  bool? checkboxValue39;
  bool? checkboxValue40;
  int checkboxIndex = 0;
  @override
  void initState() {
    super.initState();
    //_appState = ScopedModel.of<AppState>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        chance(),
        chance(),
        chance(),
        chance(),
        chance(),
        chance(),
        chance(),
        chance(),
        chance(),
        chance(),
      ],
    );
  }

  chance() {
    return ListView(
        padding: EdgeInsets.zero,
        reverse: true,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60.67,
            decoration: const BoxDecoration(
              color: Colors.black26,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Theme(
                  data: ThemeData(
                    checkboxTheme: const CheckboxThemeData(
                      shape: CircleBorder(),
                    ),
                    unselectedWidgetColor: const Color(0xFFF5F5F5),
                  ),
                  child: Checkbox(
                    value: checkboxValue1 ??= false,
                    onChanged: (newValue) async {
                      setState(() => checkboxValue1 = newValue!);
                    },
                    activeColor: Colors.white,
                    checkColor: Colors.white,
                  ),
                ),
                Theme(
                  data: ThemeData(
                    checkboxTheme: const CheckboxThemeData(
                      shape: CircleBorder(),
                    ),
                    unselectedWidgetColor: const Color(0xFFF5F5F5),
                  ),
                  child: Checkbox(
                    value: checkboxValue2 ??= false,
                    onChanged: (newValue) async {
                      setState(() => checkboxValue2 = newValue!);
                    },
                    activeColor: Colors.white,
                    checkColor: Colors.white,
                  ),
                ),
                Theme(
                  data: ThemeData(
                    checkboxTheme: const CheckboxThemeData(
                      shape: CircleBorder(),
                    ),
                    unselectedWidgetColor: const Color(0xFFF5F5F5),
                  ),
                  child: Checkbox(
                    value: checkboxValue3 ??= false,
                    onChanged: (newValue) async {
                      setState(() => checkboxValue3 = newValue!);
                    },
                    activeColor: Colors.white,
                    checkColor: Colors.white,
                  ),
                ),
                Theme(
                  data: ThemeData(
                    checkboxTheme: const CheckboxThemeData(
                      shape: CircleBorder(),
                    ),
                    unselectedWidgetColor: const Color(0xFFF5F5F5),
                  ),
                  child: Checkbox(
                    value: checkboxValue4 ??= false,
                    onChanged: (newValue) async {
                      setState(() => checkboxValue4 = newValue!);
                    },
                    activeColor: Colors.white,
                    checkColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x101213)),
                  icon: const Icon(
                    Icons.check_circle,
                    size: 15,
                  ),
                  label: const Text("Enter"),
                ),
              ],
            ),
          ),
        ]);
  }
}
