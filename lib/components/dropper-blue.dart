import 'package:flame/sprite.dart';
import 'package:gametest/components/dropper.dart';
import 'package:gametest/bunker-game.dart';
import 'dart:ui';

class DropperBlue extends Dropper {

  double get speed => game.tileSize * 1.2;

  DropperBlue(BunkerGame game, double x, double y) : super(game) {

    dropperRect = Rect.fromLTWH(x,y, game.tileSize/2, game.tileSize/2);
    flyingSprite = <Sprite>[];
    flyingSprite.add(Sprite('dropper/dropper-blue.png'));
    flyingSprite.add(Sprite('dropper/dropper-blue.png'));
    flyingSprite.add(Sprite('dropper/dropper-blue.png'));
    parachuteSprite = Sprite('dropper/dropper-blue-parachute.png');
  }
}