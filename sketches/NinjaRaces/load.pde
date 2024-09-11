int shaders = 8;

void loadShaders(int frame) {
  if (frame == 0) {
    overworld=loadImage("backgrounds/overworld.png");
    grass=loadImage("title/ground.png");
    PGraphics i = createGraphics(grass.width, grass.height);
    i.beginDraw();
    i.image(grass.get(0, 0, width, height), 0, 0);
    i.image(grass.get(0, 0, width, height), width, 0);
    i.endDraw();
    grass=i;
    selectSound=new SoundFile(this, "title/select.wav");
  }
  if (frame == 1) {
    chooseSound=new SoundFile(this, "title/choose.wav");
    startSound=new SoundFile(this, "title/start.wav");
    ninja=loadImage("ninja/ninja.png");
    pressStart = loadImage("title/press start.png");
    pressStart = resizeImage(pressStart, 273, 49);
  }
  if (frame == 2) {
    File level = new File(dataPath("levels/1.level"));
    int numLevels = 0;
    while (level.exists()) {
      numLevels++;
      level = new File(dataPath("levels/"+(numLevels+1)+".level"));
    }
    tilesetImgs = new PImage[numLevels+1];
    levels = new String[numLevels+1][0];
    loadLevel("levels/title.level", 0);
    game1 = loadImage("title/game1.png");
    game2 = loadImage("title/game2.png");
  }
  if (frame == 3) {
    game3 = loadImage("title/game3.png");
    game1 = resizeImage(game1, floor(game1.width/10), 49);
    game2 = resizeImage(game2, floor(game2.width/10), 49);
    game3 = resizeImage(game3, floor(game3.width/10), 49);
    select = loadImage("title/select.png");
    select = resizeImage(select, 40, 40);
    ninjaWalk = new PImage[3];
    ninjaWalk[2] = resizeImage(ninja.get(266, 11, 128, 128), 83, 83);
    ninjaWalk[0] = resizeImage(ninja.get(395, 11, 128, 128), 83, 83);
    ninjaWalk[1] = resizeImage(ninja.get(1, 11, 128, 128), 83, 83);
  }
  if (frame == 4) {
    loadTilesets();
    resetChar();
  }
  if (frame == 5) {
    loadSoundEffects();
  }
  if (frame == 6) {
    loadHud();
  }
  if (frame == 7) {
    for (int i = 1; i < levels.length; i++) {
      loadLevel(dataPath("levels/"+i+".level"), i);
      File img = new File(dataPath("levels/tilesets/"+i+".png"));
      if (img.exists()) {
        tilesetImgs[i]=loadImage(dataPath("levels/tilesets/"+i+".png"));
      } else {
        loadTileset(levels[i]);
        tilesetImgs[i]=tiles;
        tiles.save(dataPath("levels/tilesets/"+i+".png"));
      }
    }
  }
}
