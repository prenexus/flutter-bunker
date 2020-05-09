import 'dart:ui';
import 'package:gametest/bunker-game.dart';
import 'package:flame/sprite.dart';

class Saucer {
  final BunkerGame game;
  Rect saucerRect;
  bool isDead = false;
  bool isOffScreen = false;
  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;
  Offset targetLocation;

  //How fast are the saucers
  double get speed => game.tileSize *3;
  double get dropRate => 1.0;

  Saucer(this.game) {}

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(c, saucerRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, saucerRect.inflate(2));
    }
  }

  void update(double t) {
    // If saucer is dead - move it down
    if (isDead) {
      saucerRect = saucerRect.translate(0, game.tileSize * 6 * t);
    } else
    {
      flyingSpriteIndex += 10 * t;
      if (flyingSpriteIndex >= 3) {
        flyingSpriteIndex -= 3;
      }

      //How fast should they move? Can override this per class
      double stepDistance = speed * t;

      //Move them
      Offset stepToTarget = Offset(stepDistance * -1, 0.0);

      saucerRect = saucerRect.shift(stepToTarget);
    }

    //Is the saucer off screen at the bottom?
    if (saucerRect.top > game.screenSize.width) {
      isOffScreen = true;
    }
    // Made it to the extreme left?
    if (saucerRect.right < 0){
      isOffScreen = true;
    }
  }

  void explode() {
    isDead = true;
  }

}