// Initialize the key-input variables
public boolean[] keys = {false, false, false, false, false, false, false}; // Keep track of the keys
public char[] keyCodes = {UP, DOWN, LEFT, RIGHT, CONTROL, SHIFT, ENTER}; // Define key codes (up, down, left, right, a, b, x, y)

// Character variables
public float pcharX = 48;
public float pcharY = 48;
public float charX = 48;
public float charY = 48;
public float charW = 48;
public float charH = 48;
public int charD = 1;
public float gravity = 0;
public float xPosMove = 0;
public float speed = 0.25;
public float slip = 0.375;
public float maxSpeed = 8;
public float jumpHeight = 21;
public float maxGravity = 13;
public float gravitySpeed = 1;
public boolean canJump = false;
public boolean jumping = false;
public boolean canSlipJump = false;
public float walkTime = 0;
public boolean pJumped = true;
public boolean haveJumped = true;

public void drawCharacter() {
  pushMatrix();
  translate((charX+24)-int(scrollX), charY-int(scrollY));
  scale(charD, 1);
  if (!canJump) {
    image(mojio_gazou.get(309, 3, 48, 48), -24, 0);
  } else if (keys[2] && xPosMove > 0 || keys[3] && xPosMove < 0) {
    scale(-1, 1);
    image(mojio_gazou.get(258, 3, 48, 48), -24, 0);
  } else if (walkTime > 0) {
    int walkPos = floor((walkTime%200)/50);
    if (walkPos == 1) {
      image(mojio_gazou.get(105, 3, 48, 48), -24, 0);
    }
    if (walkPos == 2 || walkPos == 0) {
      image(mojio_gazou.get(156, 3, 48, 48), -24, 0);
    }
    if (walkPos == 3) {
      image(mojio_gazou.get(207, 3, 48, 48), -24, 0);
    }
  } else {
    image(mojio_gazou.get(3, 3, 48, 48), -24, 0);
  }
  popMatrix();
}

public void updateCharacter() {
  pcharX = charX;
  pcharY = charY;
  // Gravity
  if (!keys[5] && canJump) {
    pJumped=false;
  }
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
  if (keys[5] && canJump && !pJumped && !haveJumped) {
    gravity=-jumpHeight;
    canJump=false;
    pJumped=true;
    haveJumped = true;
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
    charD=1;
    xPosMove+=speed+slip;
  }
  if (keys[2]) {
    charD=-1;
    xPosMove-=speed+slip;
  }
  if (abs(xPosMove) > speed*3) {
    walkTime+=abs(xPosMove);
  } else {
    walkTime=0;
  }
  
  // Speed run
  if (keys[4]) {
    speed = 0.25;
    slip = 0.25;
    maxSpeed = 12;
  } else {
    speed = 0.25;
    slip = 0.20;
    maxSpeed = 6;
  }
  
  if (!canSlipJump) {
    canJump=false;
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
    if (haveJumped == false) {
      canJump=true;
    }
    if (!keys[5]) {
      haveJumped=false;
    }
    charY=y-charH;
  }
  if (charX > x-charW && charX < x-charW+sens && charY > y-charH && charY < y+h && hb == 3) {
    xPosMove=0;
    charX=x-charW;
  }
  if (charX > x+w-sens && charX < x+w && charY > y-charH && charY < y+h && hb == 1) {
    xPosMove=0;
    charX=x+w;
  }
  if (charY > y+h-sens && charY < y+h && charX > x-charW && charX < x+w && hb == 2) {
    charY=y+h;
    gravity=1;
  }
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
