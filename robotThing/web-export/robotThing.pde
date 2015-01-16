ArrayList<Robot> allMyLittleRobots = new ArrayList<Robot>();
int numberOfRobots = 50;

void setup() {
  size(800, 700);
  rectMode(CENTER);
  float headWidth = 100;
  for (int robotCtr = 0; robotCtr < numberOfRobots; ++robotCtr) {
    allMyLittleRobots.add(new Robot(headWidth, 0.1));
    headWidth = headWidth - 2;
  }
}

void draw() {  
  background(0, 150, 150);

  //ease towards previous robots
  Robot previousRobot = allMyLittleRobots.get(0);
  previousRobot.easeTowards(mouseX, mouseY);
  for (int robotCtr = 0; robotCtr < numberOfRobots; ++robotCtr) {
    Robot nextRobot = allMyLittleRobots.get(robotCtr);
    nextRobot.easeTowards(previousRobot.x, previousRobot.y);
    previousRobot = nextRobot;
  }

  //draw the robots
  for (int robotCtr = numberOfRobots - 1; robotCtr >= 0; --robotCtr) {
    allMyLittleRobots.get(robotCtr).drawRobot();
  }
}

class Robot {
  float wHead = 50;
  float x, y;
  float easing = 0.8;
  float alphaLevel = 100;

  Robot(float headWidth, float easing_) {
    wHead = headWidth;
    x = width/2;
    y = height/2;
  }

  void easeTowards(float x_, float y_) {
    x = x * (1-easing) + x_ * easing;
    y = y * (1-easing) + y_ * easing;
  }
  void drawRobot() {
    pushMatrix();
    translate(x, y);
    //draw Head
    fill(0, 255, 255, alphaLevel);


    float hHead = wHead;
    float rHead = wHead/5;

    rect(0, 0, wHead, hHead, 12, 12, 12, 12);

    //draw Eyes
    fill(255, 0, 0, alphaLevel);
    float eyeDiameter = wHead /5;
    ellipse(-wHead/3, -hHead/4, eyeDiameter, eyeDiameter);
    ellipse(wHead/3, -hHead/4, eyeDiameter, eyeDiameter);

    //draw mouth
    fill(255, 100, 0, alphaLevel);
    float wMouth = wHead * 0.25;
    float hMouth = hHead * 0.1;
    rect(0, hHead/5, wMouth, hMouth);
    popMatrix();
  }
}


