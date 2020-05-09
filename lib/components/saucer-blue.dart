import 'package:flame/sprite.dart';
import 'package:gametest/components/saucer.dart';
import 'package:gametest/bunker-game.dart';
import 'dart:ui';

class SaucerBlue extends Saucer {
  double get speed => game.tileSize * 1.2;
  double get dropRate => 1;

  SaucerBlue(BunkerGame game, double x, double y) : super(game) {

    saucerRect = Rect.fromLTWH(x,y, game.tileSize, game.tileSize);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('saucer/saucer-blue.png'));
    flyingSprite.add(Sprite('saucer/saucer-blue-2.png'));
    flyingSprite.add(Sprite('saucer/saucer-blue-3.png'));
    deadSprite = Sprite('saucer/saucer-blue-dead.png');
  }
}