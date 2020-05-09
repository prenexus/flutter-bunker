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

import 'package:gametest/components/dropper.dart';
import 'package:gametest/components/score-display.dart';
import 'package:gametest/components/missile.dart';

import 'package:gametest/view.dart';
import 'package:gametest/views/home-view.dart';

import 'package:gametest/components/spawner.dart';
import 'package:gametest/components/dropper-spawner.dart';
import 'package:gametest/components/dropper-blue.dart';
import 'package:gametest/components/dropper-landed.dart';

import 'dart:math';

class BunkerGame extends Game {
  Size screenSize;
  double tileSize;
  Background background;
  Bunker bunker;
  Cactus cactus;
  Skybox skybox;
  List<Saucer> saucers;
  List<Missile> missiles;
  List<Dropper> droppers;
  List<DropperLanded> droppersLanded;
  ScoreDisplay scoreDisplay;
  HomeView homeView;
  SaucerSpawner spawner;
  DropperSpawner dropperSpawner;
  View activeView = View.playing;

  double gunAngle = 45.0;
  int score = 0;
  //How many landers do we have?
  int landed = 0;
  // After maxLanders trigger a march to the bunker
  int maxLanders = 10;
  bool landersMarch = false;

  Random rnd;

  BunkerGame() {
    initialise();
  }

  void initialise() async {
    saucers = List<Saucer>();
    missiles = List<Missile>();
    droppers = List<Dropper>();
    droppersLanded = List<DropperLanded>();

    resize(await Flame.util.initialDimensions());
    rnd = Random();

    //Initialise all our classes
    scoreDisplay = ScoreDisplay(this);
    spawner = SaucerSpawner(this);
    dropperSpawner = DropperSpawner(this);
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
    droppers.forEach((Dropper dropper) => dropper.render(canvas));
    droppersLanded.forEach((DropperLanded dropperLanded) => dropperLanded.render(canvas));
  }

  void update(double t) {
    missiles.forEach((Missile missile) => missile.update(t, gunAngle));
    saucers.forEach((Saucer saucer) => saucer.update(t));
    droppers.forEach((Dropper dropper) => dropper.update(t));
    droppersLanded.forEach((DropperLanded dropperLanded) => dropperLanded.update(t));

    spawner.update(t);
    dropperSpawner.update(t);

    // Check if missile hit saucer?
    saucers.forEach((Saucer saucer) {

      missiles.forEach((Missile missile) {
        if (missile.missileRect.overlaps(saucer.saucerRect)) {
          missile.isDead = true;
          if (!saucer.isDead){score = score + 10;}
          saucer.explode();
        }
      });
    });


    //Remove offscreen elements
    saucers.removeWhere((Saucer saucer) => saucer.isOffScreen);
    missiles.removeWhere((Missile missile) => missile.isOffScreen);
    droppers.removeWhere((Dropper dropper) => dropper.isOffScreen);

    if (activeView == View.playing) scoreDisplay.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 16;
    super.resize(size);
  }

  void spawnMissile(){
    missiles.add(Missile(this));
    if (score > 0){ score--;}
  }

  void spawnSaucer(){
    double y = rnd.nextDouble() * (screenSize.height - tileSize);
    double x = screenSize.width + tileSize;

    // If saucer is too low.... spawn it at the bottom
    if (y > screenSize.height - tileSize*3.5) {y = screenSize.height - tileSize*3.5;}

    // Which sort of saucer are we going to spawn?
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

  void spawnDropper(){
    //Find a saucer to spawn out of
    //Find the y+x of saucer. Then spawn dropper a little below it
    final listRandom = new Random();

    var saucerToDrop = saucers[listRandom.nextInt(saucers.length)];
    double x = saucerToDrop.saucerRect.left ;
    double y = saucerToDrop.saucerRect.top;

    //Dont spawn too close to the bunker, or off screen
      if ((x < tileSize * 4) || (x > screenSize.width - tileSize * 2))
    {
      // Do nothing
    }else {
      droppers.add(DropperBlue(this, x, y));
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
