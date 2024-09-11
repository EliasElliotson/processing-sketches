public int level = 0;
public PImage tiles;
public PImage[] tileset;

public float waterY = 100;
public int waterA = 100;

public class Water {
  boolean pswim = false;
  float[] ys = {};
  float[] yse = {};
  float k = 40;
  Water(int width) {
    for (int i = 0; i < width+k; i+=k) {
      ys=append(ys, sin(i/10)*5);
      yse=append(yse, 0);
    }
  }
  
  void draw(int y) {
    float frame = frameCount;
    strokeWeight(2);
    stroke(200, 225, 255, 150);
    fill(0, 50, 255, 100);
    beginShape();
    curveVertex(-100, y);
    for (float i = 0; i < width+k; i+=k) {
      yse[min(floor(i/k), ys.length-1)]--;
      yse[floor(i/k)]=max(yse[floor(i/k)], 0);
      curveVertex(i, y+((ys[floor(i/k)]+yse[floor(i/k)])*sin(frame/10)));
    }
    curveVertex(width+100, y);
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
    waterHB(0, y+15, width, height-y+32);
    if (pswim != swimming) {
      impact(int(charX+(charW/2)), 75);
    }
    pswim=swimming;
  }
  
  void impact(int x, int s) {
    for (int i = 0; i < width+k; i+=k) {
      yse[floor(i/k)]=max(s-dist(0, x, 0, i), 0)+min(yse[floor(i/k)], 100);
    }
  }
}

public Water water;

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

public String tilesPath(String i) {
  return dataPath("graphics/tilesets/"+i);
}

public void loadTilesets() {
  tileset=new PImage[2];
  tileset[1]=loadImage(tilesPath("m1.png"));
  tileset[0]=loadImage(tilesPath("m2.png"));
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
        i.image(tile(a, tileset[1]), x*64, y*64);
      }
    }
  }
  i.endDraw();
  tiles=i;
  water = new Water(1088);
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
  "                 ",
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
  water.draw(height-round(waterY));
}
