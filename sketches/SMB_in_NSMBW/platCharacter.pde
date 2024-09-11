// Define a class for drawing characters
public class CharacterGraphics {
  // Small character sprites
  PImage idle1;
  PImage jump1;
  PImage run11;
  PImage run21;
  PImage run31;
  PImage skid1;
  PImage swim11;
  PImage swim21;
  PImage swim31;
  
  // Big character sprites
  PImage idle2;
  PImage jump2;
  PImage run12;
  PImage run22;
  PImage run32;
  PImage skid2;
  PImage swim12;
  PImage swim22;
  PImage swim32;
  CharacterGraphics(String path) {
    PImage orig = loadImage(path);
    
    // Load small character
    idle1 = orig.get(4, 4, 64, 64);
    jump1 = orig.get((68*5)+4, 4, 64, 64);
    run11 = orig.get((68*1)+4, 4, 64, 64);
    run21 = orig.get((68*2)+4, 4, 64, 64);
    run31 = orig.get((68*3)+4, 4, 64, 64);
    skid1 = orig.get((68*4)+4, 4, 64, 64);
    swim11 = orig.get((68*9)+4, 4, 64, 64);
    swim21 = orig.get((68*10)+4, 4, 64, 64);
    swim31 = orig.get((68*11)+4, 4, 64, 64);
    
    // Load big character
    idle2 = orig.get(4, (68*1)+4, 64, 128);
    jump2 = orig.get((68*5)+4, (68*1)+4, 64, 128);
    run12 = orig.get((68*1)+4, (68*1)+4, 64, 128);
    run22 = orig.get((68*2)+4, (68*1)+4, 64, 128);
    run32 = orig.get((68*3)+4, (68*1)+4, 64, 128);
    skid2 = orig.get((68*4)+4, (68*1)+4, 64, 128);
    swim12 = orig.get((68*9)+4, (68*1)+4, 64, 128);
    swim22 = orig.get((68*10)+4, (68*1)+4, 64, 128);
    swim32 = orig.get((68*11)+4, (68*1)+4, 64, 128);
  }
  
  void draw(float x, float y, int state, int frame, int direction) {
    x = round(x);
    y = round(y);
    if (state == 0) {
      pushMatrix();
      translate(x+32, y);
      scale(direction, 1);
      if (frame == 0) {
        image(idle1, -32, 0);
      } else if (frame == 1) {
        image(run11, -32, 0);
      } else if (frame == 2) {
        image(run21, -32, 0);
      } else if (frame == 3) {
        image(run31, -32, 0);
      } else if (frame == 4) {
        image(skid1, -32, 0);
      } else if (frame == 5) {
        image(jump1, -32, 0);
      } else if (frame == 9) {
        image(swim11, -32, 0);
      } else if (frame == 10) {
        image(swim21, -32, 0);
      } else if (frame == 11) {
        image(swim31, -32, 0);
      }
      popMatrix();
    } else if (state == 1) {
      pushMatrix();
      translate(x+32, y);
      scale(direction, 1);
      if (frame == 0) {
        image(idle2, -32, 0);
      } else if (frame == 1) {
        image(run12, -32, 0);
      } else if (frame == 2) {
        image(run22, -32, 0);
      } else if (frame == 3) {
        image(run32, -32, 0);
      } else if (frame == 4) {
        image(skid2, -32, 0);
      } else if (frame == 5) {
        image(jump2, -32, 0);
      } else if (frame == 9) {
        image(swim12, -32, 0);
      } else if (frame == 10) {
        image(swim22, -32, 0);
      } else if (frame == 11) {
        image(swim32, -32, 0);
      }
      popMatrix();
    }
  }
}

public String charModsPath(String i) {
  return dataPath("graphics/character/"+i);
}

// Initialize the key-input variables
public boolean[] keys = {false, false, false, false, false, false}; // Keep track of the keys
public char[] keyCodes = {UP, DOWN, LEFT, RIGHT, CONTROL, SHIFT}; // Define key codes (up, down, left, right, a, b, x, y)

// Character variables
public float charX = 0;
public float charY = 0;
public float charW = 64;
public float charH = 64;
public float gravity = 0;
public float xPosMove = 0;
public float speed = 0.25;
public float slip = 0.375;
public float maxSpeed = 8;
public float jumpHeight = 15;
public float maxGravity = 15;
public float gravitySpeed = 0.5;
public boolean canJump = false;
public boolean jumping = false;
public boolean canSlipJump = false;
public boolean pjump = false;
public int direction = 1;
public int state = 0;
public int charFrame = 0;
public float walkTime = 0;
public boolean swimming = false;
public float swimFrame = 0;
public int prevPowerup = 0;
public int newPowerup = 0;
public float powerupTime = 51;
public int pPowerup = 0;
public float time = 10;
public float points = 0;
public boolean uptoWall = false;

