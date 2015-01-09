Robot XD001, XD002;

void setup() {
  size(800, 700);
  rectMode(CENTER);

  XD001 = new Robot(100);
  XD002 = new Robot(100);
}

void draw() {  
  background(0, 150, 150);


  XD002.drawRobot();
  XD002.easeTowards(XD001.x, XD001.y);
  XD001.drawRobot();
  XD001.easeTowards(mouseX, mouseY);
}

