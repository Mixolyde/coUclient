part of coUclient;

Player CurrentPlayer;

class Player{
  
  int posX;
  int posY;
  
  int width;
  int height;
  
  ImageElement avatar;
  
  //for testing purposes
  //if false, player can move around with wasd and arrows, no falling
  bool doPhysicsApply = true;
  
  CanvasElement playerCanvas;
  
  Body playerBox;
  
  Stopwatch t;
  
  Player(){
    avatar = new ImageElement(src: "assets/sprites/avatar.png");
    //TODO: Remove hard-coded values used for testing
    posX = 0;
    posY = 550;
    width = 100;
    height = 172;
    t = new Stopwatch();
    
// Create shape
    final PolygonShape shape = new PolygonShape();
    shape.setAsBoxWithCenterAndAngle(5.0, 8.6, new Vector2.zero(), 0.0);

    // Define fixture (links body and shape)
    final FixtureDef activeFixtureDef = new FixtureDef();
    activeFixtureDef.restitution = 0.001;
    activeFixtureDef.density = 0.05;
    activeFixtureDef.shape = shape;

    // Define body
    final BodyDef bodyDef = new BodyDef();
    bodyDef.type = BodyType.DYNAMIC;
    bodyDef.position = new Vector2(-185.0, 30.0);

    // Create body and fixture from definitions
    playerBox = boxTest.world.createBody(bodyDef);
    playerBox.createFixture(activeFixtureDef);

    // Add to list
    boxTest.bodies.add(playerBox);

    //Player's box should not rotate (this could break under extreme values?)
    playerBox.angularDamping = 9999999.0;
    
    CurrentPlayer = this;
  }
  
  update(){

    
    
    //move left and right
    if (playerInput.rightKey == true){
      playerBox.awake = true;
      playerBox.linearVelocity.add(new Vector2(1.0,0.0));
    }
    if (playerInput.leftKey == true){
      playerBox.awake = true;
      playerBox.linearVelocity.add(new Vector2(-1.0,0.0));
    }
    
    //used in the future for animations
    //if player is afk for awhile, call afk animation
    if (playerBox.awake == false){
      t.start();
    }
    else if (playerBox.awake == true){
      t.stop();
      t.reset();
    }
    
    //jumping
    if (playerInput.spaceKey == true){
      playerBox.awake = true;
      
      if (playerBox.linearVelocity.y > 80.0){
        //playerBox.linearVelocity.y = 80.0;
        //playerBox.linearVelocity.add(new Vector2(0.0,-120.0));
      }
      else
      playerBox.linearVelocity.add(new Vector2(0.0,15.0));

        
    }
    else if (playerInput.spaceKey == true){
      
      playerBox.linearVelocity.add(new Vector2(0.0,-60.0));
    }
    
    if (doPhysicsApply == true) {
      if (posY < 400){
        //posY += 3;
      }
    }
    
    if (doPhysicsApply == false){
      //if (playerInput.downKey == true)
        //posY += 5;
      //if (playerInput.upKey == true)
        //posY -= 5;
    }
    
    if (posX < 0)
      posX = 0;
    if (posX > CurrentStreet.width - width)
      posX = CurrentStreet.width - width;
    if (posY < 0)
      posY = 0;
    if (posY > CurrentStreet.height + height)
      posY = CurrentStreet.height + height;

    CurrentPlayer = this;
  }
  
  render(){
    posX = (playerBox.getWorldPoint(new Vector2(-5.0,8.6)).x*10+STREET_WIDTH/2).floor();
    posY = (playerBox.getWorldPoint(new Vector2(-5.0,8.6)).y*-10+STREET_HEIGHT/2).floor();

    //Need scaling; some levels change player's apparent size
    gameCanvas.context2D.drawImageScaled(avatar, posX, posY, width, height);
  }
}