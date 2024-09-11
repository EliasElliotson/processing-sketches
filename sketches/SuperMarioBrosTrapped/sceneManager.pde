void setTitleAsScene() {
  String[] titleLev = {
    "                    ",
    "                    ",
    "                    ",
    "                    ",
    "                    ",
    "                    ",
    "                    ",
    "                    ",
    "                    ",
    "gggggggggggggggggggg",
    "gggggggggggggggggggg",
  };
  if (themeOfDay == 0) {
    setTiles(titleLev, chijou_tairu);
  } else if (themeOfDay == 1) {
    setTiles(titleLev, chika_tairu);
  } else {
    setTiles(titleLev, shiro_tairu);
  }
  scene = "Title";
  oou_ongaku.loop();
  titleTrans = new Transition3((width-24)/2, height-48-48-24);
  titleTrans2 = new Transition1((width-24)/2, height-48-48-24);
  titleTrans.start();
}

void setPrelevelAsScene() {
  scene = "Prelevel";
  preLevelTrans = 0;
}
