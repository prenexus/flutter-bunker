import 'dart:ui';
import 'dart:math';
import 'package:flame/sprite.dart';
import 'package:gametest/bunker-game.dart';

class Mortar {
  final BunkerGame game;
  late Sprite bgSprite;
  late Rect mortarRect;
  bool isDead = false;
  bool isOffScreen = false;
  var flyingSprite= <Sprite>[];
  late Sprite deadSprite;
  double flyingSpriteIndex = 0;
  late Offset targetLocation;

  int mortarLife = 0;
  int mortarMaxLife = 150;
  double initialGunAngle = 0;
  // Gravity is constant
  double gravity = 2;
  double mortarX = 0.0;
  double mortarXLast = 0.0;
  double mortarY = 0.0;
  double mortarYLast = 0.0;

  //Missile speed
  double get speed => game.tileSize * 3;

  Mortar(this.game) {
    mortarRect = Rect.fromLTWH(100, 300, game.tileSize *.1, game.tileSize*.1);
    flyingSprite = <Sprite>[];
    flyingSprite.add(Sprite('missile/missile.png'));
    flyingSprite.add(Sprite('missile/missile.png'));
    flyingSprite.add(Sprite('missile/missile.png'));
    deadSprite = Sprite('missile/missile.png');
  }

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(c, mortarRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(
          c, mortarRect.inflate(2));
    }
  }

  void update(double t, double gunAngle) {
    if (isDead) {
      // Explode!

      // Remove mortar
      isOffScreen = true;
    } else {
      flyingSpriteIndex += 10 * t;
      if (flyingSpriteIndex >= 3) {
        flyingSpriteIndex -= 3;
      }

      mortarLife++;
      // If we havent set the initial gun angle - do it now
      if(initialGunAngle == 0){
        initialGunAngle = gunAngle;
      }

      if (mortarLife > mortarMaxLife){ isDead = true;}

      //How fast should they move? Can override this per class
      double stepDistance = speed * t;
      //Move them
      Offset stepToTarget;
      // 0degrees = ~3. 90 degrees = ~1.8. Each degree = 0.0133333
      double max = 3.0;
      double radians = (initialGunAngle * 3.14123 / 180);

      mortarYLast = mortarY;
      mortarXLast = mortarX;
      mortarX = (mortarLife * cos(radians)) - ((mortarLife -1) * cos(radians));
      mortarY = ((-20 * mortarLife * (sin(radians))) + (.5 * gravity * pow(mortarLife,2)));

      stepToTarget = Offset(stepDistance*3, mortarY - mortarYLast );
      mortarRect = mortarRect.shift(stepToTarget);
    }
  }

}



