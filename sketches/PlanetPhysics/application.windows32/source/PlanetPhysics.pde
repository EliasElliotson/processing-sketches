Planet[] planets;
Player player;
float camR = 0;
PShape planet_big;
boolean[] keys = {false, false, false};

void setup() {
  size(900, 600, P3D);
  surface.setTitle("Planet Physics test");

  textureWrap(REPEAT);
  smooth(0);
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

void draw() {
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

void keyPressed() {
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

void keyReleased() {
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
