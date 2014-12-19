void setup() {
  size(640, 480);
  background(0, 255, 255);
  rectMode(CENTER);
  fill(255, 0, 0, 10);
  noStroke();
}

void draw() {
if(mousePressed)
  rect(mouseX, mouseY, 50, 50);
  }
