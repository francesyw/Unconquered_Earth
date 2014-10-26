import codeanticode.syphon.*;
import de.voidplus.leapmotion.*;
import java.text.*;
import processing.opengl.*;

int screenWidth = 1280;
int screenHeight = 720;
int sDetail = 30;  // *Sphere resolution
float r_mapY = 0; // globe - rotation Y 
float r_mapX = 0; // globe - rotation X
float globeR = 80; // globe size
float globeRadius;
float earthRadius = 6371.0; // *The mean value of the distance from Earth's surface to its center.
int originalSize = 0;
long lastTime;
String monthURL = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson";
String hourURL = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson";
char month = 'M';
char hour = 'H';
boolean isHour = false;

PImage texMap;
PImage texMap2;
PImage back;
PImage back2;
PImage glow;
PVector finger_velocity;
int num_finger;
float hand_roll;
PVector hand_position;
boolean isHands;
float rotateSet0;
long handsLastTime;

PFont font, font2;
boolean isNew=false;
int maxCount=1;

int ii=0;

SyphonServer server;

LeapMotion leap;
leapControl leapC;
eqData eqData;
eqCords eqCords;
Earth earth;
//Set0 set0;
OSC osc;
eqAnimate eqAnimate;

//=========================================

void setup() {
  size(screenWidth, screenHeight, P3D);

//  frame.setLocation(1280, 0);
//  frame.setAlwaysOnTop(false);

  lastTime = millis();

  texMap = loadImage("noinvert.png");
  texMap2 = loadImage("invert.png");
  back = loadImage("back2.png");
//  back2 = loadImage("back3.png");
  glow = loadImage("glow.png");
  earth = new Earth();
  earth.initializeSphere(sDetail);    

  eqData = new eqData();
  eqCords = new eqCords();
  eqAnimate=new eqAnimate();
  //*Load the all_month data at the first time the program's running
  eqData.init(monthURL);
  eqData.update(month);
  originalSize = eqData.latList.size();

//  set0 = new Set0();
//  set0.init();

  println("count all: " + eqData.count);
  println("latList size: " + eqData.latList.size());

  leap = new LeapMotion(this);
  leapC = new leapControl();
  leapC.isZoom = false;

  osc = new OSC();
  osc.init();

  //  uiText=new uiText();
  font = loadFont("HelveticaNeue-UltraLight-200.vlw");
  font2 = createFont("HelveticaNeue-Medium-48.vlw", 16, true);

//  background(0);
  smooth();
  
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Globe");
}


//===================================================

void draw() {
  
  noHands();
  
  //background circle clears only
  globeRadius = 1;
//if (leapC.isZoom == true ||keyPressed && key == 'z'){
  fill(0,255);
//  rect(-2,-2,width+2,height+2);
//} else {
  tint(0, 0, 0, 225);
  
//}
  fill(0, 18);
//  rect(-1, -1, width+2, height+2);
  hint(DISABLE_DEPTH_TEST);
  imageMode(CENTER);

  realTimeUpdate();  // *Update the data every one and half minute.

  pushMatrix();
  image(back, width/2, height/2, 630, 630);
  translate(width/2, height/2, 300);
  
//  rotateX(radians(0.0));
//  rotateY(radians(0.0));
//  rotateZ(radians(-35.5));
  lights();

  pushMatrix();

  rotateX(radians(r_mapX));
  rotateY(radians(r_mapY));
  //-----------------------------//

  //--------------Main Globe----------------//
  scale(1.49);
  renderGlobe(169, 227, texMap2); 
  hint(ENABLE_DEPTH_TEST);
  renderGlobe(151, 210, texMap2);      

  addEqEvent(); // *draw event objects.

  popMatrix();
  popMatrix();


  //Leap Motion ==========
  isHands = leap.hasHands();
  // HANDS
  for (Hand hand : leap.getHands()) {
    hand_position    = hand.getStabilizedPosition();
    hand_roll        = hand.getRoll();
    num_finger       = hand.countFingers();

    leapC.isOneFinger();

    // FINGERS
    for (Finger finger : hand.getFingers()) {      
      finger_velocity   = finger.getVelocity();
    }

    //--HANDS controlling the globe    
    leapC.handControl();
    handsLastTime = millis();
  }

//  leapC.zoomGlobe();

  if (!isHands) {     
    r_mapY += 0.2;
//    if ( millis() - handsLastTime >= 5000 ) {
//      leapC.zoomGlobe = 'O';
//      leapC.zoomGlobe();
//      handsLastTime = millis();
//    }
  }
  
  server.sendScreen();
//  println(frameRate);
}



