public class SFXLib {
  SoundFile[] sfx;
  IntDict sfxN;
  SFXLib() {
    sfxN = new IntDict();
    sfx = songArray(0);
  }
  void add(String id, String path) {
    sfxN.set(id, sfx.length);
    SoundFile[] nsfxa = songArray(sfx.length+1);
    for (int i = 0; i < sfx.length; i++) {
      nsfxa[i] = sfx[i];
    }
    nsfxa[sfx.length] = song(path);
    sfx=nsfxa;
  }
  void play(String id) {
    sfx[sfxN.get(id)].play();
  }
}
public class CustomMusic {
  SoundFile[] songs;
  CustomMusic(int numSongs) {
    songs = songArray(numSongs);
  }
  void addSong(int num, String path) {
    songs[num] = song(path);
  }
  void start(int num) {
    songs[num].loop();
  }
  void stop(int num) {
    songs[num].stop();
  }
}

SoundFile[] songArray(int i) {
  return new SoundFile[i];
}

SoundFile song(String path) {
  return new SoundFile(this, path);
}

String musicPath(String i) {
  return dataPath("audio/music/"+i);
}
String sfxPath(String i) {
  return dataPath("audio/sfx/"+i);
}
String fontPath(String i) {
  return dataPath("graphics/font/"+i);
}
