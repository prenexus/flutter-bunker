import 'package:gametest/bunker-game.dart';
import 'package:gametest/components/saucer.dart';

class SaucerSpawner {
  final BunkerGame game;

  final int maxSpawnInterval = 3000;
  final int minSpawnInterval = 250;
  final int intervalChange = 3;
  final int maxSaucersOnScreen = 3;

  late int currentInterval;
  late int nextSpawn;

  SaucerSpawner(this.game) {
    start();
    game.spawnSaucer();
  }

  void start() {
    killAll();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAll() {
    game.saucers.forEach((Saucer saucer) => saucer.isDead = true);
  }

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    int livingSaucers = 0;
    game.saucers.forEach((Saucer saucer) {
      if (!saucer.isDead) livingSaucers += 1;
    });

    if (nowTimestamp >= nextSpawn && livingSaucers < maxSaucersOnScreen) {
      game.spawnSaucer();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }
}