//---------------------------------------------
//                  Functions
//---------------------------------------------
int maxCounthour=1;

void addEqEvent() {
  int j;
  for (int i = eqData.countHour; i < eqData.latList.size(); i++) { 
    setParameter(i, 0);        
    eqCords.render(month);
  }
  if (eqData.countHour != 0) {
    for (j=0;j<eqData.countHour;j++) {
      for (int i = 0; i < eqData.latList.size() - originalSize; i++) {
        setParameter(i, j);
        eqCords.render(hour);
        eqAnimate.render(hour);
      }
      maxCounthour = eqData.countHour;
    }
  } else {

    for (j = 0; j < maxCounthour; j++) {

      for (int i = 0; i < eqData.latList.size() - originalSize; i++) {
        setParameter(i, j);
        eqCords.render(hour);
        eqAnimate.render(hour);
      }
    }
  }

  for (int i = 0; i < 71; i++) {
    eqCords.lat = eqData.destrLatList.get(i);
    eqCords.lon = eqData.destrLonList.get(i);
    eqCords.rD = eqData.destrDepthList.get(i);
    eqCords.destrRawLon = eqData.destrRawLonList.get(i);
    eqCords.destrRawLat = eqData.destrRawLatList.get(i);
    eqCords.destrName = eqData.destrNameList.get(i);
    eqCords.destrCountry = eqData.destrCountryList.get(i);
    eqCords.destrYear = eqData.destrYearList.get(i);
    eqCords.destrMag = eqData.destrMagList.get(i);
    eqCords.destrKilled = eqData.destrKilledList.get(i);
    eqCords.destrInjured = eqData.destrInjuredList.get(i);
    eqCords.destrHomeless = eqData.destrHomelessList.get(i);
    eqCords.update();
    eqCords.render('D');
  }
}

void setParameter(int i, int j) {  
  eqCords.lat = eqData.latList.get(i);
  eqCords.lon = eqData.lonList.get(i);
  eqCords.rD = eqData.depthList.get(i);
  eqCords.mag = eqData.magList.get(i);

  eqCords.update();

  eqAnimate.lon= eqData.lonList.get(j);
  eqAnimate.lat= eqData.latList.get(j);
  eqAnimate.rD = eqData.depthList.get(j);
  eqAnimate.magl= eqData.magList.get(j);
  eqAnimate.title=eqData.placeList.get(j);
  eqAnimate.update();
}



void realTimeUpdate() {
  //  *Update every one and half minute
  if ( millis() - lastTime >= 60000 ) {
    //  *Load all_hour data
    eqData.init(hourURL);
    eqData.update(hour);
    println( "all_hour data updated!" );

    pushMatrix();
    tint(254, 255);
    image(glow, width/2, height/2, 600, 600);

    popMatrix();

    isHour = true;

    lastTime = millis();
    isNew = true;
  }
}


void renderGlobe(int tint, int tintAlpha, PImage image) {

  stroke(254, 0);
  //  tint(255,67);  // *Adjust transparency of the globe
  fill(0, 35, 179, 255);
  if (isHands == true ||mousePressed == true) {
    //tint for background circle

      ii+=2.5;
    if (ii >= 100) {
      ii = 100;
    }
    fill(0.60*ii, 1.80*ii, 2.55*ii, 212);
  } 
  else {
    ii=0;
  }
  
  // ii = 0;
  textureMode(IMAGE);  
  //*calls the img.
  //  tint(206,57);
  tint(tint, tintAlpha);
  earth.texturedSphere(globeRadius, image);
}

/*
void init() {
  frame.dispose();
  frame.setUndecorated(true); // works.
  //frame.removeNotify();
  //call PApplet.init() to take care of business
  super.init();
} 
*/

void noHands() {
  if (isHands == false) {
    if (mousePressed) {
      r_mapY = map(mouseX, 0, width, 0, 180);
      r_mapX = map(mouseY, height/2, height, 0, 90);
    }

    if (keyPressed && key == 'z') {
      leapC.zoomGlobe = 'I';
    }
    
  }
}

//======================= Leap Motion ========================

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}

