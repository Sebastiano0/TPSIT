import 'package:flutter/material.dart';
import 'gameColors.dart';

class Board extends StatefulWidget {
  var color;

  Board(this.color, {super.key});

  @override
  _BoardState createState() => _BoardState(color);
}

class _BoardState extends State<Board> {
  GameColors color;
  _BoardState(this.color);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        generateRow(context, color.logic.checkboxValues),
      ],
    );
  }

  void updateState() {
    setState(() {});
  }

  generateRow(context, checkboxValues) {
    List<Widget> row =
        List.generate(10, (index) => singleRow(index, checkboxValues, context));

    return ListView(
        padding: EdgeInsets.zero,
        reverse: true,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: row);
  }

  singleRow(int i, checkboxValues, context) {
    return AbsorbPointer(
      absorbing: !color.logic.enterVisibility[i],
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60.67,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.logic.borderContainerColor[i]),
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
                value: checkboxValues[(i * 4)] ??= false,
                onChanged: (newValue) async {
                  setState(() => checkboxValues[(i * 4)] = true);
                  color.setColorSequence(i, 0);
                },
                activeColor: color.getColorSequence(i, 0),
                checkColor: color.getColorSequence(i, 0),
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
                value: checkboxValues[(i * 4) + 1] ??= false,
                onChanged: (newValue) async {
                  setState(() => checkboxValues[(i * 4) + 1] = true);
                  color.setColorSequence(i, 1);
                },
                activeColor: color.getColorSequence(i, 1),
                checkColor: color.getColorSequence(i, 1),
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
                value: checkboxValues[(i * 4) + 2] ??= false,
                onChanged: (newValue) async {
                  setState(() => checkboxValues[(i * 4) + 2] = true);
                  color.setColorSequence(i, 2);
                },
                activeColor: color.getColorSequence(i, 2),
                checkColor: color.getColorSequence(i, 2),
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
                value: checkboxValues[(i * 4) + 3] ??= false,
                onChanged: (newValue) async {
                  setState(() => checkboxValues[(i * 4) + 3] = true);
                  color.setColorSequence(i, 3);
                },
                activeColor: color.getColorSequence(i, 3),
                checkColor: color.getColorSequence(i, 3),
              ),
            ),
            Visibility(
                visible: color.logic.enterVisibility[i],
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white)),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        int? response = color.checkSequence(context);
                        if (response != -1) {
                          setState(() {});
                          color.logic.enterVisibility[i] = false;
                          color.logic.resultVisibility[i] = true;
                          color.logic.enterVisibility[i + 1] = true;
                          color.logic.borderContainerColor[i] =
                              Colors.transparent;
                          color.logic.borderContainerColor[i + 1] =
                              Colors.green;
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
                visible: color.logic.resultVisibility[i],
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
                            color: color.guessedSequence[i][0], size: 24),
                        Icon(Icons.circle,
                            color: color.guessedSequence[i][1], size: 24),
                        Icon(Icons.circle,
                            color: color.guessedSequence[i][2], size: 24),
                        Icon(Icons.circle,
                            color: color.guessedSequence[i][3], size: 24),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
