import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:gametest/bunker-game.dart';

class ScoreDisplay {
  final BunkerGame game;
  late TextPainter painter;
  late TextStyle textStyle;
  late Offset position;


  ScoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 25,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );

    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
}

  void update(double t) {
    //Getter error - 3/4/21
    //if((painter.text?.text ?? '') != game.score.toString()) {
    if((painter.text ?? '') != game.score.toString()) {
      painter.text = TextSpan(
        text: "Score : " + game.score.toString(),
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (game.screenSize.width / 8) - (painter.width / 2),
        (game.screenSize.height - painter.height*1.25 ),
      );
    }
  }
}