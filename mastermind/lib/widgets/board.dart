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

  generateRow(context, checkboxValues) {
    List<Widget> row = List.generate(
        color.rows, (index) => singleRow(index, checkboxValues, context));

    return ListView(
        controller: ScrollController(initialScrollOffset: (606.7)),
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
                unselectedWidgetColor: color.secondaryColor,
              ),
              child: Transform.scale(
                scale: 2,
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
            ),
            Theme(
              data: ThemeData(
                checkboxTheme: const CheckboxThemeData(
                  shape: CircleBorder(),
                ),
                unselectedWidgetColor: color.secondaryColor,
              ),
              child: Transform.scale(
                scale: 2,
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
            ),
            Theme(
              data: ThemeData(
                checkboxTheme: const CheckboxThemeData(
                  shape: CircleBorder(),
                ),
                unselectedWidgetColor: color.secondaryColor,
              ),
              child: Transform.scale(
                scale: 2,
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
            ),
            Theme(
              data: ThemeData(
                checkboxTheme: const CheckboxThemeData(
                  shape: CircleBorder(),
                ),
                unselectedWidgetColor: color.secondaryColor,
              ),
              child: Transform.scale(
                scale: 2,
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
            ),
            Visibility(
                visible: color.logic.enterVisibility[i],
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: color.secondaryColor)),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        int? response = color.checkSequence(context);
                        if (response == 1) {
                          color.logic.enterVisibility[i] = false;
                          color.logic.resultVisibility[i] = true;
                        }
                        if (response != -1 && response != 1) {
                          color.logic.enterVisibility[i] = false;
                          color.logic.resultVisibility[i] = true;

                          color.logic.borderContainerColor[i] =
                              color.secondaryColor;
                          if (i != color.rows - 1) {
                            color.logic.enterVisibility[i + 1] = true;
                            color.logic.borderContainerColor[i + 1] =
                                Colors.green;
                          }
                        }
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      icon: Icon(
                        Icons.check_circle,
                        color: color.secondaryColor,
                        size: 15,
                      ),
                      label: Text(
                        ('Enter'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color.secondaryColor,
                        ),
                      ),
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
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        childAspectRatio: 2,
                      ),
                      shrinkWrap: false,
                      scrollDirection: Axis.vertical,
                      children: [
                        Icon(Icons.circle,
                            color: color.logic.guessedSequence[i][0], size: 24),
                        Icon(Icons.circle,
                            color: color.logic.guessedSequence[i][1], size: 24),
                        Icon(Icons.circle,
                            color: color.logic.guessedSequence[i][2], size: 24),
                        Icon(Icons.circle,
                            color: color.logic.guessedSequence[i][3], size: 24),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
