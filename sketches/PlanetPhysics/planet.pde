class Planet {
  float x; // the x of center of gravity
  float y; // the y of center of gravity
  float r; // the radius of the planet
  float gravityDistance = 125; // how close until the gravity controls you
  
  Planet(float nx, float ny, float nr) {
    x=nx; // define the x center
    y=ny; // define the y center
    r=nr; // define the radius
  }
  
  void draw() {
    /*
    noStroke();
    fill(#D68B30);
    pushMatrix();
    translate(x, y);
    sphere(r/2);
    popMatrix();
    */
    pushMatrix();
    translate(x, y);
    scale(r/2);
    shape(planet_big);
    popMatrix();
    
  }
}
