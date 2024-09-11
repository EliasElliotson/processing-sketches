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
  void loadBackground(String path, int w, int h) {
    bgGrad = resizeImage(loadImage(path+"/gradient.png"), w, h);
    String[] data = loadStrings(path+"/format.dat");
    layers = new PImage[int(data[1])];
    layerFormatType = int(data[0]);
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
  void drawBackground(float x, float y) {
    background(bgGrad);
    if (layerFormatType == 1) {
      for (int i = 0; i < layers.length; i++) {
        PImage layer = layers[i];
        int format = int(str(layerFormat.charAt(i)));
        int multiplier = layers.length-i;
        if (format == 0) {
          image(layer.get(int((x/multiplier)%width), 0, width, layer.height), 0, int(-(y/multiplier)));
        }
        if (format == 1) {
          image(layer.get(int((x/multiplier)%width), 0, width, layer.height), 0, int(height-(y/multiplier)-layer.height));
        }
      }
    }
  }
}
