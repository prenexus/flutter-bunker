import 'package:flame/sprite.dart';
import 'package:gametest/bunker-game.dart';
import 'dart:ui';

class DropperLanded  {

  final BunkerGame game;
  Rect dropperRect;
  double get speed => game.tileSize * 1.2;
  final int maxLanders = 10;

  DropperLanded(this.game, x, y) {
    dropperRect = Rect.fromLTWH(x, y, game.tileSize/2, game.tileSize/2);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('dropper/dropper-blue.png'));
    flyingSprite.add(Sprite('dropper/dropper-blue.png'));
    flyingSprite.add(Sprite('dropper/dropper-blue.png'));
  }

  bool isDead = false;
  bool isOffScreen = false;
  List<Sprite> flyingSprite;
  double flyingSpriteIndex = 0;
  Offset targetLocation;

  void render(Canvas c) {
    flyingSprite[flyingSpriteIndex.toInt()].renderRect(
        c, dropperRect.inflate(2));
  }

  void update(double t) {

    //Is the dropper off screen at the bottom?
    if (dropperRect.top > game.screenSize.width) {
      isOffScreen = true;
    }

    // Made it to the extreme left?
    if (dropperRect.right < 0){
      isOffScreen = true;
    }
  }

  void explode() {
    isDead = true;
  }

}
