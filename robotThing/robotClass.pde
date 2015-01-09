class Robot {
  float wHead = 50;
  float x, y;
  
  Robot(float headWidth){
    wHead = headWidth;
    x = width/2;
    y = height/2;
  }
  
  void easeTowards(float x_, float y_){
    float easing = 0.05;
    x = x * (1-easing) + x_ * easing;
    y = y * (1-easing) + y_ * easing;
  }
  void drawRobot() {
    pushMatrix();
    translate(x, y);
    //draw Head
    float wHead = 65;
    float hHead = 65;
    float rHead = wHead/5;

    rect(0, 0, wHead, hHead, 12, 12, 12, 12);

    //draw Eyes
    float eyeDiameter = wHead /5;
    ellipse(-wHead/3, -hHead/4, eyeDiameter, eyeDiameter);
    ellipse(wHead/3, -hHead/4, eyeDiameter, eyeDiameter);

    //draw mouth
    float wMouth = wHead * 0.25;
    float hMouth = hHead * 0.1;
    rect(0, hHead/5, wMouth, hMouth);
  popMatrix();
}
}

