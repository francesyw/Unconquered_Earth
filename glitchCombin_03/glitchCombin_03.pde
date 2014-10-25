import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;

SyphonServer server;
OscP5 oscP5;
NetAddress myRemoteLocation;

float noiseScale = 0.005;
float noiseZ = 0;
int particlesDensity = 8;
int particleMargin = 64; 
Particle[] particles;

Table table;
float killed, injured, homeless, destroyed, damaged, allPeople, allBuilding, levelNumber;
String eventName, country, date, time, level;
PImage[] map=new PImage[71];
int eventNumber=0;
int switchNum=0;
Glitch glitch;
int[] nSeeds=new int[2560];
int temp=0;

int  oop=0;
int slt;
boolean sSwitch=false;
int q=0, u=1, v=2;

PFont font;
PGraphics glitches;
PGraphics texts;
PGraphics images;
boolean textOn=true;
boolean isNew1=true;

void setup() {
  size(1280, 720, P3D);

  font = loadFont("HelveticaNeueLTStd-UltLt-200.vlw");
  textFont(font);
  textAlign(LEFT, CENTER);

  eventNumber=round(random(71));

  glitches=createGraphics(width, height);
  texts=createGraphics(width, height);
  images=createGraphics(width, height);

  oscP5 = new OscP5(this, 12001);
  // myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  table=loadTable("Destruction Data_03.csv", "header");
  for (int i=0;i<71;i++) {
    map[i]=loadImage((2556*2/71-(i+1))+"_"+table.getString(i, "Event Name")+".jpg");
  }
  for (int i=0;i<width;i++) {
    nSeeds[i]=(int)random(width);
  }
  glitch=new Glitch();

  particles = new Particle[(width+particleMargin*2)/particlesDensity*(height+particleMargin*2)/particlesDensity];
  int i = 0;
  for (int y=-particleMargin; y<height+particleMargin; y+=particlesDensity) {
    for (int x=-particleMargin; x<width+particleMargin; x+=particlesDensity) {
      int c = color(map[eventNumber].get(x, y), 60);
      particles[i++] = new Particle(x, y, c);
    }
  }
  image(map[eventNumber], 0, 0);
  
  server = new SyphonServer(this, "Processing Glitch");
}


void draw() {
  /* if (frameCount%200==3) {
   
   textOn=true;
   println(frameCount);
   }
   */

  glitches.beginDraw();
  ifif();

  glitch.update();


  textOn=false;

  // blend(0,0,width,height,0,0,width,height,MULTIPLY);
  //texts.endDraw();
  // image(texts, 0, 0);

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
//  println(frameRate);
  server.sendScreen();
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
    eventNumber=2485*2/71-events;
    //eventNumber=events;
    //switchNum=(switchNum+1)%5;
    //eventNumber=(eventNumber+1)%71;
    if (switchNum==3 ||switchNum==0||switchNum==2) {
      glitches.image(map[eventNumber], 0, 0);
    } else {
      image(map[eventNumber], 0, 0);
    }
    images=createGraphics(width, height);
    particles = new Particle[(width+particleMargin*2)/particlesDensity*(height+particleMargin*2)/particlesDensity];
    int i = 0;
    for (int y=-particleMargin; y<height+particleMargin; y+=particlesDensity) {
      for (int x=-particleMargin; x<width+particleMargin; x+=particlesDensity) {
        int c = color(map[eventNumber].get(x, y), 60);
        particles[i++] = new Particle(x, y, c);
      }
    }
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
int events=0;
int rand=0;

void mousePressed() {
  sSwitch=true;
  temp=frameCount;
  events=(events+1)%71;
  rand=(int)random(4);
  /*
  particles = new Particle[(width+particleMargin*2)/particlesDensity*(height+particleMargin*2)/particlesDensity];
   int i = 0;
   for (int y=-particleMargin; y<height+particleMargin; y+=particlesDensity) {
   for (int x=-particleMargin; x<width+particleMargin; x+=particlesDensity) {
   int c = color(map[eventNumber].get(x, y), 60);
   particles[i++] = new Particle(x, y, c);
   }
   }
   */
}

void oscEvent(OscMessage theOscMessage) {
  events=theOscMessage.get(0).intValue();
  
  println("event: "+events);
  sSwitch=true;
  temp=frameCount;
  rand=(int)random(4);

}

