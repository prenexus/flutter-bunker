import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:gametest/bunker-game.dart';

class Background {
  final BunkerGame game;
  late Sprite bgSprite;
  late Rect bgRect;

  Background(this.game) {
    bgSprite = Sprite('background/layer-2.png');
    bgRect = Rect.fromLTWH(
      0,
      game.screenSize.height - (game.tileSize * 9),
      game.tileSize * 18,
      game.tileSize * 9,
    );
  }

  void render(Canvas c) {
    bgSprite.renderRect(c,bgRect);
  }

  void update(double t) {}
}