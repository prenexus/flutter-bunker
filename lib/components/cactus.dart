import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:gametest/bunker-game.dart';

class Cactus {
  final BunkerGame game;
  Sprite bgSprite;
  Rect bgRect;

  Cactus(this.game) {
    bgSprite = Sprite('cactus/cactus.png');
    bgRect = Rect.fromLTWH(
      game.screenSize.width - (game.tileSize * 5),
      game.screenSize.height - (game.tileSize * 2.5),
      game.tileSize,
      game.tileSize * 1.3,);
  }

  void render(Canvas c) {
    bgSprite.renderRect(c,bgRect);
  }

  void update(double t) {}
}