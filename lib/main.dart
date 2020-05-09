
// TODO: Switch gun
// TODO: Mortar gun
// TODO: Title card
// TODO: High score card
// TODO: Fast moving saucers
// TODO: Make red saucer drop more guys
// TODO: Landed guys attach
// TODO: Saucer in the cactus
// TODO: SOUNDS!


import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:gametest/bunker-game.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';

void main() {

  BunkerGame game = BunkerGame();
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
    'sky/sky.png',
    'bunker/bunker.png',
    'saucer/saucer-red-dead.png',
    'saucer/saucer-blue-2.png',
    'saucer/saucer-blue-3.png',
    'missile/spr_missile_half.png',
    'missile/missile.png',
    'dropper/dropper-blue.png',
    'dropper/dropper-blue-parachute.png',

  ]);


  //The tapper will fire
  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);

  runApp(game.widget);

}

