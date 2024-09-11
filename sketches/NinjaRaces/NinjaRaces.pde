import processing.sound.*;

PImage overworld;
PImage ninja;
PImage title;
PImage pressStart;
PImage game1;
PImage game2;
PImage game3;
PImage select;
PShape background;
PFont load;
float scrollX = 0;
float scrollY = 0;
String scene = "Load";

void setup() {
  size(960, 640);
  background = loadShape("title/bg.svg");
  title = loadImage("title/title.png");
  load = createFont("font/font.ttf", 35);
}

void draw() {
  if (scene == "Load") {
    shape(background, 0, 0, width, height);
    image(title, (width-title.width)/2, (height-title.height)/2);
    if (frameCount >= 1) {
      textFont(load);
      fill(255);
      textAlign(CENTER, CENTER);
      text("Loading shaders "+(frameCount-1)+"/"+shaders, width/2, 550);
    }
    if (frameCount == shaders+2) {
      scene="Title";
    } else if (frameCount >= 2) {
      loadShaders(frameCount-2);
    }
  } else if (scene == "Title") {
    drawTitle();
  } else if (scene == "Play") {
    drawGame();
  }
  for (int i = 0; i < keyPress.length; i++) {
    keyPress[i]=false;
  }
}

void keyPressed() {
  gameKeyPress();
}

void keyReleased() {
  gameKeyRelease();
}
