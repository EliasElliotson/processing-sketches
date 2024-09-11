PImage reidHead;
PImage reidBody;
PImage reidHand1;
PImage reidHand2;
PImage reidShoe;

class Player {
  ReidAnimation animation; // the class storing the animation
  float x; // x of the center of the player
  float y; // y of the center of the player
  float r; // radius of the player
  float gravitySpeed = 1; // the gravity of the player
  float gravity = 0; // the acceleration of the downward force on the player
  float gravityX = 0; // where the gravity is coming from horizonal axis
  float gravityY = 0; // where the gravity is coming from vertical axis
  float speed = 0.02; // speed
  float accel = 0;
  float jumpHeight = 22; // the power put into the player's jump
  boolean touching = false; // is the player touching a planet
  float curPlanetRadius = 0; // current planet's radius
  float maxSpeed = 0.25;
  float planetCount = 0; // number of planets detected
  float drawAngle = 0;
  boolean switchingPlanets = false;
  float a = 0;

  Player(float nx, float ny, float nr) {
    x=nx; // define the x position
    y=ny; // define the y position
    r=nr; // define the radius
  }

  Player(float nx, float ny, float nr, float ngravity) {
    x=nx; // define the x position
    y=ny; // define the y position
    r=nr; // define the radius
    gravity=ngravity; // redefine the gravity
  }

  void loadAnimation() {
    animation = new ReidAnimation(reidHead, reidBody, reidHand1, reidHand2, reidShoe);
  }

  void update() {
    a = angle(x, y, gravityX, gravityY); // Calculate the direction to the planet
    float bonus = 0;
    if (gravity < 0) {
      bonus = PI;
    }
    float xDir = angle(X, 0, 0, abs(gravity), abs(gravity), a+bonus);
    float yDir = angle(Y, 0, 0, abs(gravity), abs(gravity), a+bonus);
    if (dist(a, 0, drawAngle, 0) < 0.2) {
      gravity+=gravitySpeed;
      x+=xDir;
      y+=yDir;
      if (touching && keys[2]) {
        gravity=-jumpHeight;
      }
      animation.setJumping(dist(x, y, gravityX, gravityY)>=(curPlanetRadius/2)+(r/2)+5);
      touching=false;
      animation.update();
    }

    if (!switchingPlanets) {
      if (keys[0]) {
        accel-=speed;
      } else if (keys[1]) {
        accel+=speed;
      } else {
        if (accel > 0) {
          accel-=min(speed, abs(accel));
        } else if (accel < 0) {
          accel+=min(speed, abs(accel));
        }
      }
      if (abs(accel) > maxSpeed) {
        if (accel > 0) {
          accel=maxSpeed;
        } else if (accel < 0) {
          accel=-maxSpeed;
        }
      }
      animation.setRunning(abs(accel)>0.1);
      a = angle(x, y, gravityX, gravityY); // Calculate the direction to the planet
      float angleDifference = radians((accel/dist(x, y, gravityX, gravityY)*PI)*360);

      xDir = angle(X, 0, 0, dist(x, y, gravityX, gravityY)*2, dist(x, y, gravityX, gravityY)*2, a+angleDifference+PI);
      yDir = angle(Y, 0, 0, dist(x, y, gravityX, gravityY)*2, dist(x, y, gravityX, gravityY)*2, a+angleDifference+PI);
      x=xDir+gravityX;
      y=yDir+gravityY;
      planetCount=0;
    }
    if (switchingPlanets) {
      animation.setRunning(false);
      animation.setJumping(true);
      drawAngle+=(a-drawAngle)/12;
    } else {
      drawAngle=a;
    }
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    rotateZ(drawAngle-HALF_PI);
    image(animation.toImage(), -r/2, -((1.585714)*r)+r/2, r, (1.585714)*r);
    popMatrix();
  }

  void apply(Planet p) {
    if (dist(this.x, this.y, p.x, p.y) <= (p.r/2)+p.gravityDistance+(this.r/2)) {
      if (p.x != this.gravityX || p.y != this.gravityY) {
        animation.setRunning(false);
        animation.setJumping(true);
        if (switchingPlanets == false && gravity > 0) {
          switchingPlanets=true;
          gravityX=p.x;
          gravityY=p.y;
          curPlanetRadius=p.r;
          gravity=0;
          accel=0;
          touching=false;
          //curPlanetRadius=p.r;
        }
      }
      curPlanetRadius=p.r;
      planetCount++;
      if (dist(this.x, this.y, p.x, p.y) <= (p.r+this.r)/2) {
        float d = (this.r+p.r)/2 - dist(this.x, this.y, p.x, p.y);
        float a = angle(x, y, gravityX, gravityY); // Calculate the direction to the planet
        float xDir = angle(X, 0, 0, d, d, a+PI);
        float yDir = angle(Y, 0, 0, d, d, a+PI);
        x+=xDir;
        y+=yDir;
        gravity=-gravitySpeed;
        touching=true;
        switchingPlanets=false;
      }
    }
  }
}

class ReidAnimation {
  PImage head;
  PImage body;
  PImage hand1;
  PImage hand2;
  PImage shoe;

  PImage prerenderIdle;
  PImage prerenderRun;
  PImage prerenderJump;

  float headAnimation = 0;
  float handAnimation = 0;
  float footAnimation = 0;
  float rightArm = 0;
  
