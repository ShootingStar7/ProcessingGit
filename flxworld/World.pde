class World {
  ArrayList<Visible> visibles;
  ArrayList<Visible> visiblesToRemove;
  float x, y, z;//position of Observer in space
  float heading = 0;//initial heading
  float stepSize = 10;//position increment when moving
  float headingStep = 0.04;//angle increment when turning
  float secondsPerDay = 30;
  int lastFireSignalInMillis = millis();
  float mouseXPrevious, mouseYPrevious, baseLookDownInPixels, lookDownInPixels;

  World() {
    x = y = z = 0;
    mouseXPrevious = width/2;
    mouseYPrevious = height/2;
    baseLookDownInPixels = 60;
    lookDownInPixels = baseLookDownInPixels;
    visibles = new ArrayList<Visible>();

    //create some colored blocks so we have something to look at
    float blockSize = width / 6;
    float yBlockCenter = -blockSize /2 ;
    float blockSpacing = blockSize * 2;
    for (int i = 2; i <5 ; ++i) {
      visibles.add(new Block(blockSpacing * i, yBlockCenter, 0, blockSize, blockSize, blockSize, color(255, 0, 0)));
      visibles.add(new Block(-blockSpacing * i, yBlockCenter, 0, blockSize, blockSize, blockSize, color(255, 200, 200)));
      visibles.add(new Block(0, yBlockCenter, blockSpacing * i, blockSize, blockSize, blockSize, color(0, 0, 255)));
      visibles.add(new Block(0, yBlockCenter, -blockSpacing * i, blockSize, blockSize, blockSize, color(200, 200, 255)));
    }

    //Let's look at a yellow sphere!
    visibles.add(new Sphere(0, 0, 0, 50, color(255, 255, 0)));
  }

  boolean runningViaJavascript() {
    int a = 1;
    int b = 2;
    int c = a / b;
    return c != 0;
  }

  void draw() {
    handleInput();

    //draw sky
    float skyBlueLevel = map(lightLevel(), 0, 1, 100, 255);
    float skyRedLevel = skyBlueLevel * 0.3;
    float skyGreenLevel = skyBlueLevel * 0.8;
    background(skyRedLevel, skyGreenLevel, skyBlueLevel);

    //draw ground
    println(lookDownInPixels);
    if (runningViaJavascript()) {
      translate(0, 240 - y , 0);
    }
    fill(0, 200, 0);
    rotateX(PI / 2 );
    ellipse(0, 0, width * 20, width * 20);
    rotateX(-PI / 2 );

    //remove  Visibles scheduled for removal
    if (visiblesToRemove != null) {
      for (Visible visible : visiblesToRemove) {
        visibles.remove(visible);
      }
      visiblesToRemove = null;
    }

    //draw visibles
    translate(width/2, height/2, 0);
    rotateY(heading);
    camera(x, y - baseLookDownInPixels, z, x - cos(heading), y - lookDownInPixels, z - sin(heading), 0.0, 1.0, 0.0);
    for (Visible visible : visibles) {
      visible.draw();
    }
  }

  void handleInput() {
    //set camera tilt up/down
    float ySensitivity=4;
    float cameraChange=ySensitivity*(mouseY-mouseYPrevious)/height;
    lookDownInPixels -=cameraChange;
    mouseYPrevious=mouseY;

    //turn left/right
    float Xsensitivity=10;
    float headingChange=Xsensitivity*(mouseX-mouseXPrevious)/width;
    heading+=headingChange;
    mouseXPrevious=mouseX;
    //fire
    if (eventManager.hasKey('f') ) {
      int millisSinceLastFiring = millis() - lastFireSignalInMillis;
      if (millisSinceLastFiring > 500f) {
        //it's been long enough, let's fire another
        lastFireSignalInMillis = millis();
        float radius = 3;
        float speed = 550;
        int clr = color(0, 0, 200);
        visibles.add(new Projectile(radius, speed, clr));
      }
    } 
    //forward
    if (eventManager.hasKey('w') ) {
      x -= stepSize * cos(heading);
      z -= stepSize * sin(heading);
    } 
    //backward
    if (eventManager.hasKey('s') ) {
      x += stepSize * cos(heading);
      z += stepSize * sin(heading);
    }
    //strafe left
    if (eventManager.hasKey('a') ) {
      x -= stepSize * sin(heading);
      z += stepSize * cos(heading);
    }
    //strafe right
    if (eventManager.hasKey('d') ) {
      //heading += headingStep;
      x += stepSize * sin(heading);
      z -= stepSize * cos(heading);
    }
    //go up
    if (eventManager.hasKey(' ') ) {
      y -= stepSize ;
    } 
    //go down
    if (eventManager.shiftIsPressed() ) {
      //fall back down, but don't fall below zero level.
      if ( y < 0) {
        y += stepSize;
      } 
      else {
        y = 0;
      }
    }
  }


  float lightLevel() {
    return map(sin(millis() * 0.001 * 2 * PI / secondsPerDay), -1, 1, 0, 1);
  }

  void removeVisible(Visible visible) {
    if (visiblesToRemove == null) {
      //lazy initialize
      visiblesToRemove = new ArrayList<Visible>();
    }
    visiblesToRemove.add(visible);
  }
}

