PImage tileset;

float scrollX = 0;
float scrollY = 0;

int[] tile(int[][] i) {
  int[][] pairs = {{0,7},{0,7},{9,4},{9,4},{0,7},{0,7},{9,4},{9,4},{6,6},{6,6},{6,4},{0,4},{6,6},{6,6},{6,4},{0,4},{8,6},{8,6},{7,4},{7,4},{8,6},{8,6},{2,4},{2,4},{7,6},{7,6},{6,3},{9,0},{7,6},{7,6},{8,0},{1,4},{0,7},{0,7},{9,4},{9,4},{0,7},{0,7},{9,4},{9,4},{6,6},{6,6},{6,4},{0,4},{6,6},{6,6},{6,4},{0,4},{8,6},{8,6},{7,4},{7,4},{8,6},{8,6},{2,4},{2,4},{7,6},{7,6},{6,3},{9,0},{7,6},{7,6},{8,0},{1,4},{9,6},{9,6},{9,5},{9,5},{9,6},{9,6},{9,5},{9,5},{6,5},{6,5},{8,4},{8,3},{6,5},{6,5},{8,4},{8,3},{7,5},{7,5},{8,5},{8,5},{7,5},{7,5},{9,3},{9,3},{7,3},{7,3},{4,5},{7,1},{7,3},{7,3},{6,1},{4,6},{9,6},{9,6},{9,5},{9,5},{9,6},{9,6},{9,5},{9,5},{0,6},{0,6},{8,2},{0,5},{0,6},{0,6},{8,2},{0,5},{7,5},{7,5},{8,5},{8,5},{7,5},{7,5},{9,3},{9,3},{9,1},{9,1},{7,2},{5,5},{9,1},{9,1},{6,0},{5,6},{0,7},{0,7},{9,4},{9,4},{0,7},{0,7},{9,4},{9,4},{6,6},{6,6},{6,4},{0,4},{6,6},{6,6},{6,4},{0,4},{8,6},{8,6},{7,4},{7,4},{8,6},{8,6},{2,4},{2,4},{7,6},{7,6},{6,3},{9,0},{7,6},{7,6},{8,0},{1,4},{0,7},{0,7},{9,4},{9,4},{0,7},{0,7},{9,4},{9,4},{6,6},{6,6},{6,4},{0,4},{6,6},{6,6},{6,4},{0,4},{8,6},{8,6},{7,4},{7,4},{8,6},{8,6},{2,4},{2,4},{7,6},{7,6},{6,3},{9,0},{7,6},{7,6},{8,0},{1,4},{9,6},{9,6},{9,5},{9,5},{9,6},{9,6},{9,5},{9,5},{6,5},{6,5},{8,4},{8,3},{6,5},{6,5},{8,4},{8,3},{2,6},{2,6},{9,2},{9,2},{2,6},{2,6},{2,5},{2,5},{8,1},{8,1},{6,2},{7,0},{8,1},{8,1},{3,5},{3,6},{9,6},{9,6},{9,5},{9,5},{9,6},{9,6},{9,5},{9,5},{0,6},{0,6},{8,2},{0,5},{0,6},{0,6},{8,2},{0,5},{2,6},{2,6},{9,2},{9,2},{2,6},{2,6},{2,5},{2,5},{1,6},{1,6},{4,4},{5,4},{1,6},{1,6},{3,4},{1,5}};
  int j = 0;
  j=j+(i[0][0]*128);
  j=j+(i[0][1]*64);
  j=j+(i[0][2]*32);
  j=j+(i[1][0]*16);
  j=j+(i[1][2]*8);
  j=j+(i[2][0]*4);
  j=j+(i[2][1]*2);
  j=j+(i[2][2]*1);
  return pairs[j];
}

char levelGet(String[] lev, int x, int y) {
 if (x < 0 || x > lev[0].length()-1) {
   return ' ';
 } else if (y < 0 || y > lev.length-1) {
   return ' ';
 } else {
   return lev[y].charAt(x);
 }
}

char levelGet(String[] lev, int x, int y, char i) {
 if (x < 0 || x > lev[0].length()-1) {
   return i;
 } else if (y < 0 || y > lev.length-1) {
   return i;
 } else {
   return lev[y].charAt(x);
 }
}

int equal(char i1, char i2) {
  if (i1 == i2) {
    return 1;
  } else {
    return 0;
  }
}

void setTiles(String[] lev, PImage tiles) {
  PGraphics t = createGraphics(lev[0].length()*48, lev.length*48);
  t.beginDraw();
  for (int y = 0; y < lev.length; y++) {
    for (int x = 0; x < lev[0].length(); x++) {
      if (lev[y].charAt(x) == 'g') {
        int[][] surroundings = {
          {0,0,0},
          {0,0,0},
          {0,0,0}
        };
        for (int j = -1; j <= 1; j++) {
          for (int i = -1; i <= 1; i++) {
            surroundings[j+1][i+1] = equal('g', levelGet(lev, x+i, y+j, 'g'));
          }
        }
        int[] tilePos = tile(surroundings);
        t.image(tiles.get(tilePos[0]*48, tilePos[1]*48, 48, 48), x*48, y*48);
      }
    }
  }
  t.endDraw();
  tileset = t;
}

void hitboxMap(String[] lev) {
  for (int y = 0; y < lev.length; y++) {
    for (int x = 0; x < lev[0].length(); x++) {
      if (lev[y].charAt(x) == 'g') {
        int l = 0;
        while (levelGet(levels[level], x+(l+1), y) == 'g') {
          l++;
        }
        groundHB((x*48)+5, y*48, 38+(l*48), 48, 16);
        x+=l;
      }
    }
  }
  if (charY > (levels[level].length*48)-charH-48) {
    charX = 48;
    charY = 48;
  }
}

void drawLevel() {
  scrollX += (min(max(charX+(charW/2)-(width/2), 0), (levels[level][0].length()*48)-width)-scrollX)/8;
  scrollY += (min(max(charY+(charH/2)-(height/2), 0), (levels[level].length*48)-height)-scrollY)/8;
  image(tileset.get(int(scrollX), int(scrollY), width, height), 0, 0);
  int h = min(max(int(scrollY-(levels[level].length*48)+72+height), 0), 135);
  PImage lavaFrame = yougan_gazou[frameCount%46].get(int((scrollX)%59), 0, width, h);
  println(mouseX);
  image(lavaFrame, 0, height-lavaFrame.height);
}