  int direction = 1;

  boolean running = false;
  boolean jumping = false;

  boolean usePrerender = false;

  ReidAnimation(PImage nhead, PImage nbody, PImage nhand1, PImage nhand2, PImage nshoe) {
    head=nhead;
    body=nbody;
    hand1=nhand1;
    hand2=nhand2;
    shoe=nshoe;
  }

  PImage toImage() {
    if (!usePrerender) {
      PGraphics g = createGraphics(210, 333);
      g.beginDraw();
      // Start translate
      g.pushMatrix();
      g.translate(110, 226);

      // Arm2
      g.pushMatrix();
      g.translate(-15, -41);
      g.rotate(radians(10+rightArm)+abs(sin(handAnimation/20))/4);
      g.image(hand2, -43, -3);
      g.popMatrix();

      // Shoe2
      g.pushMatrix();
      g.translate(-5, 16);
      g.rotate(abs(sin(footAnimation/3))*1);
      g.image(shoe, -45, 28);
      g.popMatrix();

      // Body
      g.image(body, -(body.width/2), -(body.height/2));

      // Head
      g.pushMatrix();
      g.translate(-2, -48);
      g.rotate(sin(headAnimation/30)/15);
      g.image(head, -69, -178);
      g.popMatrix();

      // Shoe1
      g.pushMatrix();
      g.translate(15, 21);
      g.rotate(-abs(sin(footAnimation/3))*1);
      g.image(shoe, -45, 28);
      g.popMatrix();

      // Arm1
      g.pushMatrix();
      g.translate(23, -47);
      g.rotate(radians(-20)-abs(sin(handAnimation/20))/4);
      g.image(hand1, -32, -2);
      g.popMatrix();

      // End translate
      g.popMatrix();
      g.endDraw();
      return g;
    } else {
      if (jumping) {
        return prerenderJump;
      } else {
        if (footAnimation%9 < 4.5) {
          return prerenderIdle;
        } else {
          return prerenderRun;
        }
      }
    }
  }

  void prerender() {
    float headAnimationTemp = headAnimation;
    float handAnimationTemp = handAnimation;
    float footAnimationTemp = footAnimation;
    float rightArmTemp = rightArm;
    headAnimation=0;
    handAnimation=0;
    footAnimation=0;
    rightArm=0;
    prerenderIdle=this.toImage();
    headAnimation=15;
    handAnimation=15;
    footAnimation=5;
    rightArm=0;
    prerenderRun=this.toImage();
    rightArm=100;
    footAnimation=5;
    headAnimation=0;
    handAnimation=25;
    prerenderJump=this.toImage();
    headAnimation=headAnimationTemp;
    handAnimation=handAnimationTemp;
    footAnimation=footAnimationTemp;
    rightArm=rightArmTemp;
  }

  void draw() {
    if (!usePrerender) {
      // Start translate
      pushMatrix();
      translate(110, 226);

      // Arm2
      pushMatrix();
      translate(-15, -41);
      rotate(radians(10+rightArm)+abs(sin(handAnimation/20))/4);
      image(hand2, -43, -3);
      popMatrix();

      // Shoe2
      pushMatrix();
      translate(-5, 16);
      rotate(abs(sin((footAnimation*PI)/9))*1);
      image(shoe, -45, 28);
      popMatrix();

      // Body
      image(body, -(body.width/2), -(body.height/2));

      // Head
      pushMatrix();
      translate(-2, -48);
      rotate(sin(headAnimation/30)/15);
      image(head, -69, -178);
      popMatrix();

      // Shoe1
      pushMatrix();
      translate(15, 21);
      rotate(-abs(sin((footAnimation*PI)/9))*1);
      image(shoe, -45, 28);
      popMatrix();

      // Arm1
      pushMatrix();
      translate(23, -47);
      rotate(radians(-20)-abs(sin(handAnimation/20))/4);
      image(hand1, -32, -2);
      popMatrix();

      // End translate
      popMatrix();
    } else {
      if (jumping) {
        image(prerenderJump, 0, 0);
      } else {
        if (footAnimation%9 < 4.5) {
          image(prerenderIdle, 0, 0);
        } else {
          image(prerenderRun, 0, 0);
        }
      }
    }
  }

  void update() {
    float headSpeed = 1;
    float handSpeed = 1;
    float footSpeed = 0;
    float rightArmSpeed = 15;
    if (jumping) {
      headSpeed=0.5;
      handSpeed=0;
      rightArm+=rightArmSpeed;
      if (abs(sin(((footAnimation+5)*PI)/9)) >= 0.1) {
        footSpeed = 0.5;
      }
    } else {
      if (running) {
        headSpeed = 3;
        handSpeed = 3;
        footSpeed = 0.5;
      } else if (degrees(abs(sin((footAnimation*PI)/9))) >= 0.1) {
        footSpeed = 0.5;
      }
      rightArm-=rightArmSpeed;
    }
    rightArm=max(min(rightArm, 100), 0);
    headAnimation+=headSpeed;
    handAnimation+=handSpeed;
    footAnimation+=footSpeed;
    footAnimation=footAnimation%9;
  }

  void setRunning(boolean r) {
    running=r;
  }

  void setJumping(boolean r) {
    jumping=r;
  }

  void setPrerender(boolean r) {
    usePrerender=r;
  }
}
