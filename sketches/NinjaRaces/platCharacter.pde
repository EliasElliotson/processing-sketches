// Initialize the key-input variables
public boolean[] keys = {false, false, false, false, false, false, false}; // Keep track of the keys
public boolean[] keyPress = {false, false, false, false, false, false, false}; // Keep track of the previous values of the keys
public char[] keyCodes = {UP, DOWN, LEFT, RIGHT, CONTROL, SHIFT, ENTER}; // Define key codes (up, down, left, right, a, b, x, y)

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
public boolean dying = false;
public float dieTimer = 0;
public float dieGravity = 0;
public float dieY = 0;
public String dieType = "";
public boolean drawDieIn = false;
public int charD = 1;
public float walkTime = 0;

public void resetChar() {
  scrollY = height;
  gravity = 0;
  xPosMove = 0;
  speed = 0.25;
  slip = 0.375;
  maxSpeed = 6;
  jumpHeight = 15;
  maxGravity = 15;
  gravitySpeed = 0.5;
  canJump = false;
  jumping = false;
  canSlipJump = false;
  dying=false;
  dieTimer=0;
  dieGravity=0;
  dieY=0;
  dieType = "";
  dieIn = new Transition2();
  dieIn.start();
  drawDieIn = true;
  keyX=new float[0];
  keyY=new float[0];
  keyNum=0;
  if (checkpointX != 0 || checkpointY != 0) {
    charX=checkpointX*64;
    charY=checkpointY*64;
  } else {
    for (int y = 0; y < levels[level].length; y++) {
      for (int x = 0; x < levels[level][y].length(); x++) {
        if (levels[level][y].charAt(x) == 'P') {
          charX=x*64;
          charY=y*64;
        }
      }
    }
  }
  time = 500;
  setupLevel(levels[level]);
}

void die(float x, float y) {
  if (dying == false) {
    gravity = 0;
    xPosMove = 0;
    speed = 0.25;
    slip = 0.375;
    maxSpeed = 6;
    jumpHeight = 15;
    maxGravity = 15;
    gravitySpeed = 0.5;
    canJump = false;
    jumping = false;
    canSlipJump = false;
    dying=true;
    dieGravity = -15;
    dieType = "die";
    dieOut = new Transition1(x, y, 2500);
    dieSound.play();
  }
}

void die(String i, float x, float y) {
  if (dying == false) {
    gravity = 0;
    xPosMove = 0;
    speed = 0.25;
    slip = 0.375;
    maxSpeed = 6;
    jumpHeight = 15;
    maxGravity = 15;
    gravitySpeed = 0.5;
    canJump = false;
    jumping = false;
    canSlipJump = false;
    dying=true;
    dieGravity = -15;
    dieType = "pit";
    dieOut = new Transition1(x, y, 2500);
    dieSound.play();
  }
}

public void drawCharacter() {
  float size = 83;
  pushMatrix();
  translate(charX+32-scrollX, 0);
  scale(charD, 1);
  if (dying) {
    image(ninja.get(396, 431, 128, 128), -32-(size/8), charY+64-size-scrollY+dieY, size, size);
  } else if (!canJump && gravity <= 0) {
    image(ninja.get(137, 151, 128, 128), -32-(size/8), charY+64-size-scrollY, size, size);
  } else if (!canJump && gravity > 0) {
    image(ninja.get(395, 11, 128, 128), -32-(size/8), charY+64-size-scrollY, size, size);
  } else if (canJump && abs(xPosMove) > 0) {
    if (floor(walkTime/30)%3 == 0) {
      image(ninja.get(266, 11, 128, 128), -32-(size/8), charY+64-size-scrollY, size, size);
    } else if (floor(walkTime/30)%3 == 1) {
      image(ninja.get(395, 11, 128, 128), -32-(size/8), charY+64-size-scrollY, size, size);
    } else {
      image(ninja.get(1, 11, 128, 128), -32-(size/8), charY+64-size-scrollY, size, size);
    }
  } else {
    image(ninja.get(1, 11, 128, 128), -32-(size/8), charY+64-size-scrollY, size, size);
  }
  popMatrix();
}

