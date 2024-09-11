/* @pjs preload="./data/title/bg.svg","file2.png","file3.jgp"; */

public int level = 0;
public PImage tiles;
public PImage[] tileset;
public PImage bowserCheckpoint;
public PImage marioCheckpoint;
//public PImage bowserHitCheckpoint;
public PImage marioHitCheckpoint;
public PImage regularSign;
public PImage regularCoin;
public PImage coinEffect1;
public PImage spike;
public PImage bush;
public PImage stem;
public PImage flower;
public PImage chainChomp;
public PImage chainChompStake;
public PImage chainChompChainLink;
public PImage block1;
public PImage block2;
public PImage keyImg;
public PImage ghostFly;
public PImage ghostHide;
public SoundFile checkpointSound;
public SoundFile coinRegularSound;
public SoundFile dieSound;
public SoundFile downSound;
public SoundFile chainChompBarkSound;
public SoundFile chainChompChompSound;
public SoundFile keySound;
public float checkpointFrame = 0;
public int checkpointX = 0;
public int checkpointY = 0;
public FloatDict levelData;
public Transition1 dieOut;
public Transition2 dieIn;
public float[] keyX = {};
public float[] keyY = {};
public int keyNum = 0;
public float[] ghostX = {};
public float[] ghostY = {};
public float[] ghostH = {};
public float[] ghostD = {};
public float[] goombaX = {};
public float[] goombaY = {};
public float[] goombaG = {};
public float[] goombaD = {};

public PImage[] tilesetImgs;

public char X = 0;
public char Y = 1;

public float get(int x, int y, String t) {
  return levelData.get(x+","+y+t);
}

public void set(int x, int y, String t, float i) {
  levelData.set(x+","+y+t, i);
}

public void loadLevel(String path, int j) {
  String[] level = loadStrings(path);
  int sections = 1;
  String[][] section;
  for (int i = 0; i < level.length; i++) {
    if (level[i].charAt(0) == ';') {
      sections++;
    }
  }
  section = new String[sections][0];
  sections = 0;
  for (int i = 0; i < level.length; i++) {
    if (level[i].charAt(0) == ';') {
      sections++;
    } else {
      section[sections] = append(section[sections], level[i]);
    }
  }
  levels[j] = section[0];
}

public float angle(char i1, float x, float y, float w, float h, float i2) {
  float i = 0;
  if (i1 == X) {
    i = x+(cos(i2)*(w/2));
  } else if (i1 == Y) {
    i = y+(sin(i2)*(h/2));
  }
  return i;
}

public void loadSoundEffects() {
  checkpointSound = new SoundFile(this, "checkpoint/hit.wav");
  coinRegularSound = new SoundFile(this, "coins/regular.wav");
  dieSound = new SoundFile(this, "ninja/die.wav");
  chainChompBarkSound = new SoundFile(this, "chainChomp/bark.wav");
  downSound = new SoundFile(this, "ninja/down.mp3");
  chainChompChompSound = new SoundFile(this, "chainChomp/chomp.wav");
  keySound = new SoundFile(this, "coins/key.wav");
}

public PImage resizeImage(PImage img, int w, int h) {
  PGraphics img2;
  img2=createGraphics(w, h);
  img2.beginDraw();
  img2.image(img, 0, 0, w, h);
  img2.endDraw();
  return img2;
}

public char levelGet(String[] lev, int x, int y) {
  if (x < 0 || x >= lev[0].length() || y < 0 || y >= lev.length) {
    return ' ';
  } else {
    return lev[y].charAt(x);
  }
}

public char levelGet(String[] lev, int x, int y, char k) {
  if (x < 0 || x >= lev[0].length() || y < 0 || y >= lev.length) {
    return k;
  } else {
    return lev[y].charAt(x);
  }
}

public void loadTilesets() {
  tileset=new PImage[3];
  tileset[0]=loadImage("tilesets/overworld.png");
  tileset[1]=loadImage("tilesets/desert.png");
  tileset[2]=loadImage("tilesets/grass.png");
  bowserCheckpoint = loadImage("checkpoint/bowser.png");
  marioCheckpoint = loadImage("checkpoint/mario.png");
  //bowserHitCheckpoint = loadImage("checkpoint/bowserHit.png");
  marioHitCheckpoint = loadImage("checkpoint/marioHit.png");
  regularSign = loadImage("bgItems/regularSign.png");
  regularSign = resizeImage(regularSign, int(regularSign.width*0.75), int(regularSign.height*0.75));
  regularCoin = loadImage("coins/regular.png");
  coinEffect1 = loadImage("coins/effect1.png");
  coinEffect1 = resizeImage(coinEffect1, 1801, 64);
  spike = loadImage("spikes/spike.png");
  bush = loadImage("bgItems/bush.png");
  stem = loadImage("bgItems/stem.png");
  flower = loadImage("bgItems/flowers.png");
  flower = resizeImage(flower, 132, 44);
  chainChomp = loadImage("chainChomp/chomp.png");
  chainChompStake = loadImage("chainChomp/stake.png");
  chainChompChainLink = loadImage("chainChomp/chainLink.png");
  block1 = loadImage("tilesets/block1.png");
  block2 = loadImage("tilesets/block2.png");
  keyImg = loadImage("coins/key.png");
  ghostFly = loadImage("boo/fly.png");
  levelData = new FloatDict();
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
            if (levelGet(lev, x+x2, y+y2, 'g') == 'g') {
              a[y2+1][x2+1]=1;
            }
          }
        }
        i.image(tile(a, tileset[0]), x*64, y*64);
      } else if (levelGet(lev, x, y) == '>') {
        i.image(regularSign, (x*64)+32-(regularSign.width/2), (y*64)+64-regularSign.height);
      } else if (levelGet(lev, x, y) == '^') {
        int t = 0;
        if (levelGet(lev, x-1, y) == '^') {
          t=2;
          if (levelGet(lev, x+1, y) == '^') {
            t=1;
          }
        } else if (levelGet(lev, x+1, y) == '^') {
          t=0;
        }
        i.image(bush.get(t*64, 0, 64, 64), (x*64), (y*64));
      } else if (levelGet(lev, x, y) == 'f') {
        i.image(stem, (x*64)+10, (y*64)+20, 44, 44);
      } else if (levelGet(lev, x, y) == 'b') {
        i.image(block1, (x*64), (y*64), 64, 64);
      } else if (levelGet(lev, x, y) == '=') {
        i.image(block2, (x*64), (y*64), 64, 64);
      }
    }
  }
}

