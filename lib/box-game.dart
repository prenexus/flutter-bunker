import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

import 'package:gametest/components/background.dart';
import 'package:gametest/components/cactus.dart';
import 'package:gametest/components/skybox.dart';
import 'package:gametest/components/bunker.dart';

import 'package:gametest/components/saucer.dart';
import 'package:gametest/components/saucer-blue.dart';
import 'package:gametest/components/saucer-red.dart';
import 'package:gametest/components/score-display.dart';
import 'package:gametest/components/missile.dart';

import 'package:gametest/view.dart';
import 'package:gametest/views/home-view.dart';

import 'package:gametest/components/spawner.dart';

import 'dart:math';

class BoxGame extends Game {
  Size screenSize;
  double tileSize;
  Background background;
  Bunker bunker;
  Cactus cactus;
  Skybox skybox;
  List<Saucer> saucers;
  List<Missile> missiles;
  ScoreDisplay scoreDisplay;
  HomeView homeView;
  SaucerSpawner spawner;
  View activeView = View.home;

  double gunAngle = 45.0;
  int score = 0;

  Random rnd;

  BoxGame() {
    initialise();
  }

  void initialise() async {
    saucers = List<Saucer>();
    missiles = List<Missile>();


    resize(await Flame.util.initialDimensions());
    rnd = Random();

    spawner = SaucerSpawner(this);
    scoreDisplay = ScoreDisplay(this);
    skybox = Skybox(this);
    background = Background(this);
    bunker = Bunker(this);
    cactus = Cactus(this);
    homeView = HomeView(this);

  }

  void render(Canvas canvas) {
    skybox.render(canvas);
    background.render(canvas);
    bunker.render(canvas);
    cactus.render(canvas);
    if (activeView == View.playing) scoreDisplay.render(canvas);

    missiles.forEach((Missile missile) => missile.render(canvas));
    saucers.forEach((Saucer saucer) => saucer.render(canvas));
  }

  void update(double t) {
    missiles.forEach((Missile missile) => missile.update(t, gunAngle));
    saucers.forEach((Saucer saucer) => saucer.update(t));

    spawner.update(t);

    // Check if missile hit saucer?
    saucers.forEach((Saucer saucer) {
      missiles.forEach((Missile missile) {
        if (missile.missileRect.overlaps(saucer.saucerRect)) {
          missile.isDead = true;
          score = score + 10;
          saucer.explode();
        }
      });
    });

    //Remove offscreen saucers
    saucers.removeWhere((Saucer saucer) => saucer.isOffScreen);
    missiles.removeWhere((Missile missile) => missile.isOffScreen);

    if (activeView == View.home) scoreDisplay.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 16;
    super.resize(size);
  }

  void spawnMissile(){
    missiles.add(Missile(this));
    if (score > 0){ score--;}
    print ("Score : " + score.toString());
  }

  void spawnSaucer(){
    double y = rnd.nextDouble() * (screenSize.height - tileSize);
    double x = screenSize.width + tileSize;

    switch (rnd.nextInt(5)) {
      case 0:
        saucers.add(SaucerBlue(this, x, y));
        break;
      case 1:
        saucers.add(SaucerBlue(this, x, y));
        break;
      case 2:
        saucers.add(SaucerBlue(this, x, y));
        break;
      case 3:
        saucers.add(SaucerBlue(this, x, y));
        break;
      case 4:
        saucers.add(SaucerRed(this, x, y));
        break;
    }
  }

  void onTapDown(TapDownDetails d) {
    spawnMissile();
  }

  void onDrag(DragDownDetails d){
  }

  void onDragUpdate (DragUpdateDetails d){
    gunAngle = gunAngle - d.primaryDelta;
    if (gunAngle > 90){
      gunAngle = 90.0;
    }

    if (gunAngle < 0){
      gunAngle = 0.0;
    }
  }

}
