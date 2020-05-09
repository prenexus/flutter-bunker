import 'package:gametest/bunker-game.dart';
import 'package:gametest/components/dropper.dart';

class DropperSpawner {
  final BunkerGame game;

  final int maxSpawnInterval = 3000;
  final int minSpawnInterval = 250;
  final int intervalChange = 3;
  final int maxDroppersOnScreen = 1;

  int currentInterval;
  int nextSpawn;

  DropperSpawner(this.game) {
    start();
    game.spawnDropper();
  }

  void start() {
    killAll();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAll() {
    game.droppers.forEach((Dropper dropper) => dropper.isDead = true);
  }

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    int livingDroppers = 0;
    game.droppers.forEach((Dropper dropper) {
      if (!dropper.isDead) livingDroppers += 1;
    });

    if (nowTimestamp >= nextSpawn && livingDroppers < maxDroppersOnScreen) {
      game.spawnDropper();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }
}