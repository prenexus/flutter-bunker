import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:gametest/bunker-game.dart';

class Missile {
  final BunkerGame game;
  Sprite bgSprite;
  Rect missileRect;
  bool isDead = false;
  bool isOffScreen = false;
  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;
  Offset targetLocation;

  //Missile speed
  double get speed => game.tileSize * 3;

  Missile(this.game) {
    missileRect = Rect.fromLTWH(100, 300, game.tileSize *.1, game.tileSize*.1);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('missile/missile.png'));
    flyingSprite.add(Sprite('missile/missile.png'));
    flyingSprite.add(Sprite('missile/missile.png'));
    deadSprite = Sprite('missile/missile.png');
  }

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(c, missileRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(
          c, missileRect.inflate(2));
    }
  }

  void update(double t, double gunAngle) {
    if (isDead) {
      // Explode!

      // Remove missile
      isOffScreen = true;
    } else {
      flyingSpriteIndex += 10 * t;
      if (flyingSpriteIndex >= 3) {
        flyingSpriteIndex -= 3;
      }

      //How fast should they move? Can override this per class
      double stepDistance = speed * t;
      //Move them
      Offset stepToTarget;
      // 0degrees = ~3. 90 degrees = ~1.8. Each degree = 0.0133333
      double max = 3.0;
      double radians = max - (gunAngle * 0.0133333);
      stepToTarget = Offset.fromDirection(radians, stepDistance *-1);

      missileRect = missileRect.shift(stepToTarget);
    }
  }

}