public void setupLevel(String[] lev) {
  for (int y = 0; y < lev.length; y++) {
    for (int x = 0; x < lev[0].length(); x++) {
      if (levelGet(lev, x, y) == 'c') {
        levelData.set(x+","+y+"collected", 0);
        levelData.set(x+","+y+"effectFrame", 0);
      } else if (levelGet(lev, x, y) == 'o') {
        levelData.set(x+","+y+"x", 0);
        levelData.set(x+","+y+"y", 0);
        levelData.set(x+","+y+"a", 0);
        levelData.set(x+","+y+"d", 0);
        levelData.set(x+","+y+"f", -1);
      } else if (levelGet(lev, x, y) == 'K') {
        levelData.set(x+","+y+"h", 0);
      }
    }
  }
}

public String[][] levels;

public void drawGame() {
  updateCharacter();
  background(overworld.get(round(scrollX/2)%(overworld.width-1056), round(scrollY/2), 960, 640));
  scrollX += ((min(max(charX-(width/2), 0), levels[level][0].length()*64-width))-scrollX)/6;
  if (charY+(charH/2) < height) {
    scrollY += ((min(max(charY-(height/2), 0), levels[level].length*64-height))-scrollY)/15;
  } else {
    scrollY += (height-scrollY)/15;
  }
  image(tilesetImgs[level].get(round(scrollX), round(scrollY), width, height), 0, 0);
  int[] mercy = {7, 7, 7, 7};
  for (int y = max(floor(scrollY/64)-mercy[0], 0); y < min(ceil(scrollY/64)+10+mercy[1], levels[level].length); y++) {
    for (int x = max(floor(scrollX/64)-mercy[2], 0); x < min(ceil(scrollX/64)+15+mercy[3], levels[level][y].length()); x++) {
      if (levels[level][y].charAt(x) == 'g') {
        int bon = x;
        while (levelGet(levels[level], bon+1, y) == 'g') {
          bon++;
        }
        groundHB((x*64)+10, y*64, 64+((bon-x)*64)-20, 64, 30);
      } else if (levels[level][y].charAt(x) == 'b') {
        int bon = x;
        while (levelGet(levels[level], bon+1, y) == 'b') {
          bon++;
        }
        groundHB(x*64, y*64, 64+((bon-x)*64), 64, 30);
      } else if (levels[level][y].charAt(x) == '=') {
        upGroundHB(x*64, y*64, 64, 20);
      } else if (levels[level][y].charAt(x) == 'C') {
        checkpoint(x*64, y*64);
      } else if (levels[level][y].charAt(x) == 'c') {
        coin(x*64, y*64);
      } else if (levels[level][y].charAt(x) == 's') {
        spike(x*64, y*64);
      } else if (levels[level][y].charAt(x) == 'f') {
        flower(x*64, y*64);
      } else if (levels[level][y].charAt(x) == 'o') {
        chainChomp(x*64, y*64);
      } else if (levels[level][y].charAt(x) == 'K') {
        key(x*64, y*64);
      } else if (levels[level][y].charAt(x) == 'G') {
        boo(0, x*64, y*64);
      }
    }
  }
  checkpointFrame++;
  groundHB(-74, -1000, 64, 1000+(levels[level].length*64), 32);
  groundHB((levels[level][0].length()*64)+10, -1000, 64, 1000+(levels[level].length*64), 32);
  
  // Keys
  for (int i = 0; i < keyNum; i++) {
    float x = 0;
    float y = 0;
    if (i == 0) {
      x = charX+(charW/2);
      y = charY+(charH/2);
    } else {
      x = keyX[i-1]+32;
      y = keyY[i-1]+32;
    }
    key(1, keyX[i], keyY[i]);
    if (dist(keyX[i]+32, keyY[i]+32, x, y) > 96) {
      float angle = atan2((keyY[i]+32)-y, (keyX[i]+32)-x);
      float r = max((dist(keyX[i]+32, keyY[i]+32, x, y))-80, 0)/5;
      keyX[i]-=angle(X, 0, 0, r, r, angle);
      keyY[i]-=angle(Y, 0, 0, r, r, angle);
    }
  }
  
  drawCharacter();
  
  drawHud();
  if (time > 0 && dying == false) {
    time-=0.02;
  } else if (dying == false) {
    die(charX+(charW/2)-scrollX, charY+(charH/2)-scrollY);
  }
  if (charY > (levels[level].length*64)+16 && !dying) {
    die("pit", charX+(charW/2)-scrollX, height);
  }
  if (dying) {
    dieOut.draw();
  }
  if (drawDieIn && !dying) {
    dieIn.draw();
  }
}
