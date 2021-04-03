import 'package:flame/sprite.dart';
import 'package:gametest/bunker-game.dart';
import 'dart:ui';

class DropperLanded  {

  final BunkerGame game;
  late Rect dropperRect;
  double get speed => game.tileSize * 1.2;

  DropperLanded(this.game, x, y) {
    dropperRect = Rect.fromLTWH(x, y, game.tileSize/2, game.tileSize/2);
    //flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('dropper/dropper-blue.png'));
    flyingSprite.add(Sprite('dropper/dropper-blue.png'));
    flyingSprite.add(Sprite('dropper/dropper-blue.png'));
  }

  bool isDead = false;
  bool isOffScreen = false;
  late List<Sprite> flyingSprite;
  double flyingSpriteIndex = 0;
  late Offset targetLocation;

  void render(Canvas c) {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(
          c, dropperRect.inflate(2));
  }

  void update(double t) {

    if (game.landersMarch) {
      // The maximum landers has been reached. March them to the bunker!
      double stepDistance = (speed * t) / 2;
      //Move them
      Offset stepToTarget = Offset(-stepDistance,0);
      dropperRect = dropperRect.shift(stepToTarget);
    }

    // Lander has reached the bunker - blow it up and Game Over
    if (dropperRect.right < game.tileSize*3 )
    {
      game.gameOver = true;
    }


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
