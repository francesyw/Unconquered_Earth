//import java.util.*;

class eqCords {

  float lon;
  float lat;
  float mag;
  float mapMag;
  float magMin;
  float magMax;
  float rS = globeR;  // *r from the surface
  float rD;           // *r from the depth
  float z;
  PVector drawPosS = new PVector(); // *position of the obj on surface
  PVector drawPosD = new PVector(); // *position of the obj inside the globe
  float centerLon;
  float centerLat;
  float currentCenterLon;
  float currentCenterLat;
  float r_mapY_b;
  int r_mapY_a;
  float destrRawLon;
  float destrRawLat;
  String destrName;
  String destrCountry;
  String destrYear;
  String destrMag;
  String destrKilled;
  String destrInjured;
  String destrHomeless;
  String destrINFO;
  String destrDATA;
  
  ArrayList<Float> drawSize = new ArrayList<Float>();
  ArrayList<Float> drawRawLon = new ArrayList<Float>();
  ArrayList<Float> drawRawLat = new ArrayList<Float>();
  int sizeIndex;
  boolean textOnce;
  float triggerEvent;
  int index;

  int ii;
  public void update() {   
    rS = globeR;
    // *Generate the vector of the obj on the surface
    drawPosS = sphereToCart(lon, lat, rS);

    // *Generate the vector of the obj inside the globe
    drawPosD = sphereToCart(lon, lat, rD);
    //    magMax = Collections.max(eqData.magList);
    //    magMin = Collections.min(eqData.magList);
    //    mapMag = map(mag, magMin, magMax, 0.3, 1.5);
  }


  public void render(char dataFeeds) {
    pushMatrix();

    //--Convert Processing coordinate system to Geo coordinate system
    rotateZ(radians(-90));
    rotateY(radians(-90));

    pushMatrix();
    //--Move to the position of this item
    translate(drawPosS.x, drawPosS.y, drawPosS.z);
    rotateZ(radians(lon));
    rotateY(radians(lat));

    switch (dataFeeds) {

    case 'M' :           
      stroke(164, 246, 7, 0);
      fill(9, 250, 9, 255);
//      triangle(1, 1, 1, 0, 0, 1);
      ellipse(0,0,0.7,0.7);
      break;

    case 'H' : 
      hint(ENABLE_DEPTH_TEST);
      pushMatrix();          
      rotateX(radians(180));
      rotateZ(radians(0));
      translate(0, 0, -2);
      draw3Dhour(0.5);
      popMatrix();
      break; 

    case 'D' :
      hint(ENABLE_DEPTH_TEST);
      pushMatrix();          
      rotateX(radians(180));
      rotateZ(radians(0));
      translate(0, 0, -2.6); 
      r_mapY_b = (r_mapY+270)/360;

      if (r_mapY_b < 0) {
        r_mapY_a = -ceil(abs(r_mapY_b));
      } else {
        r_mapY_a = floor(abs(r_mapY_b));
      }

      centerLon = (-90 - r_mapY) + 360*r_mapY_a;
      centerLat = -r_mapX;

      if (destrRawLon > (centerLon-5) && destrRawLon < (centerLon+8) && destrRawLat > (centerLat-8) && destrRawLat < (centerLat+8)) {
        pushMatrix();
        translate(0,0,-5);
        if (!drawRawLon.contains(destrRawLon)) {
          drawRawLon.add(destrRawLon);
          drawSize.add(1.5);
          //              println(" RawLon: "+drawRawLon.get(drawRawLon.size()-1)+" | "+drawSize.size()+" objs");
        } else if (destrRawLon > (centerLon-5) && destrRawLon < (centerLon+5)) {                    

            if (!textOnce) {
              index = int(random(drawRawLon.size()));            
              triggerEvent = drawRawLon.get(index);
              leapC.triggerEvent = triggerEvent;
              currentCenterLon = centerLon;
              currentCenterLat = centerLat;
              textOnce = true;
            }

            if (abs(centerLon - currentCenterLon) > 2 || abs(centerLat - currentCenterLat) > 2) {
              textOnce = false;
            }
            
            if (destrRawLon == triggerEvent) {
              draw3D(4.5);
              
              //                hint(DISABLE_DEPTH_TEST);            
              pushStyle();
              pushMatrix();
              translate(0,0,-7);
              rotateX(radians(180));
              rotateY(radians(0));
              rotateZ(radians(90));
              noStroke();
              rectMode(CENTER);
              fill(0, 170);
//              rect(0, 0, 302, 13);
              fill(129, 228, 232, 217);
              textFont(font);
              textSize(1.5);
              textAlign(RIGHT);
              textLeading(3);
              text(destrName+", "+destrCountry+"\n"+destrYear+"\n"+"Magnitude "+destrMag, -8, -2, 2);
              textAlign(LEFT);
              text(destrKilled+" killed"+"\n"+destrInjured+" injured"+"\n"+destrHomeless+" homeless", 9, -2, 2);
              popMatrix();
              popStyle();
              //                hint(ENABLE_DEPTH_TEST);
            } else {
              draw3D(1.5);
            }

            sizeIndex = drawRawLon.indexOf(destrRawLon);
            drawSize.set(sizeIndex, lerp(drawSize.get(sizeIndex), 4.0, 1.5));         
            draw3D(drawSize.get(sizeIndex));
            hint(DISABLE_DEPTH_TEST); 
            pushStyle();
            pushMatrix();
            translate(0, 0, -1); 
            rotateX(radians(180));
            rotateY(radians(0));
            rotateZ(radians(90));
            fill(255, 255, 255, 255);
            noStroke();
            textFont(font);
            textAlign(CENTER);
            textSize(2.0);
            //
            fill(255);
            text(destrName, 0, 0, 10);
            popMatrix();
            popStyle();
            hint(ENABLE_DEPTH_TEST);
            
        } else if (destrRawLon >= (centerLon+5)) {
          sizeIndex = drawRawLon.indexOf(destrRawLon);
          drawSize.set(sizeIndex, lerp(drawSize.get(sizeIndex), 1.5, 0.1));         
          draw3D(drawSize.get(sizeIndex));
        }
        popMatrix();
      } else {

        if (drawRawLon.remove(destrRawLon)) {            
          drawSize.remove(0);
        }
        draw3D(1.5);
        
      }

      popMatrix();
      break;
    }

    popMatrix();
    hint(DISABLE_DEPTH_TEST);
    stroke(255, 80);
    line(drawPosS.x, drawPosS.y, drawPosS.z, drawPosD.x, drawPosD.y, drawPosD.z);

    popMatrix();
  }


