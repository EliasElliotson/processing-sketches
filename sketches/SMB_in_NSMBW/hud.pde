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
  time.ellipse(22.5, 22.5, 42, 42);
  time.strokeCap(SQUARE);
  time.strokeWeight(5);
  time.line(22.5-tx, 24.5-ty, 22.5-tx, 5-ty);
  time.line(20-tx, 22.5-ty, 35-tx, 22.5-ty);
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
    image(hudnums[15+int(str(k.charAt(i)))], round(x)+(i*30)-5, round(y));
  }
}
