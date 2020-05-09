import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:gametest/bunker-game.dart';

class Bunker {
  final BunkerGame game;
  Sprite bgSprite;
  Rect bgRect;

  Bunker(this.game) {
    bgSprite = Sprite('bunker/bunker.png');
    bgRect = Rect.fromLTWH(
      0,
      game.screenSize.height - (game.tileSize * 6),
      game.tileSize * 9,
      game.tileSize * 5,
    );
  }

  void render(Canvas c) {
    bgSprite.renderRect(c,bgRect);
  }

  void update(double t) {}
}