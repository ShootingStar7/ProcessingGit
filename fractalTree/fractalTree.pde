int MAX_BRANCH_LEVEL = 5;
float angleInDegrees = 25;
float trunkHeightMultiplier = 0.1;
float angleShiftInDegrees = 0;
void setup() {
  size(400, 400);
}
void draw() {
  background (255);
  translate(width/2, height*2/3);
  scale(1, -1);  

  if (keyPressed) {
    if (key == 'a') {

      ++angleShiftInDegrees;
    }
    if (key == 'd') {
      --angleShiftInDegrees;
    }
  }
  drawTree(0);
}
void drawTree(int level) {
  if (level > MAX_BRANCH_LEVEL) {
    return;
  }
  float trunkThickness = 20 * pow(0.6, level);
  strokeWeight(trunkThickness);
  stroke(#734501);
  float trunkHeight = height * trunkHeightMultiplier * pow(0.9, level);
  ;
  line(0, 0, 0, trunkHeight);
  translate(0, trunkHeight);
  pushMatrix();
  float angleInRadians = angleInDegrees * PI / 180;
  float angleShiftInRadians = angleShiftInDegrees * PI / 180;
  rotate(angleInRadians + angleShiftInRadians);
  drawTree(level + 1);
  popMatrix();
  pushMatrix();
  rotate(-angleInRadians + angleShiftInRadians);
  drawTree(level + 1);
  popMatrix();
}

