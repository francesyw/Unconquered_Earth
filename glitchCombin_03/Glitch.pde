class Glitch {
  StringList finalText;
  boolean mapF=true;
  String textQ, textV, textU;
  void update() {
    data();
    glitches.textFont(font);
    glitches.textSize(80);
    glitches.fill(255);

    switch(switchNum) {
    case 0:
      if (sSwitch==true) {
      } else {
        if (mapF==true) {
          glitches.image(map[eventNumber], 0, 0);
          mapF=false;
        }
        curveLine();

        glitches.endDraw();
        image(glitches, 0, 0);
      }
      break;
    case 1:

      squareNoise();

      glitches.endDraw();
      image(glitches, 0, 0);
      break;
      /*
    case 2:

      triNoise();
      glitches.endDraw();
      image(glitches, 0, 0);
      break;
      */
    case 2:

      upTodown();
      // glitches.endDraw();
      //image(glitches, 0, 0);
      break;
    case 3:

      squareBlur();
      //glitches.endDraw();
      //image(glitches, 0, 0);
      break;
    }
  }
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
    String kk=table.getString(eventNumber, "People killed string")+"  dead";
    String ii=table.getString(eventNumber, "People injured string")+ "  injured";
    String hh=table.getString(eventNumber, "People homeless string")+"  homeless";
    // String bde=destroyed+"  building destroyed";
    // String bda=damaged+"  building damaged";
    finalText=new StringList();
    finalText.append(eventName+", "+ country);
    finalText.append(date);
    finalText.append("magnitude  "+level);
    finalText.append(kk);
    finalText.append(ii);
    finalText.append(hh);
  }

  void curveLine() {
    if (textOn==true) {
      glitches.fill(255);
      glitches.textSize(100);
      glitches.text(finalText.get(0), 100, height/16*9.5);
      glitches.textSize(50);
      glitches.text(finalText.get(1), 105, height/16*10.4);
      glitches.text(finalText.get(2), 105, height/16*11.1);
      glitches.textSize(70);
      glitches.text(finalText.get(3), 100, height/16*12.3);
      glitches.text(finalText.get(4), 100, height/16*13.4);
      glitches.text(finalText.get(5), 100, height/16*14.5);
    }
    glitches.strokeWeight(1.5);

    noiseZ += 2*noiseScale;
    for (int j=0; j<particles.length; j++) {
      particles[j].update();
    } 
    noiseScale=killed/allPeople+0.005;
  }

  float anx=0;
  float any=0;
  float xxx=0;
  float yyy=0;

  void squareNoise() {

    int n, m, r;
    float all=allPeople+allBuilding;
    //if (round(levelNumber)/3==3) {
    //   r=round(levelNumber/3+1)*10;
    //} else if (round(levelNumber)==5) {
    //   r=round(levelNumber)/5*20;
    // } else {
    if (round(levelNumber)==5) {
      r=(round(levelNumber)/5)*16;
    } else if (round(levelNumber)==6) {
      r=(round(levelNumber)/6)*16;
    } else if (round(levelNumber)==7) {
      r=(round(levelNumber)/7+1)*16;
    } else if (round(levelNumber)==8) {
      r=(round(levelNumber)/8+3)*16;
    } else if (round(levelNumber)==9) {
      r=(round(levelNumber)/9+7)*8;
    } else {
      r=ceil(levelNumber/3+1)*8;
    }
    // }
    n=width/r;
    m=height/r;
    PImage[][] img = new PImage [n][m];
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        img [i][j] = createImage (r, r, RGB);
      }
    }

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        //int ax=(int)map(noise(i, 0.01*frameCount*levelNumber/2), 0, 1, 0, r*levelNumber/3);
        int ax=(int)map(noise(i, 0.01*frameCount*levelNumber/2), 0, 1, 0, anx);
        if (anx>r*levelNumber/3) {
          anx=r*levelNumber/3;
        } else if (frameCount/5-r*levelNumber/3>0) {
          anx=r*levelNumber/3+xxx-frameCount/15;
        } else {
          anx=frameCount/5;
          xxx=frameCount/15;
        }
        if (anx<0) {
          frameCount=1;
          anx=0;
        }

        //int ay=(int)map(noise(j, 0.01*frameCount*levelNumber/2), 0, 1, 0, r*levelNumber/3);
        int ay=(int)map(noise(j, 0.01*frameCount*levelNumber/2), 0, 1, 0, any);
        if (any>r*levelNumber/3) {
          any=r*levelNumber/3;
        } else if (frameCount/5-r*levelNumber/3>0) {
          any=r*levelNumber/3+yyy-frameCount/15;
        } else {
          any=frameCount/5;
          yyy=frameCount/15;
        }
        if (any<0) {
          frameCount=1;
          any=0;
        }
        int sx = i*r+ax;
        int sy = j*r+ay;
        int sw=r;
        int sh=r;

        int dx = 0;
        int dy = 0;
        int dw = r;
        int dh = r;

        float x = map (i, 0, n, 0, width);
        float y = map (j, 0, m, 0, height);
        //glitches.image(map[eventNumber], 0, 0);
        img [i][j].copy (map[eventNumber], sx, sy, sw, sh, dx, dy, dw, dh); //source and destination == s and d
        //img [i][j].copy (images, sx, sy, sw, sh, dx, dy, dw, dh);
        glitches.image (img [i][j], x, y);
      }
    }

    glitches.textFont(font);
    glitches.fill(255);
    glitches.textSize(100);
    glitches.text(glitch.finalText.get(0), 100, height/16*9.5);
    glitches.textSize(50);
    glitches.text(glitch.finalText.get(1), 105, height/16*10.4);
    glitches.text(glitch.finalText.get(2), 105, height/16*11.1);
    glitches.textSize(70);
    glitches.text(glitch.finalText.get(3), 100, height/16*12.3);
    glitches.text(glitch.finalText.get(4), 100, height/16*13.4);
    glitches.text(glitch.finalText.get(5), 100, height/16*14.5);
  }