  //Spherical Coordinates
  PVector sphereToCart(float lon, float lat, float r) {
    PVector v = new PVector();
    //  *Degrees to radians
    float theta = ((lat)/180) * PI ;
    float phi = ((lon)/180) * PI ;

    //  *Convert spherical coordinates into Cartesian coordinates
    v.x = cos(phi) * sin(theta) * r;
    v.y = sin(phi) * sin(theta) * r;
    v.z = cos(theta) * r;

    return(v);
  }

  void draw3D(float t) {
    fill(250, 159, 1, 130);
    pushMatrix();
    stroke(254, 151, 4, 255);
    rotate(PI/4);
    //  ellipse(0,0,0.1,0.1);
    rect(0, 0, 1.3, 1.3);
    //    ellipse(0, 0, 1.5, 1.5);
//    triangle (-1,-1,2,0,0,2);

    popMatrix();
/*
    stroke(2, 252, 214, 50);

    beginShape(TRIANGLES);

    fill(16, 49, 154, 255);
    vertex(-t, -t, -t);
    vertex( t, -t, -t);
    vertex( 0, 0, t*2);

    fill(16, 241, 154, 255);
    vertex( t, -t, -t);
    vertex( t, t, -t);
    vertex( 0, 0, t*2);

    fill(27, 200, 255, 255);
    vertex( t, t, -t);
    vertex(-t, t, -t);
    vertex( 0, 0, t*2);

    fill(75, 25, 250, 255);
    vertex(-t, t, -t);
    vertex(-t, -t, -t);
    vertex( 0, 0, t*2);

    endShape();
*/
  }
  void draw3Dhour(float t) {

    stroke(255, 73, 1, 255);

    beginShape(TRIANGLES);

//    fill(251, 247, 243, 255);
    noFill();

    vertex(-t, -t, -t);
    vertex( t, -t, -t);
    vertex( 0, 0, t*1);

//    fill(251, 123, 45, 255);
    vertex( t, -t, -t);
    vertex( t, t, -t);
    vertex( 0, 0, t*2);

//    fill(246, 157, 122, 255);
    vertex( t, t, -t);
    vertex(-t, t, -t);
    vertex( 0, 0, t*1);

//    fill(254, 253, 253, 255);
    vertex(-t, t, -t);
    vertex(-t, -t, -t);
    vertex( 0, 0, t*2);

    endShape();

  }
}

