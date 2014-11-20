import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;
//import java.net.*;
import java.net.URL.*;
import java.io.*;
import java.net.MalformedURLException;
import processing.opengl.*;

SyphonServer server;
OscP5 oscP5;
NetAddress myRemoteLocation;
eqData eqData;

PImage[] map=new PImage[71];
Table table;
float killed, injured, homeless, destroyed, damaged, allPeople, allBuilding, levelNumber;
String eventName, country, date, time, level;
int eventNumber=0;
int switchNum=0;
int x1, y1, h, w, x2, y2;
long lastTime;

PGraphics glitches;
PGraphics texts;
PImage dead1, homeless1, injured1, date1, magnitude1;
String hourURL = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson";
char hour = 'H';
char month = 'M';
StringList finalText;
PFont robotLight, robotoMedium;

int oop=0;
int slt;
boolean sSwitch=false;
boolean textOn=true;
boolean ifWifi=true;
int events=0;
int rand=0;
int temp=0;
color c=color(10, 60, 140, 80);
void setup() {
  size(1280, 720, P3D);
  //  map=loadImage("2_Caracas.jpg");

  dead1 = loadImage("deaths.png");
  homeless1 = loadImage("homeless.png");
  injured1 = loadImage("injured.png");
  date1 = loadImage("date.png");
  magnitude1 = loadImage("mag.png");
  //textMode(SCREEN);
  //robotLight=createFont("HelveticaNeueLTStd-Roman.otf", 48);
  robotLight=createFont("Roboto-Light.ttf", 72);
  robotoMedium = createFont("Roboto-Medium.ttf", 72);
  ifNoInternet();

  eqData = new eqData();
  eqData.update(month);
  oscP5 = new OscP5(this, 12001);
  server = new SyphonServer(this, "Processing Glitch");

  table=loadTable("Destruction Data_03.csv", "header");
  for (int i=0; i<71; i++) {
    map[i]=loadImage((2556*2/71-(i+1))+"_"+table.getString(i, "Event Name")+".jpg");
  }

  glitches=createGraphics(width, height);
  texts=createGraphics(width, height);
  glitches.beginDraw();

  glitches.image(map[eventNumber], 0, 0,width,height);
  glitches.filter(GRAY);
  glitches.tint(c);
  glitches.image(map[eventNumber], 0, 0,width,height);


  glitches.noStroke();
  glitches.fill(0);
  glitches.rect(0, 0, width, 80);
  glitches.rect(0, height-80, width, 80);
  glitches.endDraw();
  image(glitches, 0, 0);
}

void draw() {
  data();

  glitches.beginDraw();
  ifif();
  selectGlitch();
  realTimeUpdate(); 
  texts();
  textOn=false;
  if (slt==2) {
  } else {
    fill(0, oop);
    noStroke();
    rect(0, 0, width, height);
  }
  if (oop==10) {
    oop=0;
  }

  fill(0, oop);
  if (oop==245) {
    oop=255;
  }
  noStroke();
  rect(0, 0, width, height);


  //delay(50);
  //  server.sendScreen();
}

void ifif() {
  if (sSwitch==true) {
    oop=oop+frameCount-temp;
    if (oop>254) {
      frameCount=1;  
      slt=1;  
      sSwitch=false;
    }
  }
  if (slt==1) {
    switchNum=rand;
    //eventNumber=2485*2/71-events;
    eventNumber=events;
    //switchNum=(switchNum+1)%5;
    //eventNumber=(eventNumber+1)%71;
    glitches.tint(255, 255);
    glitches.image(map[eventNumber], 0, 0);
    glitches.filter(GRAY);
    glitches.tint(c);
    glitches.image(map[eventNumber], 0, 0);
    glitches.fill(0);
    glitches.rect(0, 0, width, 80);
    glitches.rect(0, height-80, width, 80);
    print("switchNumber:"+switchNum);
    print("eventNumber: "+eventNumber);
    slt=2;
  }
  if (slt==2) {

    oop=oop-frameCount;
    textOn=true;
    if (oop<1) {
      slt=3;
    }
  }
} 
void selectGlitch() {

  switch(switchNum) {
  case 0:
    x1 = (int) random(0, width);
    y1 = 0;
    //int y1=(int) random(0, height-80);
    x2 = round(x1 + random(-killed/allPeople*90, killed/allPeople*90));
    y2 = round(random(-destroyed/allBuilding*40, destroyed/allBuilding*40));
    //int y2 = round(y1+random(-destroyed/allBuilding*40, destroyed/allBuilding*40));
    //println(y2);
    w = (int) random(map(levelNumber, 6, 9, width/2-200, width/2+200));
    //int h = height/2;//try random?
    h= height;
    break;
  case 1:
    x1 = (int) random(0, width);
    // int y1 = 0;
    y1= (int) random(0, height-80);

    x2 = round(x1 + random(-killed/allPeople*90, killed/allPeople*90));
    //int y2 = round(random(-destroyed/allBuilding*40, destroyed/allBuilding*40));
    y2 = round(y1+random(-destroyed/allBuilding*40, destroyed/allBuilding*40));
    //println(y2);

    w = (int) random(map(levelNumber, 6, 9, width/2-200, width/2+200));
    //int h = height/2;//try random?
    //h= (int)random(height/2);
    h = (int) levelNumber*20;
    
    break;
  }

  glitches.copy(x1, y1, w, h, x2, y2, w, h);
  glitches.noStroke();
  glitches.fill(0);
  glitches.rect((int)random(width), 0, (int) random(map(levelNumber, 6, 9, width/2-200, width/2+200)), 40);
  glitches.rect((int)random(width), height-40, (int) random(map(levelNumber, 6, 9, width/2-200, width/2+200)), 40);
  glitches.endDraw();
  image(glitches, 0, 0);
}
int maxCounthour=0;

