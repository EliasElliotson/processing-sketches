PImage grass;
PImage[] ninjaWalk;
float titleY = -300;
float titleS = 0;
float titleX = 0;
int game = 0;
boolean gameSelection = false;
SoundFile selectSound;
SoundFile chooseSound;
SoundFile startSound;

void drawTitle() {
  background(overworld.get(round(titleX*2)%(overworld.width-1056), round(height/2), 960, 640));
  image(grass.get(int(titleX*4)%width, 0, width, height), 0, 0);
  int[] mercy = {1, 1, 1, 1};
  for (int y = 0; y < levels[level].length; y++) {
    for (int x = 0; x < levels[level][0].length(); x++) {
      if (levels[level][y].charAt(x) == 'f') {
        flower("", (x*64), y*64);
      }
    }
  }
  titleX++;
  if (!gameSelection) {
    image(ninjaWalk[floor(frameCount/5)%3], (width-ninjaWalk[0].width)/2, (8*64)-ninjaWalk[0].height);
    titleY+=titleS;
    if (frameCount < 125) {
      titleS+=1;
    } else {
      titleS=0;
    }
    if (titleY > 0) {
      titleY=0;
      titleS=-titleS/2;
    }
  } else {
    image(game1, int((width-game1.width)/2), title.height+25);
    image(game2, int((width-game2.width)/2), title.height+75);
    image(game3, int((width-game3.width)/2), title.height+125);
    int w = game3.width;
    if (game == 0) {
      w = game1.width;
    } else if (game == 1) {
      w = game2.width;
    }
    float frame = frameCount;
    image(select, int((width-w)/2)-50+5+(sin(frame/10)*7), title.height+25+(game*50)+5);
  }
  image(title, int((width-title.width)/2), int(titleY));
  if (frameCount%100 < 50 && !gameSelection) {
    image(pressStart, (width-pressStart.width)/2, 550);
  }
  if (keyPress[0] && game > 0) {
    game--;
    selectSound.play();
  }
  if (keyPress[1] && game < 2) {
    game++;
    selectSound.stop();
    selectSound.play();
  }
  if (keyPress[6] == true && frameCount >= 125 && gameSelection != true) {
    gameSelection=true;
    chooseSound.stop();
    chooseSound.play();
  } else if (keyPress[6] == true && gameSelection == true) {
    scene="Play";
    loadTileset(levels[1]);
    level=1;
    resetChar();
    startSound.play();
  }
  keys[6]=false;
}