public void updateCharacter() {
  if (dying == false) {
    // Gravity
    gravity+=gravitySpeed;
    charY+=gravity;
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
    
    // Key updates
    if (keys[5] && canJump) {
      gravity=-jumpHeight;
      canJump=false;
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
      charD=1;
      walkTime+=xPosMove;
    } else if (keys[2]) {
      xPosMove-=speed+slip;
      charD=-1;
      walkTime+=xPosMove;
    } else {
      walkTime=0;
    }
    
    // Speed run
    if (keys[4]) {
      speed = 0.25;
      slip = 0.375;
      maxSpeed = 10;
      jumpHeight=17;
    } else {
      speed = 0.25;
      slip = 0.375;
      maxSpeed = 8;
      jumpHeight=15;
    }
    
    if (!canSlipJump) {
      canJump=false;
    }
  } else {
    if (dieTimer == 50) {
      dieOut.start();
      downSound.play();
    }
    dieTimer++;
    if (dieTimer > 200) {
      resetChar();
      loadTileset(levels[level]);
    }
    if (dieTimer > 50 && dieType == "die") {
      dieY+=dieGravity;
      dieGravity+=gravitySpeed;
      dieGravity = min(dieGravity, 15);
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
  if (charX > x-charW && charX < x-charW+sens && charY > y-charH && charY < y+h && hb == 3) {
    xPosMove=0;
    charX=x-charW;
    walkTime=60;
  }
  if (charX > x+w-sens && charX < x+w && charY > y-charH && charY < y+h && hb == 1) {
    xPosMove=0;
    charX=x+w;
    walkTime=60;
  }
  if (charY > y+h-sens && charY < y+h && charX > x-charW && charX < x+w && hb == 2) {
    charY=y+h;
    gravity=1;
  }  
}

public void upGroundHB(float x, float y, float w, float sens) {
  if (charY > y-charH && charY < y-charH+sens && charX > x-charW && charX < x+w && gravity > 0) {
    if (gravity >= 0) {
      gravity=0;
    }
    canJump=true;
    charY=y-charH;
  }
}

public void checkpoint(float x, float y) {
  //image(marioCheckpoint.get((int(frameCount*0.6)%34)*160, 0, 160, 180), int(x+32-80+30)-scrollX, int(y+64-180)-scrollY);
  if (checkpointX != floor(x/64) && checkpointY != floor(x/64)) {
    if (charX+charW > x+24 && charX < x+44 && charY+charH > y-84 && charY < y+64) {
      checkpointX=floor(x/64);
      checkpointY=floor(y/64);
      checkpointFrame=0;
      checkpointSound.stop();
      checkpointSound.play();
    }
    image(bowserCheckpoint.get((int(checkpointFrame*0.6)%34)*160, 0, 160, 180), round(x+32-80+30-scrollX), round(y+64-180-scrollY));
  } else {
    if (checkpointFrame < 39/0.6) {
      image(marioHitCheckpoint.get((int(checkpointFrame*0.6)%39)*160, 0, 160, 180), round(x+32-80+30-scrollX), round(y+64-180-scrollY));
    } else {
      image(marioCheckpoint.get((int(checkpointFrame*0.6)%34)*160, 0, 160, 180), round(x+32-80+30-scrollX), round(y+64-180-scrollY));
    }
  }
}

public void coin(int x, int y) {
  if (levelData.get((x/64)+","+(y/64)+"collected") == 0) {
    image(regularCoin.get((int(frameCount*0.6)%24)*60, 0, 60, 60), round(x+2-scrollX), round(y+2-scrollY));
    if (charX+charW > x+2 && charX < x+62 && charY+charH > y+2 && charY < y+62) {
      levelData.set((x/64)+","+(y/64)+"collected", 1);
      coinRegularSound.stop();
      coinRegularSound.play();
    }
  } else {
    tint(255, 255, 255, 150);
    image(coinEffect1.get(int(levelData.get((x/64)+","+(y/64)+"effectFrame"))*floor(coinEffect1.width/30), 0, floor(coinEffect1.width/30), 64), round(x-scrollX), round(y-scrollY));
    tint(255);
    levelData.set((x/64)+","+(y/64)+"effectFrame", levelData.get((x/64)+","+(y/64)+"effectFrame")+2);
  }
}

public void spike(int x, int y) {
  int[] frames = {0, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  int frame = 0;
  int frameC = (frameCount/2)%frames.length;
  frame=frames[frameC];
  image(spike.get((frame%5)*64, 0, 64, 64), round(x-scrollX), round(y-scrollY));
  if (charX+charW > x && charX < x+64 && charY+charH > y && charY < y+64) {
    die(charX+(charW/2)-scrollX, charY+(charH/2)-scrollY);
  }
  groundHB(x, y, 64, 64, 30);
}

public void key(int x, int y) {
  if (get(x/60, y/60, "h") == 0) {
    int[] frames = {0, 1, 2, 3, 3, 4, 4, 4, 3, 3, 2, 1, 0, 5, 6, 7, 7, 8, 8, 8, 7, 7, 6, 5};
    int frame = 0;
    int frameC = (frameCount/2)%frames.length;
    float reFrame = frameCount;
    frame=frames[frameC];
    image(keyImg.get((frame%9)*60, 0, 60, 60), round(x-scrollX)+2, round(y-scrollY)+2+(sin(reFrame/10)*5));
    if (charX+charW > x+2 && charX < x+62 && charY+charH+2 > y && charY < y+62) {
      keyNum++;
      keyX=append(keyX, x);
      keyY=append(keyY, y);
      set(x/60, y/60, "h", 1);
      keySound.stop();
      keySound.play();
    }
  }
}

public void key(int num, float x, float y) {
  int[] frames = {0, 1, 2, 3, 3, 4, 4, 4, 3, 3, 2, 1, 0, 5, 6, 7, 7, 8, 8, 8, 7, 7, 6, 5};
  int frame = 0;
  int frameC = (frameCount/2)%frames.length;
  float reFrame = frameCount;
  frame=frames[frameC];
  image(keyImg.get((frame%9)*60, 0, 60, 60), round(x-scrollX)+2, round(y-scrollY)+2+(sin(reFrame/10)*5));
}

public void boo(int num, float x, float y) {
  int frame = floor(frameCount*0.6);
  image(ghostFly.get((frame%19)*(660/5), 0, (660/5), 106), x-scrollX, y-scrollY);
}

public void flower(int x, int y) {
  pushMatrix();
  translate(x+32-scrollX, y+16-scrollY);
  float frame = frameCount;
  rotate(radians(sin(frame/15)*60));
  image(flower.get((floor(x/64)%3)*44, 0, 44, 44), -22, -22);
  popMatrix();
}

public void flower(String i, int x, int y) {
  pushMatrix();
  translate(x+32-(round(titleX*4)%width), y+16);
  float frame = titleX;
  rotate(radians(sin(frame/15)*60));
  image(flower.get((floor(x/64)%3)*44, 0, 44, 44), -22, -22);
  popMatrix();
}

public void chainChomp(int x, int y) {
  int ultimateFrame = floor(frameCount/1.5);
  float x1 = levelData.get(floor(x/64)+","+floor(y/64)+"x");
  float y1 = levelData.get(floor(x/64)+","+floor(y/64)+"y");
  if (ultimateFrame%240 < 160) {
    levelData.set(floor(x/64)+","+floor(y/64)+"x", (abs(20-(ultimateFrame%40))-10)*4);
    float frame = ultimateFrame;
    levelData.set(floor(x/64)+","+floor(y/64)+"y", -abs(sin((frame/10)*PI))*15);
    if (int((ultimateFrame%20)*0.6) == 3) {
      chainChompChompSound.stop();
      chainChompChompSound.play();
    }
  } else if (ultimateFrame%240 == 160) {
    levelData.set(floor(x/64)+","+floor(y/64)+"a", atan2((charY+(charH/2))-(y+y1), (charX+(charW/2))-(x+x1)));
    int d = -1;
    if (charX+(charW/2) < x+x1) {
      d=1;
    }
    levelData.set(floor(x/64)+","+floor(y/64)+"f", d);
    chainChompBarkSound.stop();
    chainChompBarkSound.play();
  } else if (ultimateFrame%240 <= 180) {
    float frame = ultimateFrame;
    levelData.set(floor(x/64)+","+floor(y/64)+"d", ((frame%240)-160)/20);
  } else if (ultimateFrame%240 >= 220) {
    float frame = ultimateFrame;
    levelData.set(floor(x/64)+","+floor(y/64)+"d", (20-((frame%240)-220))/20);
    if (int((ultimateFrame%20)*0.6) == 3) {
      chainChompChompSound.play();
    }
  } else {
    if (int((ultimateFrame%20)*0.6) == 3) {
      chainChompChompSound.play();
    }
  }
  x1 = levelData.get(floor(x/64)+","+floor(y/64)+"x");
  y1 = levelData.get(floor(x/64)+","+floor(y/64)+"y");
  float x2 = angle(X, 0, 0, levelData.get(floor(x/64)+","+floor(y/64)+"d")*700, levelData.get(floor(x/64)+","+floor(y/64)+"d")*700, levelData.get(floor(x/64)+","+floor(y/64)+"a"));
  float y2 = angle(Y, 0, 0, levelData.get(floor(x/64)+","+floor(y/64)+"d")*700, levelData.get(floor(x/64)+","+floor(y/64)+"d")*700, levelData.get(floor(x/64)+","+floor(y/64)+"a"));
  for (int i = 0; i < 4; i++) {
    image(chainChompChainLink, (x+32)+(((x1+x2)/5)*(i+1))-23-scrollX, (y+32)+(((y1+y2)/5)*(i+1))-23-scrollY);
  }
  image(chainChompStake, x+32-(chainChompStake.width/2)-scrollX, y+64-chainChompStake.height-scrollY);
  pushMatrix();
  translate(int(x+x1-scrollX+32), int(y+y1-scrollY-5));
  if (ultimateFrame%240 < 160) {
    if (ultimateFrame%40 < 20) {
      scale(1, 1);
    } else {
      scale(-1, 1);
    }
  } else {
    rotate(levelData.get(floor(x/64)+","+floor(y/64)+"a")-PI);
    translate(-levelData.get(floor(x/64)+","+floor(y/64)+"d")*350, 0);
    rotate(-(levelData.get(floor(x/64)+","+floor(y/64)+"a")-PI));
    scale(levelData.get(floor(x/64)+","+floor(y/64)+"f"), 1);
  }
  image(chainChomp.get(int((ultimateFrame%20)*0.6)*160, 0, 160, 160), -80, -80);
  popMatrix();
  if (charX+charW > x-38+x1+x2 && charX < x+98+x1+x2 && charY+charH > y-78+y1+y2 && charY < y+38+y1+y2) {
    die(charX+(charW/2)-scrollX, charY+(charH/2)-scrollY);
  }
}

public void gameKeyPress() {
  for (int i = 0; i < keyCodes.length; i++) {
    if (keyCode == keyCodes[i]) {
      keys[i] = true;
      keyPress[i] = true;
    }
  }
}

public void gameKeyRelease() {
  for (int i = 0; i < keyCodes.length; i++) {
    if (keyCode == keyCodes[i] && keys[i] == true) {
      keys[i] = false;
      //pkeys[i] = false;
    }
  }
}
