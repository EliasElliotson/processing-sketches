public char X = 0;
public char Y = 1;

public float rot(char i1, float x, float y, float w, float h, float i2) {
  float i = 0;
  if (i1 == X) {
    i = x+(cos(i2)*(w/2));
  } else if (i1 == Y) {
    i = y+(sin(i2)*(h/2));
  }
  return i;
}

public class Mushroom {
  boolean have = false;
  
  void draw(float x, float y) {
    if (!have) {
      float w = 106;
      float h = 94;
      image(mushroom.get(((frameCount/3)%16)*106, 0, 106, 94), x, y);
      if (charX > x-charW && charX < x+w && charY > y-charH && charY < y+h) {
        charH=128;
        have=true;
        powerup(1);
        sfx.play("Powerup");
      }
    }
  }
}

public PImage mushroom;

public void loadPowerups() {
  mushroom = loadImage(dataPath("graphics/powerups/mushroom.png"));
}

public void waterHB(float x, float y, float w, float h) {
  if (charX > x-charW && charX < x+w && charY > y-charH && charY < y+h) {
    swimming=true;
  }
  fill(0, 0, 255);
  rect(x, y, w, h);
}