/*
  int r=0;
  int rrr=0;
  void triNoise() {
    glitches.noStroke();
    
    int r=ceil(tt/4)+4;
     if ( r>(int)((killed/(allPeople+1)*30+1)*10)) {
     r=(int)((killed/(allPeople+1)*30+1)*10);
     }
   
    if ( r>(int)((killed/(allPeople+1)*30+1)*10)) {
     r=(int)((killed/(allPeople+1)*30+1)*10);
     } else if (frameCount/5-(int)((killed/(allPeople+1)*30+1)*10)>4) {
     r=(int)((killed/(allPeople+1)*30+1)*10)+rrr-frameCount/8;
     } else {
     r=ceil(frameCount/5)+4;
     rrr=frameCount/8;
     } 
     if (r<4) {
     frameCount =1;
     r=4;
     }
    if ( r>(int)((killed/(allPeople+1)*30+1)*15)) {
      r=(int)((killed/(allPeople+1)*30+1)*15);
    } else if (frameCount/4-(int)((killed/(allPeople+1)*30+1)*15)>15) {
      r=(int)((killed/(allPeople+1)*30+1)*15)+rrr-frameCount/8;
    } else {
      r=ceil(frameCount/4)+15;
      rrr=frameCount/8;
    } 
    if (r<15) {
      frameCount =1;
      r=12;
    }
    //println(r);
    int trans=(int)(destroyed/allBuilding*200+15);
    if (trans==0) {
      trans=15;
    }

    //glitches.image(map[eventNumber],0,0);
    
    glitches.fill(255);
    glitches.textSize(100);
    glitches.text(finalText.get(0), 100, height/16*9.5);
    glitches.textSize(50);
    glitches.text(finalText.get(1), 105, height/16*10.4);
    glitches.text(finalText.get(2), 105, height/16*11.1);
    glitches.textSize(70);
    glitches.text(finalText.get(3), 100, height/16*12.3);
    glitches.text(finalText.get(4), 100, height/16*13.4);
    glitches.text(finalText.get(5), 100, height/16*14.5);
    
    for (int i=0;i<width/r;i+=1) {
      for (int j=0;j<height/r;j+=1) {
        int x=i*r;
        int y=j*r;
        int nx=(int)map(noise(nSeeds[i], 0.005*frameCount*levelNumber), 0, 1, 0, r);
        int ny=(int)map(noise(nSeeds[height/r-j], 0.005*frameCount*levelNumber), 0, 1, 0, r);
        if (i*j%2==0) {
          glitches.fill(map[eventNumber].get(x+nx, y+ny), trans);
          tri1(x, y, r);
          glitches.fill(map[eventNumber].get(x+r/2+nx, y+r/2+ny), trans);
          tri2(x, y, r);
        } else {
          glitches. fill(map[eventNumber].get(x+r+nx, y+ny), trans);
          tri3(x, y, r);
          glitches.fill(map[eventNumber].get(x+r+nx, y+r/2+ny), trans);
          tri4(x, y, r);
        }
      }
    }
    
    //if (textOn==true) {
     glitches.fill(255);
     glitches.textSize(100);
     glitches.text(finalText.get(0), 100, height/16*9.5);
     glitches.textSize(50);
     glitches.text(finalText.get(1), 105, height/16*10.4);
     glitches.text(finalText.get(2), 105, height/16*11.1);
     glitches.textSize(70);
     glitches.text(finalText.get(3), 100, height/16*12.3);
     glitches.text(finalText.get(4), 100, height/16*13.4);
     glitches.text(finalText.get(5), 100, height/16*14.5);
     //  }
     
    
    for (int i=0;i<width/r;i+=1) {
     for (int j=0;j<height/r;j+=1) {
     int x=i*r;
     int y=j*r;
     int nx=(int)map(noise(nSeeds[i], 0.005*frameCount*levelNumber), 0, 1, 0, r);
     int ny=(int)map(noise(nSeeds[height/r-j], 0.005*frameCount*levelNumber), 0, 1, 0, r);
     if (i*j%2==0) {
     glitches.fill(get(x+nx, y+ny), trans);
     tri1(x, y, r);
     glitches.fill(get(x+r/2+nx, y+r/2+ny), trans);
     tri2(x, y, r);
     } else {
     glitches. fill(get(x+r+nx, y+ny), trans);
     tri3(x, y, r);
     glitches.fill(get(x+r+nx, y+r/2+ny), trans);
     tri4(x, y, r);
     }
     }
     }
  }

  void tri1(int x, int y, int r) {
    glitches.beginShape();
    glitches.vertex(x, y);
    glitches. vertex(x, y+r);
    glitches.vertex(x+r, y+r);
    glitches. endShape();
  }

  void tri2(int x, int y, int r) {
    glitches.beginShape();
    glitches. vertex(x, y);
    glitches. vertex(x+r, y);
    glitches.vertex(x+r, y+r);
    glitches.endShape();
  }

  void tri3(int x, int y, int r) {
    glitches. beginShape();
    glitches. vertex(x, y);
    glitches.vertex(x+r, y);
    glitches. vertex(x, y+r);
    glitches. endShape();
  }

  void tri4(int x, int y, int r) {
    glitches. beginShape();
    glitches. vertex(x+r, y);
    glitches. vertex(x, y+r);
    glitches. vertex(x+r, y+r);
    glitches. endShape();
  }
  */
  //boolean ss=true;
  void upTodown() {

    int x1 = (int) random(0, width);
    int y1 = 0;

    int x2 = round(x1 + random(-killed/allPeople*100-1, killed/allPeople*100+1));
    int y2 = round(random(-destroyed/allBuilding*20-1, destroyed/allBuilding*20+1));

    int x3=round(x1 + random(-killed/allPeople*50-1, killed/allPeople*50+1));
    int y3=round(random(-destroyed/allBuilding*20-1, destroyed/allBuilding*20+1));
    int w3=(int) random(map(levelNumber, 6, 9, 2, 5));

    int w = (int) random(map(levelNumber, 6, 9, width/2-200, width/2+200));
    int h = height;

    glitches.copy(x1, y1, w, h, x2, y2, w, h);
    glitches.endDraw();
    /*
    if (textOn==true) {
     glitches.fill(255);
     glitches.textSize(100);
     glitches.text(finalText.get(0), 100, height/16*10);
     glitches.textSize(50);
     glitches.text(finalText.get(1), 100, height/16*11);
     glitches.text(finalText.get(2), 100, height/16*12);
     glitches.textSize(70);
     glitches.text(finalText.get(3), 100, height/16*13);
     glitches.text(finalText.get(4), 100, height/16*14);
     glitches.text(finalText.get(5), 100, height/16*15);
     }
     */
    //copy(map[eventNumber], x1, y1, w, h, x2, y2, w, h);
    /*
    if (textOn==true) {
     textFont(font);
     fill(255);
     textSize(100);
     text(finalText.get(0), 100, height/16*9.5);
     textSize(50);
     text(finalText.get(1), 105, height/16*10.4);
     text(finalText.get(2), 105, height/16*11.1);
     textSize(70);
     text(finalText.get(3), 100, height/16*12.3);
     text(finalText.get(4), 100, height/16*13.4);
     text(finalText.get(5), 100, height/16*14.5);
     }*/
    //copy(x1, y1, w, h, x2, y2, w, h);
    //copy(x1, y1, w, h, x2, y2, w, h);

    images.beginDraw();
    //images.image(map[eventNumber], 0, 0);
    if (textOn==true) {
      images.textFont(font);
      images.fill(255);
      images.textSize(100);
      images.text(finalText.get(0), 100, height/16*9.5);
      images.textSize(50);
      images.text(finalText.get(1), 105, height/16*10.4);
      images.text(finalText.get(2), 105, height/16*11.1);
      images.textSize(70);
      images.text(finalText.get(3), 100, height/16*12.3);
      images.text(finalText.get(4), 100, height/16*13.4);
      images.text(finalText.get(5), 100, height/16*14.5);
    }
    images.copy(x1, y1, w3, h, x3, y3, w3, h);
    images.endDraw();
    image(glitches, 0, 0);
    image(images, 0, 0);
  }


  int xx1=0, yy1=0;
  void squareBlur() {

    int xx=(int) map(killed/allPeople*1000, 0, 100, 0, 50)+(int)map(noise(levelNumber, 0.01*frameCount*levelNumber/2), 0, 1, levelNumber*4, levelNumber*5);
    int yy=(int) map(destroyed/allBuilding*100, 0, 100, 0, 20)+(int)map(noise(levelNumber, 0.01*frameCount*levelNumber/2), 0, 1, levelNumber*4, levelNumber*5);
    if (xx1>xx) {
      xx1=xx;
    } else if (frameCount/5-xx>0) {
      xx1=xx+(int)xxx-frameCount/5;
    } else {
      xx1 = frameCount/5;
      xxx= frameCount/5;
    }
    if (xx1<0) {
      frameCount=1;
      xx1=0;
    } 
    //println(xx1);
    if (yy1>yy) {
      yy1=yy;
    } else if (frameCount/5-yy>0) {
      yy1=yy+(int)yyy-frameCount/5;
    } else {
      yy1 = frameCount/5;
      yyy=frameCount/5;
    }

    if (yy1<0) {
      frameCount=1;
      yy1=0;
    } 
    /*
    for (int i=0;i<width*height;i++) {
     int x=i%width;
     int y=i/width;
     int r=(int)red(map[eventNumber].get(x, y));
     int g=(int)green(map[eventNumber].get(x, y));
     int b=(int)blue(map[eventNumber].get(x, y));
     
     color c=color(r, g, b);
     glitches.set(x^xx1, y^yy1, c);
     }
     glitches.endDraw();
     image(glitches, 0, 0);
     */

    texts.beginDraw();
    texts.image(map[eventNumber], 0, 0);
    texts.textFont(font);
    texts.fill(255);
    texts.textSize(100);
    texts.text(finalText.get(0), 100, height/16*9.5);
    texts.textSize(50);
    texts.text(finalText.get(1), 105, height/16*10.4);
    texts.text(finalText.get(2), 105, height/16*11.1);
    texts.textSize(70);
    texts.text(finalText.get(3), 100, height/16*12.3);
    texts.text(finalText.get(4), 100, height/16*13.4);
    texts.text(finalText.get(5), 100, height/16*14.5);
    for (int i=0;i<width*height;i++) {
      int x=i%width;
      int y=i/width;

      color c=texts.get(x, y);
      texts.set(x^xx1, y^yy1, c);
    }
    texts.endDraw();
    image(texts, 0, 0);
  }
}

class Particle {
  float x;
  float y;
  int c;
  float speed = 2;
  Particle(int x, int y, int c) {
    this.x = x;
    this.y = y;
    this.c = c;
  }
  void update() {
    float noiseVal = noise(x*noiseScale, y*noiseScale, noiseZ);
    float angle = noiseVal*2*PI;
    x += speed * cos(angle);
    y += speed * sin(angle);

    if (x < -particleMargin) {
      x += width + 2*particleMargin;
    } else if (x > width + particleMargin) {
      x -= width + 2*particleMargin;
    }

    if (y < -particleMargin) {
      y += height + 2*particleMargin;
    } else if (y > height + particleMargin) {
      y -= height + 2*particleMargin;
    }
    glitches.stroke(c);
    glitches.point(x, y);
  }
}

