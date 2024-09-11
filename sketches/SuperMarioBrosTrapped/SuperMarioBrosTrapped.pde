import processing.sound.*;

Transition3 titleTrans;
Transition1 titleTrans2;
SoundFile shiro_ongaku;
SoundFile chijou_ongaku;
SoundFile chika_ongaku;
SoundFile nintendou_on;
SoundFile koukoku_on;
SoundFile hajimeru_on;
SoundFile oou_ongaku;
PFont kenkou_lighting;
PFont namae_no_kakikata;
PImage rogo_gazou;
PImage chijou_haikei;
PImage chijou_tairu;
PImage chika_haikei;
PImage chika_tairu;
PImage shiro_haikei;
PImage shiro_tairu;
PImage mojio_gazou;
PImage nintendou_rogo;
PImage koukoku_rogo;
PImage hajimeru_kotoba;
PImage[] yougan_gazou;
PImage jizen_leverle_haikei;
PImage[] levelNameImgs;
String scene = "Nintendo";
float themeOfDay = 0;
float preLevelTrans = 0;
boolean titleTransition = false;

void setup() {
  size(912, 528);
  chijou_haikei = loadImage("chijou_haikei.png");
  chijou_tairu = loadImage("chijou_tairu.png");
  chika_haikei = loadImage("chika_haikei.png");
  chika_tairu = loadImage("chika_tairu.png");
  shiro_haikei = loadImage("shiro_haikei.png");
  shiro_tairu = loadImage("shiro_tairu.png");
  nintendou_rogo = loadImage("nintendou_rogo.jpg");
  rogo_gazou = loadImage("rogo_gazou.png");
  hajimeru_kotoba = loadImage("hajimeru_kotoba.png");
  jizen_leverle_haikei = loadImage("jizen_leverle_haikei.png");
  kenkou_lighting = createFont("kenkou_lighting.ttf", 42);
  namae_no_kakikata = createFont("namae_no_kakikata.ttf", 32);
  rogo_gazou = resizeImage(rogo_gazou, int(rogo_gazou.width*0.75), int(rogo_gazou.height*0.75));
  nintendou_on = new SoundFile(this, "nintendou_on.wav");
  koukoku_on = new SoundFile(this, "koukoku_on.wav");
  hajimeru_on = new SoundFile(this, "hajimeru_on.wav");
  oou_ongaku = new SoundFile(this, "oou_ongaku.aif");
  koukoku_rogo = loadImage("koukoku_rogo.jpg");
  yougan_gazou = new PImage[46];
  PImage temp1 = loadImage("yougan_gazou.png");
  for (int i = 0; i < yougan_gazou.length; i++) {
    PImage k = tileImageLeft(temp1.get(i*66, 0, 66, 135), 17);
    int w = k.width;
    int h = k.height;
    yougan_gazou[i] = resizeImage(k, (w/17)*15, (h/17)*15);
  }
  shiro_ongaku = new SoundFile(this, "shiro_ongaku.aif");
  smooth(0);
  mojio_gazou = resizeImage(loadImage("mojio_gazou.png"), 367*3, 134*3);
  setTiles(levels[level], shiro_tairu);
}

void draw() {
  if (scene == "Level") {
    background(shiro_haikei.get(int(scrollX/2)%width, 0, width, height));
    drawLevel();
    drawCharacter();
    updateCharacter();
    hitboxMap(levels[level]);
  } else if (scene == "Prelevel") {
    background(jizen_leverle_haikei);
    textFont(namae_no_kakikata);
    textAlign(CENTER, CENTER);
    fill(255);
    smooth(6);
    text((floor(level/4)+1)+" - "+((level%4)+1), width/2, height/8.85);
    text(levelNames[level], width/2, height/3.65);
    noStroke();
    float trans = 255;
    if (preLevelTrans > 75) {
      trans = ((555/4)-preLevelTrans)*4;
    }
    fill(0, trans);
    rect(0, 0, width, height);
    preLevelTrans++;
  } else if (scene == "Title") {
    if (themeOfDay == 0) {
      float w = chijou_haikei.width;
      background(chijou_haikei.get(int((frameCount)%(w/2)), 0, width, height));
    } else if (themeOfDay == 1) {
      float w = chika_haikei.width;
      background(chika_haikei.get(int((frameCount)%(w/2)), 0, width, height));
    } else {
      float w = shiro_haikei.width;
      background(shiro_haikei.get(int((frameCount)%(w/2)), 0, width, height));
    }
    image(tileset.get((frameCount%24)*2, 0, width, height), 0, 0);
    image(rogo_gazou, int((width-rogo_gazou.width)/2), 48);
    pushMatrix();
    translate(width/2, height-48-48-48);
      int walkPos = floor((frameCount%40)/10);
      if (walkPos == 1) {
        image(mojio_gazou.get(105, 3, 48, 48), -24, 0);
      }
      if (walkPos == 2 || walkPos == 0) {
        image(mojio_gazou.get(156, 3, 48, 48), -24, 0);
      }
      if (walkPos == 3) {
        image(mojio_gazou.get(207, 3, 48, 48), -24, 0);
      }
    popMatrix();
    if (frameCount%100 < 50) {
      image(hajimeru_kotoba, (width-hajimeru_kotoba.width)/2, (height/1.1)-42);
    }
    if (titleTrans.s <= 1054) {
      titleTrans.draw();
    }
    titleTrans2.draw();
    oou_ongaku.amp(titleTrans2.s/(dist(0, 0, width, height)*1.25));
    if (titleTransition == false && keys[6] && titleTrans.s > 1054) {
      titleTransition=true;
      hajimeru_on.play();
      titleTrans2.start();
    }
    if (titleTrans2.s <= 0) {
      setPrelevelAsScene();
    }
  } else if (scene == "Nintendo") {
    noStroke();
    float fadeSpeed = 50;
    float freezeTime = 125;
    float frame = frameCount%(freezeTime+(fadeSpeed*5));
    if (frameCount < (freezeTime+(fadeSpeed*5))) {
      background(nintendou_rogo);
      if (frame == 10) {
        nintendou_on.play();
      }
    } else {
      background(koukoku_rogo);
      if (frame == 10) {
        koukoku_on.play();
      }
    }
    if (frame <= fadeSpeed) {
      
    } else if (frame > fadeSpeed && frame < fadeSpeed+freezeTime) {
      frame=fadeSpeed;
    } else {
      frame=((fadeSpeed+freezeTime)*2)-frame;
    }
    fill(0, 255-(frame*(255/fadeSpeed)));
    rect(0, 0, width, height);
    if (frameCount >= (freezeTime+(fadeSpeed*5))*2) {
      setTitleAsScene();
    }
  }
}

void keyPressed() {
  gameKeyPress();
}

void keyReleased() {
  gameKeyRelease();
}

void mouseClicked() {
  if (scene == "Nintendo") {
    setTitleAsScene();
  }
}