void texts() {
  textAlign(LEFT, CENTER);  
  float pngSize = 30;
  float textLoc = width/12*1.2;

  float pngLocX = textLoc-20;
  float pngLocY = height/16;

  smooth();
  textFont(robotLight);

  fill(255);
  textSize(52);
  text(finalText.get(0), textLoc-35, height/16*2);

  textAlign(LEFT, CENTER);
  textSize(30);

  pushStyle();
  imageMode(CENTER);

  //date
  textSize(26);
  image(date1, pngLocX, pngLocY*3.2+4, pngSize, pngSize);
  text(finalText.get(1), textLoc, pngLocY*3.2);

  // mag
  image(magnitude1, pngLocX, pngLocY*4+4, pngSize, pngSize);
  text(finalText.get(2), textLoc, pngLocY*4);

  // injured
  textSize(18);

  image(injured1, pngLocX, pngLocY*4.8+4, pngSize, pngSize);
  text(finalText.get(3), textLoc, pngLocY*4.8);

  // dead
  image(dead1, pngLocX, pngLocY*5.6+4, pngSize, pngSize);
  text(finalText.get(4), textLoc, pngLocY*5.6);

  // homeless
  image(homeless1, pngLocX, pngLocY*6.4+4, pngSize, pngSize);
  text(finalText.get(5), textLoc, pngLocY*6.4);
  popStyle();
  //==============================
  if (ifWifi==true) {
    textSize(24);
    //fill(255, 0, 0);
    fill(255);

    text("live earthquakes", textLoc, height/16*10);
    fill(240, 56, 10);

    if (eqData.countHour !=0) {
      if (eqData.countHour > 4) {
        eqData.countHour = 4;
      }
      textSize(14);
      textFont(robotoMedium);
      for (int i = 0; i < eqData.countHour; i++) {
        // println(eqData.countHour);
        textSize(14);
        text(eqData.titleList.get(i), textLoc+15, height/16*(11+i*0.5));
      }

      maxCounthour=eqData.countHour;
    } else {
      for (int i=0; i<maxCounthour; i++) {
        textSize(14);
        // triangle(xc, height/16*(11+i*0.5), xc-4, xc+4, xc+4, xc+5);
        text(eqData.titleList.get(i), textLoc, height/16*(11+i*0.5));
      }
    }
  }
  // }
  //texts.endDraw();
  //image(texts, 0, 0);
}

void mousePressed() {
  sSwitch=true;
  temp=frameCount;
  events=(events+1)%71;
  rand=(int)random(2);
  /*
  eventNumber=(eventNumber+1)%71;
   switchNum=(int)random(2);
   */
  //tint(255,180);
  // image(map[eventNumber], 0, 0);
  // rect(0, 0, width, 80);
  // rect(0, height-80, width, 80);
}
/*
void oscEvent(OscMessage theOscMessage) {
 events=theOscMessage.get(0).intValue();
 println("event: "+events);
 sSwitch=true;
 temp=frameCount;
 rand=(int)random(4);
 }
 */
