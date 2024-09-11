import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SMB_in_NSMBW extends PApplet {



CustomMusic songs;
SFXLib sfx;

CharacterGraphics mainChar;

Mushroom mush;

public void setup() {
  //
  
  surface.setTitle("Super Mario Bros. in New Super Mario Bros. Wii");
  
  // Load songs
  songs = new CustomMusic(4);
  songs.addSong(0, musicPath("Overworld.aif"));
  songs.addSong(1, musicPath("Overworld2.aif"));
  songs.addSong(2, musicPath("Athletic.aif"));
  songs.addSong(3, musicPath("Athletic2.aif"));
  songs.start(0);
  
  // Load sfx
  sfx = new SFXLib();
  sfx.add("Jump", sfxPath("jump.wav"));
  sfx.add("Powerup", sfxPath("powerup.wav"));
  sfx.add("Swim", sfxPath("swim.wav"));
  
  // Setup character
  mainChar = new CharacterGraphics(charModsPath("Mario.png"));
  
  loadPowerups();
  
  mush = new Mushroom();
  
  loadHud();
  
  loadBackgrounds();
  
  loadTilesets();
  loadTileset(levels[level]);
}

public void draw() {
  drawBackgrounds("Overworld", 0, 0);
  updateCharacter();
  drawLevel();
  mush.draw(200, 200);
  mainChar.draw(charX, charY, state, charFrame, direction);
  //rotHB(mouseX, mouseY, 100, 100, 45, 20);
  //rotHB(mouseX-100, mouseY+100, 100, -100, 45, 20);
  drawHud();
}

public void keyPressed() {
  gameKeyPress();
}

public void keyReleased() {
  gameKeyRelease();
}

public void mouseClicked() {
  String k = "";
  for (int x = 0; x < levels[level][floor(mouseY/64)].length(); x++) {
    if (x == floor(mouseX/64)) {
      k=k+"g";
    } else {
      k=k+str(levels[level][floor(mouseY/64)].charAt(x));
    }
  }
  levels[level][floor(mouseY/64)]=k;
  loadTileset(levels[level]);
}
public class SFXLib {
  SoundFile[] sfx;
  IntDict sfxN;
  SFXLib() {
    sfxN = new IntDict();
    sfx = songArray(0);
  }
  public void add(String id, String path) {
    sfxN.set(id, sfx.length);
    SoundFile[] nsfxa = songArray(sfx.length+1);
    for (int i = 0; i < sfx.length; i++) {
      nsfxa[i] = sfx[i];
    }
    nsfxa[sfx.length] = song(path);
    sfx=nsfxa;
  }
  public void play(String id) {
    sfx[sfxN.get(id)].play();
  }
}
public class CustomMusic {
  SoundFile[] songs;
  CustomMusic(int numSongs) {
    songs = songArray(numSongs);
  }
  public void addSong(int num, String path) {
    songs[num] = song(path);
  }
  public void start(int num) {
    songs[num].loop();
  }
  public void stop(int num) {
    songs[num].stop();
  }
}

public SoundFile[] songArray(int i) {
  return new SoundFile[i];
}

public SoundFile song(String path) {
  return new SoundFile(this, path);
}

public String musicPath(String i) {
  return dataPath("audio/music/"+i);
}
public String sfxPath(String i) {
  return dataPath("audio/sfx/"+i);
}
public String fontPath(String i) {
  return dataPath("graphics/font/"+i);
}
public Background overworld;
public Background beach;

public void loadBackgrounds() {
  // Load overworld
  overworld = new Background();
  overworld.loadBackground(backgroundsPath("overworld"), 1088, 704);
}

public void drawBackgrounds(String t, float x, float y) {
  if (t == "Overworld") {
    overworld.drawBackground(x, y);
  }
}

public String backgroundsPath(String s) {
  return dataPath("graphics/backgrounds/"+s);
}

public PImage stackHorizonal(PImage img, int num) {
  PGraphics img2;
  img2=createGraphics(img.width*num, img.height);
  img2.beginDraw();
  for (int i = 0; i < num; i++) {
    img2.image(img, i*img.width, 0);
  }
  img2.endDraw();
  return img2;
}

public PImage stackFull(PImage img, int num) {
  PGraphics img2;
  img2=createGraphics(img.width*num, img.height*num);
  img2.beginDraw();
  for (int i = 0; i < num; i++) {
    for (int j = 0; j < num; j++) {
      img2.image(img, i*img.width, j*img.height);
    }
  }
  img2.endDraw();
  return img2;
}

public class Background {
  PImage bgGrad;
  PImage[] layers;
  int layerFormatType;
  String layerFormat;
  
  Background() {}
  
  // Load background
  public void loadBackground(String path, int w, int h) {
    bgGrad = resizeImage(loadImage(path+"/gradient.png"), w, h);
    String[] data = loadStrings(path+"/format.dat");
    layers = new PImage[PApplet.parseInt(data[1])];
    layerFormatType = PApplet.parseInt(data[0]);
    layerFormat = data[2];
    if (layerFormatType == 1) {
      for (int i = 0; i < layers.length; i++) {
        PImage layer = loadImage(path+"/layer"+(i+1)+".png");
        int repeat = 0;
        for (int k = 0; k < width*2; k+=layer.width) {
          repeat++;
        }
        repeat = max(repeat, 2);
        layer = stackHorizonal(layer, repeat);
        layers[i] = layer;
      }
    }
    if (layerFormatType == 2) {
      for (int i = 0; i < layers.length; i++) {
        PImage layer = loadImage(path+"/layer"+(i+1)+".png");
        int repeat = 0;
        for (int k = 0; k < width*2; k+=layer.width) {
          repeat++;
        }
        repeat = max(repeat, 2);
        layer = stackHorizonal(layer, repeat);
        layers[i] = layer;
      }
    }
  }
  
  // Draw background
  public void drawBackground(float x, float y) {
    background(bgGrad);
    if (layerFormatType == 1) {
      for (int i = 0; i < layers.length; i++) {
        PImage layer = layers[i];
        int format = PApplet.parseInt(str(layerFormat.charAt(i)));
        int multiplier = layers.length-i;
        if (format == 0) {
          image(layer.get(PApplet.parseInt((x/multiplier)%width), 0, width, layer.height), 0, PApplet.parseInt(-(y/multiplier)));
        }
        if (format == 1) {
          image(layer.get(PApplet.parseInt((x/multiplier)%width), 0, width, layer.height), 0, PApplet.parseInt(height-(y/multiplier)-layer.height));
        }
      }
    }
  }
}
public PImage resizeImage(PImage img, int w, int h) {
  PGraphics img2;
  img2=createGraphics(w, h);
  img2.beginDraw();
  img2.image(img, 0, 0, w, h);
  img2.endDraw();
  return img2;
}

public PImage timeIcon;
public PImage[] hudnums;

public void loadHud() {
  
  // Time icon
  PGraphics time = createGraphics(45, 45);
  int tx = 2;
  int ty = -2;
  time.beginDraw();
  time.strokeCap(ROUND);
  time.fill(255);
  time.stroke(0);
  time.strokeWeight(3);
  time.ellipse(22.5f, 22.5f, 42, 42);
  time.strokeCap(SQUARE);
  time.strokeWeight(5);
  time.line(22.5f-tx, 24.5f-ty, 22.5f-tx, 5-ty);
  time.line(20-tx, 22.5f-ty, 35-tx, 22.5f-ty);
  time.endDraw();
  timeIcon=time;
  
  // HudNum font
  hudnums = new PImage[31];
  PImage temp = loadImage(fontPath("hudnum.png"));
  //93x106
  for (int i = 1; i < 32; i++) {
    hudnums[i-1]=resizeImage(temp.get(((i%5)*94)+1, (floor(i/5)*106)+1, 93, 105), 40, 45);
  }
}

public void drawHud() {
  
  // Time
  String i = "00"+str(ceil(time));
  i=str(i.charAt(i.length()-3))+str(i.charAt(i.length()-2))+str(i.charAt(i.length()-1));
  drawNum(i, width-(i.length()*30)-10, 10);
  image(timeIcon, width-(i.length()*30)-60, 10);
  
  // Pts
  i = "00000000"+str(points);
  i=str(i.charAt(i.length()-9))+str(i.charAt(i.length()-8))+str(i.charAt(i.length()-7))+str(i.charAt(i.length()-6))+str(i.charAt(i.length()-5))+str(i.charAt(i.length()-4))+str(i.charAt(i.length()-3))+str(i.charAt(i.length()-2))+str(i.charAt(i.length()-1));
  drawNum(i, width-(i.length()*30)-170, 10);
}

public void drawNum(String n, float x, float y) {
  String k = n;
  // 15
  for (int i = 0; i < k.length(); i++) {
    image(hudnums[15+PApplet.parseInt(str(k.charAt(i)))], round(x)+(i*30)-5, round(y));
  }
}
public int level = 0;
public PImage tiles;
public PImage[] tileset;

public char levelGet(String[] lev, int x, int y) {
  if (x < 0 || x >= lev[0].length() || y < 0 || y >= lev.length) {
    return ' ';
  } else {
    return lev[y].charAt(x);
  }
}

public String tilesPath(String i) {
  return dataPath("graphics/tilesets/"+i);
}

public void loadTilesets() {
  tileset=new PImage[1];
  tileset[0]=loadImage(tilesPath("m1.png"));
}

public PImage tile(int[][] i, PImage tileset) {
  int x = 7;
  int y = 7;
  if (i[0][0] == 1 && i[0][1] == 1 && i[0][2] == 1 && i[1][0] == 1 && i[1][1] == 1 && i[1][2] == 1 && i[2][0] == 1 && i[2][1] == 1 && i[2][2] == 1) {
    x=round(random(1, 4));
    y=1;
  } else if (i[0][1] == 0) {
    y=0;
    if (i[1][0] == 0) {
      x=0;
    } else if (i[1][2] == 0) {
      x=5;
    } else {
      x=round(random(1, 4));
    }
  } else if (i[2][1] == 0) {
    y=5;
    if (i[1][0] == 0) {
      x=0;
    } else if (i[1][2] == 0) {
      x=5;
    } else {
      x=round(random(1, 4));
    }
  } else if (i[1][0] == 0) {
    x=0;
    if (i[0][1] == 0) {
      y=0;
    } else if (i[2][1] == 0) {
      y=5;
    } else {
      y=round(random(1, 4));
    }
  } else if (i[1][2] == 0) {
    x=5;
    if (i[0][1] == 0) {
      y=0;
    } else if (i[2][1] == 0) {
      y=5;
    } else {
      y=round(random(1, 4));
    }
  } else {
    if (i[0][0] == 0) {
      x=7;
      y=0;
    } else if (i[0][2] == 0) {
      x=6;
      y=0;
    } else if (i[2][0] == 0) {
      x=7;
      y=1;
    } else {
      x=6;
      y=1;
    }
  }
  return tileset.get(x*64, y*64, 64, 64);
}

public void loadTileset(String[] lev) {
  PGraphics i = createGraphics(lev[0].length()*64, lev.length*64);
  i.beginDraw();
  for (int y = 0; y < lev.length; y++) {
    for (int x = 0; x < lev[0].length(); x++) {
      if (levelGet(lev, x, y) == 'g') {
        int[][] a = {
          {0,0,0},
          {0,0,0},
          {0,0,0}
        };
        for (int y2 = -1; y2 <= 1; y2++) {
          for (int x2 = -1; x2 <= 1; x2++) {
            if (levelGet(lev, x+x2, y+y2) == 'g') {
              a[y2+1][x2+1]=1;
            }
          }
        }
        i.image(tile(a, tileset[0]), x*64, y*64);
      }
    }
  }
  i.endDraw();
  tiles=i;
}

public String[][] levels = {
  {
  "                 ",
  "                 ",
  "                 ",
  "                 ",
  "                 ",
  "                 ",
  "                 ",
  "                 ",
  "                 ",
  "ggggggggggggggggg",
  "ggggggggggggggggg",
  },
};

public void drawLevel() {
  for (int y = 0; y < levels[level].length; y++) {
    for (int x = 0; x < levels[level][y].length(); x++) {
      if (levels[level][y].charAt(x) == 'g') {
        groundHB(x*64, y*64, 64, 64, 30);
      } else if (levels[level][y].charAt(x) == 'w') {
        waterHB(x*64, y*64, 64, 64);
      }
    }
  }
  image(tiles, 0, 0);
}
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
  
  public void draw(float x, float y) {
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
  
  public void draw(float x, float y, int state, int frame, int direction) {
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
public float speed = 0.25f;
public float slip = 0.375f;
public float maxSpeed = 8;
public float jumpHeight = 15;
public float maxGravity = 15;
public float gravitySpeed = 0.5f;
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
public float time = 300;
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
      speed = 0.25f;
      slip = 0.375f;
      maxSpeed = 15;
    } else {
      speed = 0.25f;
      slip = 0.375f;
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
      int i = (PApplet.parseInt(walkTime%200)/50);
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
    time-=0.02f;
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

public void slopeTHB(float x1, float y1, float x2, float y2, int s) {
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
    if (xPosMove > maxSpeed*(1-(slope/1.75f)) && slope > 0) {
      xPosMove=maxSpeed*(1-(slope/1.75f));
    }
    if (xPosMove < maxSpeed*(-1-(slope/1.75f)) && slope < 0) {
      xPosMove=maxSpeed*(-1-(slope/1.75f));
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
// Returns the preferred side
public int getSide(float x, float y, float w, float h) {

  //Step 1:  Calculate which corners are colliding (of the character and hitbox)
  float corner = -degrees(atan((charX - x) / (charY - y)));
  if (charY >= y) {corner += 180;}
  corner = floor(((corner + 360) % 360)/90) % 4;
  
  //Step 2:  Calculate the coordinates of the corners that are colliding
  //Coordinates of character's corner
  float x1 = charX + charW * floor(corner/2);
  float y1 = charY + charH * floor((3-((corner+1) % 4))/2);
  //Coordinates of hitbox's corner
  float x2 = x + w * floor((3-corner)/2);
  float y2 = y + h * (floor((4-corner)/2) % 2);
 
  //Step 3:  Calculate closest collision exit side
  float collisionAngle = -degrees(atan((x1 - x2)/(y1 - y2)));
  if (y1 >= y2) {collisionAngle += 180;}
  collisionAngle = floor(((collisionAngle + 360) % 360)/45);
  
  //Step 4:  Return the optimal exit side (0 = up, 1 = right, 2 = down, 3 = left)
  int[] optimalSide = {3,2,0,3,1,0,2,1};    //Stores the optimal sides to return for the function calculation
  return optimalSide[PApplet.parseInt(collisionAngle)];
  
}
  public void settings() {  size(1088, 704); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SMB_in_NSMBW" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
