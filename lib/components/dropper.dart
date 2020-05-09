import 'dart:ui';
import 'package:gametest/bunker-game.dart';
import 'package:gametest/components/dropper-landed.dart';
import 'package:flame/sprite.dart';

class Dropper {
  final BunkerGame game;
  Rect dropperRect;
  bool isDead = false;
  bool isOffScreen = false;
  bool isParachuting = false;
  bool hasLanded = false;
  List<Sprite> flyingSprite;
  Sprite parachuteSprite;
  double flyingSpriteIndex = 0;
  Offset targetLocation;

  // Slightly slower than the saucers
  double get speed => game.tileSize *2;

  Dropper(this.game) {}

  void render(Canvas c) {
    if (isDead) {
      //parachuteSprite.renderRect(c, dropperRect.inflate(2));
    }
    //Check height - open parachute or just render
    if (hasLanded){
      //flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, dropperRect.inflate(2));
    }


    if (isParachuting) {
        parachuteSprite.renderRect(c, dropperRect.inflate(2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()].renderRect(c, dropperRect.inflate(2));
    }
  }

  void update(double t) {
    if (dropperRect.top > game.screenSize.height - game.tileSize *1.5 ) {
      hasLanded = true;
      isOffScreen = true;
      return;
    }else {
      // Open the parachute!
      if (dropperRect.top > game.screenSize.height - game.tileSize * 3) {
        isParachuting = true;
        //How fast should they move?
        double stepDistance = (speed * t) / 2;
        //Move them
        Offset stepToTarget = Offset(0, stepDistance);

        dropperRect = dropperRect.shift(stepToTarget);
      } else {
        flyingSpriteIndex += 10 * t;
        if (flyingSpriteIndex >= 3) {
          flyingSpriteIndex -= 3;
        }

        //How fast should they move? Can override this per class
        double stepDistance = speed * t;
        //Move them
        Offset stepToTarget = Offset(0, stepDistance);
        dropperRect = dropperRect.shift(stepToTarget);
      }
    }
      // If saucer is dead - move it down
    if (isDead) {
      //Play death animation / or drop if chute is shot?
      //dropperRect = saucerRect.translate(0, game.tileSize * 6 * t);
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