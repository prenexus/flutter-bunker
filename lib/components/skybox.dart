import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:gametest/bunker-game.dart';

class Skybox {
  final BunkerGame game;
  Sprite bgSprite;
  Rect bgRect;

  Skybox(this.game) {

    bgSprite = Sprite('sky/sky.png');
    bgRect = Rect.fromLTWH(
      0,
      //game.screenSize.width - (game.tileSize * 5),
      0,
      game.screenSize.width,
      game.screenSize.height,
    );

  }

  void render(Canvas c) {
    bgSprite.renderRect(c,bgRect);
  }

  void update(double t) {}
}