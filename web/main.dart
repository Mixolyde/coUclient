library couclient;
// Import deps
import 'dart:html';
import 'dart:async';
import 'dart:convert';

import 'package:okeyee/okeyee.dart'; // used for keyboard stuff.
import 'package:intl/intl.dart'; //used for NumberFormat

// Import our coU libraries.
import 'package:glitchTime/glitch-time.dart';// The script that spits out time!
import 'package:streetlib/streetlib.dart'; // rendering streets
import 'package:scproxy/scproxy.dart'; // Paul's soundcloud bootstrap
import 'package:libld/libld.dart'; // Nice and simple asset loading.
import 'package:slack/slack_html.dart' as slack; // Access to the slack webhook api

// Engine parts
part 'dart/engine/ui.dart';
part 'dart/engine/audio.dart';
part 'dart/engine/input.dart';

part 'dart/engine/inventory.dart';

main()
{
  
  
  Element canvas = querySelector('#layers');

  canvas.parent.style
    ..overflow= 'scroll';
  
  Asset st = new Asset('./lib/locations/test.street');
  Street s = new Street(st, canvas);   
  
  
  display.init();
  input.init();
  display.name = 'Playername';
  gameLoop(0.0);  
}

// Declare our game_loop
double lastTime = 0.0;
gameLoop(num delta)
{
double dt = (delta-lastTime)/1000;
lastTime = delta;

// GAME LOOP


//RENDER LOOP
display.update();

window.animationFrame.then(gameLoop);
}