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
