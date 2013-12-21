part of coUclient;

BoxTest boxTest;

class BoxTest {
  
  /** All of the bodies in a simulation. */
  List<Body> bodies = new List<Body>();

  /** Scale of the viewport. */
  static const double _VIEWPORT_SCALE = 10.0;

  /** The gravity vector's y value. */
  static const double GRAVITY = -100.0;

  /** The timestep and iteration numbers. */
  static const num TIME_STEP = 1/60;
  static const int VELOCITY_ITERATIONS = 10;
  static const int POSITION_ITERATIONS = 10;

  /** The canvas rendering context. */
  CanvasRenderingContext2D ctx;

  /** The transform abstraction layer between the world and drawing canvas. */
  ViewportTransform viewport;

  /** The debug drawing tool. */
  DebugDraw debugDraw;

  /** The physics world. */
  World world;

  /** Frame count for fps */
  int frameCount;

  /** HTML element used to display the FPS counter */
  Element fpsCounter;

  /** Microseconds for world step update */
  int elapsedUs;

  /** HTML element used to display the world step time */
  Element worldStepTime;

  double viewportScale;

  Stopwatch _stopwatch;

  BoxTest(String name, [Vector2 gravity, this.viewportScale = _VIEWPORT_SCALE]) {
    _stopwatch = new Stopwatch()..start();
    //query("#title").innerHtml = name;
    bool doSleep = true;
    if (null == gravity) gravity = new Vector2(0.0, GRAVITY);
    world = new World(gravity, doSleep, new DefaultWorldPool());
  }

  /** Advances the world forward by timestep seconds. */
  void step(num timestamp) {
    _stopwatch.reset();
    world.step(TIME_STEP, VELOCITY_ITERATIONS, POSITION_ITERATIONS);
    elapsedUs = _stopwatch.elapsedMicroseconds;

    // Clear the animation panel and draw new frame.
    //ctx.clearRect(0, 0, CurrentStreet.width, CurrentStreet.height);
    world.drawDebugData();
    ++frameCount;

    window.requestAnimationFrame((num time) { step(time); });
  }

  /**
   * Creates the canvas and readies the demo for animation. Must be called
   * before calling runAnimation.
   */
  void initializeAnimation() {

    ctx = gameCanvas.getContext("2d");

    // Create the viewport transform with the center at extents.
    final extents = new Vector2(STREET_WIDTH / 2, STREET_HEIGHT / 2);
    viewport = new CanvasViewportTransform(extents, extents);
    viewport.scale = viewportScale;

    // Create our canvas drawing tool to give to the world.
    debugDraw = new CanvasDraw(viewport, ctx);

    // Have the world draw itself for debugging purposes.
    world.debugDraw = debugDraw;

    frameCount = 0;
    //fpsCounter = query("#fps-counter");
    //worldStepTime = query("#world-step-time");
    new Timer.periodic(new Duration(seconds: 1), (Timer t) {
        //fpsCounter.innerHtml = frameCount.toString();
        frameCount = 0;
    });
    new Timer.periodic(new Duration(milliseconds: 200), (Timer t) {
        //worldStepTime.innerHtml = "${elapsedUs / 1000} ms";
    });
  }

//  void initialize(){}

  /**
   * Starts running the demo as an animation using an animation scheduler.
   */
  void runAnimation() {
    window.requestAnimationFrame((num time) { step(time); });
  }


  void initialize() {
    assert (null != world);
    _createGround();

  }

  void _createGround() {
    // Create shape
    final PolygonShape shape = new PolygonShape();

    // Define body
    final BodyDef bodyDef = new BodyDef();
    bodyDef.position.setValues(0.0, -30.0);

    // Create body
    final Body ground = world.createBody(bodyDef);

    // Create ground the width of the level
    shape.setAsBox(200.0, 0.4);
    ground.createFixtureFromShape(shape);

    // Add composite body to list
    bodies.add(ground);
  }
}
