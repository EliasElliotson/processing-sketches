float angle(float x1, float y1, float x2, float y2) {
  return radians(360-((degrees(atan2((x2-x1), (y2-y1)))+270)%360));
}

char X = 0;
char Y = 1;

float angle(char i1, float x, float y, float w, float h, float i2) {
  float i = 0;
  if (i1 == X) {
    i = x+(cos(i2)*(w/2));
  } else if (i1 == Y) {
    i = y+(sin(i2)*(h/2));
  }
  return i;
}
