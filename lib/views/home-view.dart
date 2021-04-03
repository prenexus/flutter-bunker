import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:gametest/bunker-game.dart';

class HomeView {
  final BunkerGame game;
  late Rect titleRect;
  late Sprite titleSprite;

  HomeView(this.game){
    titleRect = Rect.fromLTWH(
      game.tileSize,
      (game.screenSize.height / 2) - (game.tileSize * 4),
      game.tileSize * 7,
      game.tileSize * 4,
    );
    titleSprite = Sprite('title.png');
  }

  void render(Canvas c) {}

  void update(double t) {}
}