public void updateCharacter() {
  if (powerupTime > 50) {
    
    // Gravity
    gravity+=gravitySpeed;
    if (!swimming) {
      charY+=gravity;
    } else {
      charY+=gravity/3;
    }
    if (gravity > maxGravity) {
      gravity = maxGravity;
    }
    if (xPosMove < 0) {
      xPosMove+=max(slip, xPosMove);
    }
    if (xPosMove > 0) {
      xPosMove-=min(slip, xPosMove);
    }
    xPosMove=max(min(xPosMove, maxSpeed), -maxSpeed);
    charX+=xPosMove;
    if (swimming) {
      canJump=true;
    } else if (abs(xPosMove) > 9) {
      jumpHeight=17;
      maxGravity=15;
    } else {
      jumpHeight=15;
      maxGravity=15;
    }
    
    // Key updates
    if (keys[5] && canJump && !pjump) {
      gravity=-jumpHeight;
      canJump=false;
      swimFrame=0;
      pjump=true;
      if (swimming) {
        sfx.play("Swim");
      } else {
        sfx.play("Jump");
      }
    }
    if (keys[5]) {
      jumping=true;
    } else {
      jumping=false;
    }
    if (!jumping) {
      gravity=max(-7, gravity);
    }
    if (keys[3]) {
      xPosMove+=speed+slip;
      if (xPosMove > 0) {
        direction = 1;
      }
    }
    if (keys[2]) {
      xPosMove-=speed+slip;
      if (xPosMove < 0) {
        direction = -1;
      }
    }
    if (xPosMove-speed != 0 && !uptoWall) {
      walkTime+=abs(xPosMove);
    } else {
      walkTime=0;
    }
    
    // Speed run
    if (swimming) {
      maxSpeed=3;
    } else if (keys[4]) {
      speed = 0.25;
      slip = 0.375;
      maxSpeed = 15;
    } else {
      speed = 0.25;
      slip = 0.375;
      maxSpeed = 8;
    }
    
    // Character pos
    if (swimming) {
      int i = min(floor(swimFrame/7), 2)+9;
      if (swimFrame > 21) {
        i = (floor((swimFrame-21)/28)%3)+9;
      }
      charFrame=i;
    } else if (!canJump) {
      charFrame=5;
    } else if (xPosMove > 0 && keys[2] || xPosMove < 0 && keys[3]) {
      charFrame=4;
    } else if (xPosMove != 0 && canJump) {
      int i = (int(walkTime%200)/50);
      if (i == 0) {
        i=1;
      } else if (i == 1) {
        i=2;
      } else if (i == 2) {
        i=3;
      } else {
        i=2;
      }
      charFrame=i;
    } else {
      charFrame=0;
    }
    
    if (canJump && !keys[5]) {
      pjump=false;
    }
    if (!canSlipJump) {
      canJump=false;
    }
    swimming = false;
    swimFrame++;
    time-=0.02;
    uptoWall=false;
  } else {
    powerupTime++;
    int i = floor(powerupTime/10)%2;
    if (i == 1) {
      state=newPowerup;
    } else {
      state=prevPowerup;
    }

  }
}

public void groundHB(float x, float y, float w, float h, int sens) {
  int hb = 0;
  if (charX > x-charW && charX < x+w && charY > y-charH && charY < y+h) {
    hb=getSide(x, y, w, h);
  }
  if (charY > y-charH && charY < y-charH+sens && charX > x-charW && charX < x+w && hb == 0) {
    if (gravity >= 0) {
      gravity=0;
    }
    canJump=true;
    charY=y-charH;
  }
  if (charX > x-charW && charX < x-charW+sens && charY > y-charH+gravitySpeed && charY < y+h && hb == 3) {
    xPosMove=0;
    charX=x-charW;
    uptoWall=true;
  }
  if (charX > x+w-sens && charX < x+w && charY > y-charH+gravitySpeed && charY < y+h && hb == 1) {
    xPosMove=0;
    charX=x+w;
    uptoWall=true;
  }
  if (charY > y+h-sens && charY < y+h && charX > x-charW && charX < x+w && hb == 2) {
    charY=y+h;
    gravity=1;
  }
}

void slopeTHB(float x1, float y1, float x2, float y2, int s) {
  if (x1 > x2) {
    float v1 = x1;
    float v2 = x2;
    x1=v2;
    x2=v1;
  }
  float slope = -(y2-y1)/(x2-x1);
  if (charX > x1-charW && charX < x2 && charY > map(charX+(charW/2), x1, x2, y1, y2)-charH && charY < map(charX+(charW/2), x1, x2, y1, y2)-charH+s && gravity > 0) {
    charY = map(charX+(charW/2), x1, x2, y1, y2)-charH;
    canJump=true;
    if (gravity >= 0) {
      gravity=5;
    }
    if (xPosMove > maxSpeed*(1-(slope/1.75)) && slope > 0) {
      xPosMove=maxSpeed*(1-(slope/1.75));
    }
    if (xPosMove < maxSpeed*(-1-(slope/1.75)) && slope < 0) {
      xPosMove=maxSpeed*(-1-(slope/1.75));
    }
  }
}

public void rotHB(float x, float y, float w, float h, float r, int s) {
  slopeTHB(x, y, x+w, y+h, 20);
  pushMatrix();
  translate(x, y);
  rotate(radians(r));
  fill(0, 255, 0);
  /*
  rect(-w/2, -h/2, w, h);
  */
  popMatrix();
  line(x, y, x+w, y+h);
}

public void gameKeyPress() {
  for (int i = 0; i < keyCodes.length; i++) {
    if (keyCode == keyCodes[i] && keys[i] == false) {
      keys[i] = true;
    }
  }
}

public void gameKeyRelease() {
  for (int i = 0; i < keyCodes.length; i++) {
    if (keyCode == keyCodes[i] && keys[i] == true) {
      keys[i] = false;
    }
  }
}

public void powerup(int pow) {
  powerupTime = 0;
  prevPowerup=state;
  newPowerup=pow;
  int[] charHs = {64, 128, 128, 128};
  charH=charHs[pow];
  charY-=(charHs[pow]-charHs[state]);
}
