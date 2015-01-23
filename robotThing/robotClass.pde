class Robot {
  float wHead = 50;
  float x, y;
  float easing = 0.7;
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

