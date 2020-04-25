import 'package:flame/sprite.dart';
import 'package:gametest/components/saucer.dart';
import 'package:gametest/box-game.dart';
import 'dart:ui';

class SaucerBlue extends Saucer {
  SaucerBlue(BoxGame game, double x, double y) : super(game) {

    saucerRect = Rect.fromLTWH(x,y, game.tileSize, game.tileSize);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('saucer/saucer-blue.png'));
    flyingSprite.add(Sprite('saucer/saucer-blue-2.png'));
    flyingSprite.add(Sprite('saucer/saucer-blue-3.png'));
    deadSprite = Sprite('saucer/saucer-blue-dead.png');
  }
}