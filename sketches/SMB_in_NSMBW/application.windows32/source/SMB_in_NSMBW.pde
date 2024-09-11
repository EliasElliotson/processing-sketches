import processing.sound.*;

CustomMusic songs;
SFXLib sfx;

CharacterGraphics mainChar;

Mushroom mush;

void setup() {
  //
  size(1088, 704);
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

void draw() {
  drawBackgrounds("Overworld", 0, 0);
  updateCharacter();
  drawLevel();
  mush.draw(200, 200);
  mainChar.draw(charX, charY, state, charFrame, direction);
  //rotHB(mouseX, mouseY, 100, 100, 45, 20);
  //rotHB(mouseX-100, mouseY+100, 100, -100, 45, 20);
  drawHud();
}

void keyPressed() {
  gameKeyPress();
}

void keyReleased() {
  gameKeyRelease();
}

void mouseClicked() {
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
