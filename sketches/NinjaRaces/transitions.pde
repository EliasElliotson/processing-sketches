public class Transition2 {
  float s = 255;
  
  Transition2() {
    s = 255;
  }
  
  void draw() {
    fill(0, 0, 0, s);
    noStroke();
    rect(0, 0, width, height);
    if (s != 255) {
      s-=5;
    }
  }
  
  void start() {
    s=254;
  }
}

public class Transition1 {
  float s;
  float speed = 0;
  float x, y;
  Transition1(float x2, float y2, float startSize) {
    x=x2;
    y=y2;
    s=startSize;
  }
  void draw() {
    if (speed > 0) {
      speed+=0.25;
    }
    s-=speed;
    s=max(s, 0);
    pushStyle();
    noStroke();
    fill(0);
    rect(0, 0, x-(s/2)+2, height);
    rect(x+(s/2)-2, 0, width-(x-(s/2))+2, height);
    rect(0, 0, width, y-(s/2)+2);
    rect(0, y+(s/2)-2, width, height-(y+(s/2))+2);
    rect(x-(s/2), y-(s/2), 1, 1, -s/1.75);
    rect(x+(s/2), y-(s/2), 1, 1, -s/1.75);
    rect(x-(s/2), y+(s/2), 1, 1, -s/1.75);
    rect(x+(s/2), y+(s/2), 1, 1, -s/1.75);
    popStyle();
  }
  void start() {
    speed=0.25;
  }
}
