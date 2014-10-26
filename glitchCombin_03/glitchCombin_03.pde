import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;

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
PShape dead1, homeless1, injured1, date1, magnitude1;
String hourURL = "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson";
char hour = 'H';
char month = 'M';
StringList finalText;
PFont myFont;

int  oop=0;
int slt;
boolean sSwitch=false;
boolean textOn=true;
int events=0;
int rand=0;
int temp=0;

void setup() {
  size(1024, 768);
  //  map=loadImage("2_Caracas.jpg");

  dead1 = loadShape("dead.svg");
  homeless1 = loadShape("homeless.svg");
  injured1 = loadShape("injured.svg");
  date1 = loadShape("date.svg");
  magnitude1 = loadShape("magnitude.svg");

  myFont=createFont("Helvetica", 32);
  eqData = new eqData();
  eqData.update(month);
  oscP5 = new OscP5(this, 12001);
  
  //server = new SyphonServer(this, "Processing Glitch");

  table=loadTable("Destruction Data_03.csv", "header");
  for (int i=0;i<71;i++) {
    map[i]=loadImage((2556*2/71-(i+1))+"_"+table.getString(i, "Event Name")+".jpg");
  }

  glitches=createGraphics(width, height);
  texts=createGraphics(width, height);
  glitches.beginDraw();
  glitches.image(map[eventNumber], 0, 0);
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
  //server.sendScreen();
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


  // println(oop);
  //println(ssSwitch);
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
    h= (int)random(height/2);
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
/*
void texts() {
  if (textOn==true){
    int xc=20;
    texts.beginDraw();
    texts.textFont(myFont);
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
void texts() {
  //if (textOn==true){
    int xc=20;
    //beginDraw();
    textFont(myFont);
    textAlign(LEFT, CENTER);
    fill(255);
    textSize(50);
    text(finalText.get(0), xc, height/16*2);
    textAlign(LEFT, TOP);
    textSize(30);
    shape(date1, xc, height/16*2.7, xc, xc);
    text(finalText.get(1), 60, height/16*2.6);
    shape(magnitude1, xc, height/16*3.3, xc, xc);
    text(finalText.get(2), 60, height/16*3.2);
    textSize(20);
    shape(injured1, xc, height/16*4, xc, xc);
    text(finalText.get(3), 60, height/16*4);
    shape(dead1, xc, height/16*4.5, xc, xc);
    text(finalText.get(4), 60, height/16*4.5);
    shape(homeless1, xc, height/16*5, xc, xc);
    text(finalText.get(5), 60, height/16*5);
    //==============================
    textSize(20);
    //fill(255, 0, 0);
    fill(254,56,10);
    text("live earthquakes", xc, height/16*10);
    if (eqData.countHour !=0) {
      if (eqData.countHour>4) {
        eqData.countHour=4;
      }
      for (int i=0;i<4;i++) {
        textSize(16);
        text(eqData.titleList.get(i), xc, height/16*(11+i*0.5));
      }
      maxCounthour=eqData.countHour;
    } else {
      for (int i=0;i<maxCounthour;i++) {
        textSize(16);
        text(eqData.titleList.get(i), xc, height/16*(11+i*0.5));
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
    eqData.init(hourURL);
    eqData.update(hour);
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

