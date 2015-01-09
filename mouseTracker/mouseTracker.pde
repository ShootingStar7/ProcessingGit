void setup() {
  size(800, 700);
  background(255);
  rectMode(CENTER);
  fill(0, 0, 0, 50);
  noStroke();
}

void draw() {
  if (mousePressed)
    ellipse(mouseX, mouseY, 50, 50);
  if (keyPressed)
  { 
    if (key=='1')
      fill(0, 0, 0, 50);
    if (key=='2')
      fill(255, 0, 0, 50);
    if (key=='3')
      fill(255, 100, 0, 50);
    if (key=='4')
      fill(255, 255, 0, 50);
    if (key=='5')
      fill(0, 255, 0, 50);
    if (key=='6')
      fill(0, 255, 255, 50);
    if (key=='7')
      fill(0, 0, 255, 50);
    if (key=='8')
      fill(255, 0, 255, 50);
    if (key=='9')
      fill(150, 0, 255, 50);
    if (key=='x')
      fill(255, 255, 255, 50);
    if (key==' ')
      background(255);
  }
}

