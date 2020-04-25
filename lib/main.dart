// TODO: Alien dropships
// TODO: Dropship ground collision
// TODO: Fire gun on tap
// TODO: Move gun on swipe
// TODO: Switch gun
// TODO: Mortar gun
// TODO: Score card
// TODO: Title card
// TODO: High score card
// TODO: Missiles look stupid flying - change it to a square / round bullet?

import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:gametest/box-game.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';

void main() {

  BoxGame game = BoxGame();
  runApp(game.widget);

  Util flameUtil = Util();
  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.landscapeLeft);

  Flame.images.loadAll(<String>[
    'background/layer-2.png',
    'cactus/cactus.png',
    'saucer/saucer-red.png',
    'saucer/saucer-blue.png',
    'saucer/saucer-blue-dead.png',
  ]);



  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);

 VerticalDragGestureRecognizer dragger = VerticalDragGestureRecognizer();
 dragger.onDown = game.onDrag;
 dragger.onUpdate = game.onDragUpdate;
 flameUtil.addGestureRecognizer(dragger);

  runApp(game.widget);

}

