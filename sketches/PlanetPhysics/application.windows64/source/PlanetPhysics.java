import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PlanetPhysics extends PApplet {

Planet[] planets;
Player player;
float camR = 0;
PShape planet_big;
boolean[] keys = {false, false, false};

public void setup() {
  
  surface.setTitle("Planet Physics test");

  textureWrap(REPEAT);
  
  planet_big = loadShape(dataPath("models/planet_big/planet_big.obj"));
  
  // Load Reid assets
  reidHead = loadImage("images/reid/head.png");
  reidBody = loadImage("images/reid/body.png");
  reidHand1 = loadImage("images/reid/hand1.png");
  reidHand2 = loadImage("images/reid/hand2.png");
  reidShoe = loadImage("images/reid/shoe.png");

  // Define the classes
  planets = new Planet[4];
  planets[0] = new Planet(0, 0, 100);
  planets[1] = new Planet(350, -85, 150);
  planets[2] = new Planet(400, -500, 200);
  planets[3] = new Planet(0, 750, 1000);
  player = new Player(0, -100, 50);
  player.loadAnimation();
}

public void draw() {
  background(10, 10, 25);

  // Update the stuff
  player.update();
  for (int i = 0; i < planets.length; i++) {
    player.apply(planets[i]);
  }

  camera(0, 0, 700, 0, 0, 0, 0, 1, 0);
  lights();
  scale(2);
  // Draw the stuff
  pushMatrix();
  rotate(camR);
  translate(-player.x, -player.y);
  for (int i = 0; i < planets.length; i++) {
    planets[i].draw();
  }
  player.draw();
  popMatrix();

  /*
  pushMatrix();
   scale(25);
   shape(planet_grassy);
   popMatrix();
   */
}

public void keyPressed() {
  if (keyCode == LEFT && !keys[0]) {
    keys[0]=true;
  }
  if (keyCode == RIGHT && !keys[1]) {
    keys[1]=true;
  }
  if (keyCode == UP && !keys[2]) {
    keys[2]=true;
  }
}

public void keyReleased() {
  if (keyCode == LEFT && keys[0]) {
    keys[0]=false;
  }
  if (keyCode == RIGHT && keys[1]) {
    keys[1]=false;
  }
  if (keyCode == UP && keys[2]) {
    keys[2]=false;
  }
}
public float angle(float x1, float y1, float x2, float y2) {
  return radians(360-((degrees(atan2((x2-x1), (y2-y1)))+270)%360));
}

char X = 0;
char Y = 1;

public float angle(char i1, float x, float y, float w, float h, float i2) {
  float i = 0;
  if (i1 == X) {
    i = x+(cos(i2)*(w/2));
  } else if (i1 == Y) {
    i = y+(sin(i2)*(h/2));
  }
  return i;
}
class Planet {
  float x; // the x of center of gravity
  float y; // the y of center of gravity
  float r; // the radius of the planet
  float gravityDistance = 125; // how close until the gravity controls you
  
  Planet(float nx, float ny, float nr) {
    x=nx; // define the x center
    y=ny; // define the y center
    r=nr; // define the radius
  }
  
  public void draw() {
    /*
    noStroke();
    fill(#D68B30);
    pushMatrix();
    translate(x, y);
    sphere(r/2);
    popMatrix();
    */
    pushMatrix();
    translate(x, y);
    scale(r/2);
    shape(planet_big);
    popMatrix();
    
  }
}
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
  float speed = 0.02f; // speed
  float accel = 0;
  float jumpHeight = 22; // the power put into the player's jump
  boolean touching = false; // is the player touching a planet
  float curPlanetRadius = 0; // current planet's radius
  float maxSpeed = 0.25f;
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

  public void loadAnimation() {
    animation = new ReidAnimation(reidHead, reidBody, reidHand1, reidHand2, reidShoe);
  }

  public void update() {
    a = angle(x, y, gravityX, gravityY); // Calculate the direction to the planet
    float bonus = 0;
    if (gravity < 0) {
      bonus = PI;
    }
    float xDir = angle(X, 0, 0, abs(gravity), abs(gravity), a+bonus);
    float yDir = angle(Y, 0, 0, abs(gravity), abs(gravity), a+bonus);
    if (dist(a, 0, drawAngle, 0) < 0.2f) {
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
      animation.setRunning(abs(accel)>0.1f);
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

  public void draw() {
    pushMatrix();
    translate(x, y);
    rotateZ(drawAngle-HALF_PI);
    image(animation.toImage(), -r/2, -((1.585714f)*r)+r/2, r, (1.585714f)*r);
    popMatrix();
  }

  public void apply(Planet p) {
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

  public PImage toImage() {
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
        if (footAnimation%9 < 4.5f) {
          return prerenderIdle;
        } else {
          return prerenderRun;
        }
      }
    }
  }

  public void prerender() {
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

  public void draw() {
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
        if (footAnimation%9 < 4.5f) {
          image(prerenderIdle, 0, 0);
        } else {
          image(prerenderRun, 0, 0);
        }
      }
    }
  }

  public void update() {
    float headSpeed = 1;
    float handSpeed = 1;
    float footSpeed = 0;
    float rightArmSpeed = 15;
    if (jumping) {
      headSpeed=0.5f;
      handSpeed=0;
      rightArm+=rightArmSpeed;
      if (abs(sin(((footAnimation+5)*PI)/9)) >= 0.1f) {
        footSpeed = 0.5f;
      }
    } else {
      if (running) {
        headSpeed = 3;
        handSpeed = 3;
        footSpeed = 0.5f;
      } else if (degrees(abs(sin((footAnimation*PI)/9))) >= 0.1f) {
        footSpeed = 0.5f;
      }
      rightArm-=rightArmSpeed;
    }
    rightArm=max(min(rightArm, 100), 0);
    headAnimation+=headSpeed;
    handAnimation+=handSpeed;
    footAnimation+=footSpeed;
    footAnimation=footAnimation%9;
  }

  public void setRunning(boolean r) {
    running=r;
  }

  public void setJumping(boolean r) {
    jumping=r;
  }

  public void setPrerender(boolean r) {
    usePrerender=r;
  }
}
  public void settings() {  size(900, 600, P3D);  smooth(0); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "PlanetPhysics" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
