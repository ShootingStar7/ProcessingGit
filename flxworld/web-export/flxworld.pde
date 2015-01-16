World world;
EventManager eventManager;

void setup() {
  size(640, 360, OPENGL);
  eventManager = new EventManager();
  world = new World();
}

void draw() {
  world.draw();
}

void keyPressed() {
  eventManager.keyPressed();
}

void keyReleased() {
  eventManager.keyReleased();
}
class Block implements Visible {
  float x, y, z, xSize, ySize, zSize;
  int clr;

  Block(float x_, float y_, float z_
    , float xSize_, float ySize_, float zSize_, int clr_) {
    x = x_;
    y = y_;
    z = z_; 
    xSize = xSize_;
    ySize = ySize_;
    zSize = zSize_;
    clr = clr_;
  }

  void draw() {
    pushMatrix();
    fill(clr);
    translate(x, y, z);
    float clrScale = 0.5;
    stroke(red(clr) * clrScale, green(clr) * clrScale, blue(clr) *clrScale);
    box(xSize, ySize, zSize);
    popMatrix();
  }
}
class EventManager {
  // An EventManager keeps track of which keys are currently pressed.
  boolean shiftPressed = true;

  IntegerSet keySet = new IntegerSet();

  void keyPressed() {
    shiftPressed = lastKeyWasShift();
    if (!shiftPressed) {
      keySet.add(key);
    }
  }

  void keyReleased() {
    if(lastKeyWasShift()) {
      shiftPressed = false;
    }
    if (!shiftPressed) {
      keySet.remove(key);
    }
  }

  boolean shiftIsPressed() {
    return shiftPressed;
  }


  boolean hasKey(int c) {
    return keySet.hasValue(c);
  }
  
  boolean lastKeyWasShift() {
    return (key == CODED) && (keyCode == SHIFT);
  }
}

class IntegerSet {
  // An IntegerSet is, not surprisingly, a SET of integers.
  // That means that unlike a list or array, elements are
  // not repeated. 
  //If you try to add an element already in the 
  // set, it will ignore you.
  int[] values = new int[0];

  void add(int value) {
    int[] newValues = new int[values.length + 1];
    for (int i = 0; i < values.length; ++i ) {
      if (values[i] == value) {
        //already have it
        return;
      }
      newValues[i] = values[i];
    }
    newValues[values.length] = value;
    values = newValues;
  }

  boolean hasValue(int value) {
    for (int i = 0; i < values.length; ++i ) {
      if (values[i] == value) {
        return true;
      }
    }
    return false;
  }

  boolean isEmpty() {
    return values.length == 0;
  }

  void remove(int value) {
    if (values.length == 0) {
      //empty, so nothing to remove
      return;
    }
    int[] newValues = new int[values.length - 1];
    int newIndex = 0;
    for (int i = 0; i < values.length; ++i ) {
      if (values[i] != value) {
        //copy, don't remove
        if (newIndex < newValues.length)
          newValues[newIndex++] = values[i];
      }
    }
    values = newValues;
  }
}

class Projectile implements Visible {
  float x, y, z, heading, radius, speed, verticalSpeed;
  int startTimeInMillis, clr;

  Projectile(float r_, float speed_, int clr_) {
    radius = r_;
    speed = speed_;
    clr = clr_;
    startTimeInMillis = millis();

    //copy the rest from the observer
    x = world.x;
    y = world.y;
    z = world.z;
    heading = world.heading;
    verticalSpeed=400*(world.lookDownInPixels-60);
  }

  void draw() {
    //You can move the sphere by changing x, y, z
    //or change the radius or color.
    //Can you get the sphere to blink on and off?
    float elapsedSeconds = (millis() - startTimeInMillis) * 0.001;
    float dx = speed * cos(heading) * elapsedSeconds;
    float dz = speed * sin(heading) * elapsedSeconds;
    float gravity=50;
    float newY = y -50 - (elapsedSeconds * verticalSpeed -gravity * elapsedSeconds * elapsedSeconds );

    if (newY > 0 ) {
      world.removeVisible(this);
    } 
    else {
      pushMatrix();
      fill(clr);
      translate(x - dx, newY, z - dz);
      noStroke();
      sphere(radius);
      popMatrix();
    }
  }
}
class Sphere implements Visible {
  float x, y, z, radius;
  int clr;

  Sphere(float x_, float y_, float z_, float r_, int clr_) {
    x = x_;
    y = y_;
    z = z_; 
    radius = r_;
    clr = clr_;
  }

  void draw() {
    //You can move the sphere by changing x, y, z
    //or change the radius or color.
    //Can you get the sphere to blink on and off?
    x = map(world.lightLevel(), 0, 1, -1000, 1000);
    pushMatrix();
    fill(clr);
    translate(x, y, z);
    noStroke();
    sphere(radius);
    popMatrix();
  }
}

interface Visible {
  /* Everything that can be drawn should implement Visible.
  This allows us to have collections of Visibles which we
  can iterate over */
  void draw();
}
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


