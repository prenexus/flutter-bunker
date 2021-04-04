import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:gametest/components/mortar.dart';

import 'package:gametest/components/start-button.dart';

import 'package:gametest/view.dart';
import 'package:gametest/views/home-view.dart';

import 'package:gametest/components/spawner.dart';
import 'package:gametest/components/dropper-spawner.dart';
import 'package:gametest/components/dropper-blue.dart';
import 'package:gametest/components/dropper-landed.dart';

import 'dart:math';

class BunkerGame extends Game with PanDetector {
  late Size screenSize;
  late double tileSize;
  late Background background;
  late Bunker bunker;
  late Cactus cactus;
  late Skybox skybox;
  var saucers = <Saucer>[];
  var missiles =  <Missile>[];
  var mortars =  <Mortar>[];
  var droppers = <Dropper>[];
  var droppersLanded = <DropperLanded>[] ;
  late ScoreDisplay scoreDisplay;
  late HomeView homeView;
  late SaucerSpawner spawner;
  late DropperSpawner dropperSpawner;
  late StartButton startButton;

  // How many points is the saucer worth?
  int scoreSaucer = 10;

  // Is the missile selected? Else fire the mortar
  bool isMissileSelected = true;

  //Default view on launch
  View activeView = View.home;

  double gunAngle = 45.0;
  int score = 0;
  //How many landers do we have?
  int landed = 0;
  // After maxLanders trigger a march to the bunker
  int maxLanders = 3;
  bool landersMarch = false;
  bool gameOver = false;

  late Random rnd;

  BunkerGame() {
    initialise();
  }

  void initialise() async {
    //saucers = List<Saucer>();
    saucers = <Saucer>[];
    missiles = <Missile>[];
    mortars = <Mortar>[];
    droppers = <Dropper>[];
    droppersLanded = <DropperLanded>[];

    resize(await Flame.util.initialDimensions());
    startButton = StartButton(this);

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
    mortars.forEach((Mortar mortar) => mortar.render(canvas));
    saucers.forEach((Saucer saucer) => saucer.render(canvas));
    droppers.forEach((Dropper dropper) => dropper.render(canvas));
    droppersLanded.forEach((DropperLanded dropperLanded) => dropperLanded.render(canvas));

    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
    }
  }

  void update(double t) {

    //Is it game over?
    if (gameOver == true)
      {

        endGame();
        return;
      }

    missiles.forEach((Missile missile) => missile.update(t, gunAngle));
    mortars.forEach((Mortar mortar) => mortar.update(t, gunAngle));
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
          if (!saucer.isDead){score = score + scoreSaucer;}
          saucer.explode();
        }
      });
      mortars.forEach((Mortar mortar) {
        if (mortar.mortarRect.overlaps(saucer.saucerRect)) {
          mortar.isDead = true;
          if(!saucer.isDead){score = score + scoreSaucer;}
          saucer.explode();
        }
      });
    });

    droppers.forEach((Dropper dropper) {
      missiles.forEach((Missile missile) {
        if (missile.missileRect.overlaps(dropper.dropperRect)) {
          missile.isDead = true;
          if (!dropper.isDead){score = score + 5;}
          dropper.explode();
        }
      });

      mortars.forEach((Mortar mortar) {
        if (mortar.mortarRect.overlaps(dropper.dropperRect)) {
          mortar.isDead = true;
          if (!dropper.isDead){score = score + 5;}
          dropper.explode();
        }
      });

    });

    //Remove offscreen elements
    saucers.removeWhere((Saucer saucer) => saucer.isOffScreen);
    missiles.removeWhere((Missile missile) => missile.isOffScreen);
    mortars.removeWhere((Mortar mortar) => mortar.isOffScreen);
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

  void spawnMortar(){
    mortars.add(Mortar(this));
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

    // If we have more than maxLanders on the ground, dont spawn anymore droppers. When the landers get cleared, we should start dropping again
    if (landersMarch){
      return;
    }

    //Find a saucer to spawn out of
    //Find the y+x of saucer. Then spawn dropper a little below it
    final listRandom = new Random();

    var saucerToDrop = saucers[listRandom.nextInt(saucers.length)];
    double x = saucerToDrop.saucerRect.left ;
    double y = saucerToDrop.saucerRect.top;

    //Don't spawn too close to the bunker, or off screen
      if ((x < tileSize * 4) || (x > screenSize.width - tileSize * 2))
    {
      // Do nothing
    }else {
      droppers.add(DropperBlue(this, x, y));
    }
  }

  void onTapDown(TapDownDetails d) {
    if (activeView == View.home || activeView == View.lost) {
      startButton.onTapDown();
    } else {

      if (isMissileSelected){
        spawnMissile();
      }else{
        spawnMortar();
      }
    }
  }


  void onDrag(DragDownDetails d){
  }

  @override
  void onPanUpdate (DragUpdateDetails d){

    if (d.delta.dx < -2) {isMissileSelected = false;}
    if (d.delta.dx  > 2) {isMissileSelected = true;}

    gunAngle = gunAngle - (d.delta.dy );
    if (gunAngle > 90){
      gunAngle = 90.0;
    }

    if (gunAngle < 0){
      gunAngle = 0.0;
    }
  }

  void endGame(){
        // Display the end of game message and scoreboard?
  }

}
