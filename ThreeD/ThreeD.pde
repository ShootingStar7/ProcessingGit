void setup() {
  size(640, 480, P3D);
}


void draw() {
  background (220);
  translate(mouseX, mouseY);
  stroke(0, 255, 255);
  fill(0, 255, 255, 50);
  lights();
    rotateX(xRotation);
    float radius = height/4 * (1 + sin(frameCount*0.05));
    sphere(radius);


  if (keyPressed) { 
    if (key == 'w') {
      xRotation += 0.05;
    }
  }
}
