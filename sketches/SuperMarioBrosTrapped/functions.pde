// Returns the preferred side
public int getSide(float x, float y, float w, float h) {

  //Step 1:  Calculate which corners are colliding (of the character and hitbox)
  float corner = -degrees(atan((charX - x) / (charY - y)));
  if (charY >= y) {corner += 180;}
  corner = floor(((corner + 360) % 360)/90) % 4;
  
  //Step 2:  Calculate the coordinates of the corners that are colliding
  //Coordinates of character's corner
  float x1 = charX + charW * floor(corner/2);
  float y1 = charY + charH * floor((3-((corner+1) % 4))/2);
  //Coordinates of hitbox's corner
  float x2 = x + w * floor((3-corner)/2);
  float y2 = y + h * (floor((4-corner)/2) % 2);
 
  //Step 3:  Calculate closest collision exit side
  float collisionAngle = -degrees(atan((x1 - x2)/(y1 - y2)));
  if (y1 >= y2) {collisionAngle += 180;}
  collisionAngle = floor(((collisionAngle + 360) % 360)/45);
  
  //Step 4:  Return the optimal exit side (0 = up, 1 = right, 2 = down, 3 = left)
  int[] optimalSide = {3,2,0,3,1,0,2,1};    //Stores the optimal sides to return for the function calculation
  return optimalSide[int(collisionAngle)];
  
}

PImage resizeImage(PImage i, int w, int h) {
  PGraphics img = createGraphics(w, h);
  img.beginDraw();
  img.image(i, 0, 0, w, h);
  img.endDraw();
  return img;
}

PImage tileImageLeft(PImage i, int t) {
  PGraphics g = createGraphics(i.width*t, i.height);
  g.beginDraw();
  for (int j = 0; j < t; j++) {
    g.image(i, j*i.width, 0);
  }
  g.endDraw();
  return g;
}
