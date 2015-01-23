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
  if(mousePressed)previousRobot.easeTowards(mouseX, mouseY);
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

