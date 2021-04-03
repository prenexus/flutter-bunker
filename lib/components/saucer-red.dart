import 'package:flame/sprite.dart';
import 'package:gametest/components/saucer.dart';
import 'package:gametest/bunker-game.dart';
import 'dart:ui';

class SaucerRed extends Saucer {

  //Slightly slower
  double get speed => game.tileSize * 1.0;

  SaucerRed(BunkerGame game, double x, double y) : super(game) {

    saucerRect = Rect.fromLTWH(x,y, game.tileSize, game.tileSize);
   // flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('saucer/saucer-red.png'));
    flyingSprite.add(Sprite('saucer/saucer-red.png'));
    flyingSprite.add(Sprite('saucer/saucer-red.png'));
    deadSprite = Sprite('saucer/saucer-red-dead.png');

  }
}