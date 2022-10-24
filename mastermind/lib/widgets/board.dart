import 'package:flutter/material.dart';
import 'gameColors.dart';
import 'package:flutter/cupertino.dart';

class Board extends StatefulWidget {
  var color;

  Board(this.color, {super.key});

  @override
  _BoardState createState() => _BoardState(color);
}

class _BoardState extends State<Board> {
  GameColors color;
  _BoardState(this.color);

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
  Color borderContainerColor = Colors.green;
  bool enterVisibility = true;
  bool resultVisibility = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        chance(context),
        // chance(),
        // chance(),
        // chance(),
        // chance(),
        // chance(),
        // chance(),
        // chance(),
        // chance(),
        // chance(),
      ],
    );
  }

  chance(context) {
    return ListView(
        padding: EdgeInsets.zero,
        reverse: true,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          AbsorbPointer(
            absorbing: !enterVisibility,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60.67,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderContainerColor),
                color: Colors.transparent,
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
                        setState(() => checkboxValue1 = true);
                        color.setColorSequence(0);
                      },
                      activeColor: color.getColorSequence(0),
                      checkColor: color.getColorSequence(0),
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
                        setState(() => checkboxValue2 = true);
                        color.setColorSequence(1);
                      },
                      activeColor: color.getColorSequence(1),
                      checkColor: color.getColorSequence(1),
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
                        setState(() => checkboxValue3 = true);
                        color.setColorSequence(2);
                      },
                      activeColor: color.getColorSequence(2),
                      checkColor: color.getColorSequence(2),
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
                        setState(() => checkboxValue4 = true);
                        color.setColorSequence(3);
                      },
                      activeColor: color.getColorSequence(3),
                      checkColor: color.getColorSequence(3),
                    ),
                  ),
                  Visibility(
                      visible: enterVisibility,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white)),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              int? response = color.checkSequence(context);
                              if (response != -1) {
                                setState(() {});
                                enterVisibility = false;
                                resultVisibility = true;
                                borderContainerColor = Colors.transparent;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0x00101213)),
                            icon: const Icon(
                              Icons.check_circle,
                              size: 15,
                            ),
                            label: const Text("Enter"),
                          ))),
                  Visibility(
                      visible: resultVisibility,
                      child: SizedBox(
                          width: 100,
                          height: 100,
                          child: GridView(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2,
                            ),
                            shrinkWrap: false,
                            scrollDirection: Axis.vertical,
                            children: [
                              Icon(Icons.circle,
                                  color: color.guessedSequence[0], size: 24),
                              Icon(Icons.circle,
                                  color: color.guessedSequence[1], size: 24),
                              Icon(Icons.circle,
                                  color: color.guessedSequence[2], size: 24),
                              Icon(Icons.circle,
                                  color: color.guessedSequence[3], size: 24),
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ]);
  }
}