void data() {
  killed=table.getFloat(eventNumber, "People killed");
  injured=table.getFloat(eventNumber, "People injured");
  homeless=table.getFloat(eventNumber, "People homeless");
  destroyed=table.getFloat(eventNumber, "Buildings destroyed")+table.getFloat(eventNumber, "Dwellings Destroyed");
  damaged=table.getFloat(eventNumber, "Buildings damaged")+table.getFloat(eventNumber, "Dwellings damaged");
  eventName=table.getString(eventNumber, "Event Name");
  country=table.getString(eventNumber, "Country"); 
  date=table.getString(eventNumber, "Date (UTC)");
  time=table.getString(eventNumber, "Time (UTC)");
  level=table.getString(eventNumber, "Magnitude");
  levelNumber=table.getFloat(eventNumber, "Magnitude");
  allPeople=killed+injured+homeless;
  allBuilding=destroyed+damaged;
  //===================================================
  // String kk=table.getString(eventNumber, "People killed string")+"  dead";
  //String ii=table.getString(eventNumber, "People injured string")+ "  injured";
  //String hh=table.getString(eventNumber, "People homeless string")+"  homeless";
  String kk=table.getString(eventNumber, "People killed string");
  String ii=table.getString(eventNumber, "People injured string");
  String hh=table.getString(eventNumber, "People homeless string");
  finalText=new StringList();
  finalText.append(eventName+", "+ country);
  finalText.append(date);
  finalText.append(level);
  finalText.append(kk);
  finalText.append(ii);
  finalText.append(hh);
}

void realTimeUpdate() {
  //  *Update every one and half minute
  if ( millis() - lastTime >= 60000 ) {
    //  *Load all_hour data
    ifNoInternet();
    if (ifWifi==true) {
      eqData.init(hourURL);
      eqData.update(hour);
    }
    println( "all_hour data updated!" );
    //isHour = true;
    lastTime = millis();
    //isNew = true;
  }
}

void delay(int delay)
{
  int time = millis();
  while (millis () - time <= delay);
}


void ifNoInternet() {

  if (conectedToGeoJSON() == true) {
    ifWifi=true;
    println(" WiFi DETECTED. Switching to online mode");
  } else {
    //change the path
    ifWifi=false;
    println( " WiFi NOT DETECTED. Switching to offline mode");
  }
}

public static boolean conectedToGeoJSON() {

  try {
    //make a url to a known source
    java.net.URL url = new java.net.URL("http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson");

    //open connection to that source
    java.net.HttpURLConnection urlConnect = (java.net.HttpURLConnection)url.openConnection();

    //trying to retrieve data from the source. 
    //if no connecton, this line will fail 

    Object objData = urlConnect.getContent();
  } 
  catch (java.net.UnknownHostException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
    println("Internet NOT available");
    return false;
  }
  catch (IOException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
    println("Internet NOT available");

    return false;
  }
  println("Internet available");
  return true;
}

/*
void texts() {
 if (textOn==true){
 int xc=20;
 texts.beginDraw();
 texts.textFont(robotLight);
 texts.textAlign(LEFT, CENTER);
 texts.fill(255);
 texts.textSize(50);
 texts.text(finalText.get(0), xc, height/16*2);
 texts.textAlign(LEFT, TOP);
 texts.textSize(30);
 texts.shape(date1, xc, height/16*3, xc, xc);
 texts.text(finalText.get(1), 60, height/16*3);
 texts.shape(magnitude1, xc, height/16*4, xc, xc);
 texts.text(finalText.get(2), 60, height/16*4);
 texts.textSize(20);
 texts.shape(injured1, xc, height/16*5, xc, xc);
 texts.text(finalText.get(3), 60, height/16*5);
 texts.shape(dead1, xc, height/16*6, xc, xc);
 texts.text(finalText.get(4), 60, height/16*6);
 texts.shape(homeless1, xc, height/16*7, xc, xc);
 texts.text(finalText.get(5), 60, height/16*7);
 //==============================
 texts.textSize(20);
 texts.fill(255, 0, 0);
 texts.text("live earthquakes", xc, height/16*10);
 if (eqData.countHour !=0) {
 if (eqData.countHour>4) {
 eqData.countHour=4;
 }
 for (int i=0;i<4;i++) {
 texts.text(eqData.titleList.get(i), xc, height/16*(11+i*0.5));
 }
 maxCounthour=eqData.countHour;
 } else {
 for (int i=0;i<maxCounthour;i++) {
 texts.text(eqData.titleList.get(i), xc, height/16*(11+i*0.5));
 }
 }
 }
 texts.endDraw();
 image(texts, 0, 0);
 }
 */
