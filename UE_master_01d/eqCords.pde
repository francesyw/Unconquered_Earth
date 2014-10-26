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
      ellipse(0, 0, 0.7, 0.7);
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
        translate(0, 0, -5);
        if (!drawRawLon.contains(destrRawLon)) {
          drawRawLon.add(destrRawLon);
          drawSize.add(2.1);
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
            draw3D(11.5);

            //                hint(DISABLE_DEPTH_TEST);            
            pushStyle();
            pushMatrix();
            translate(0, 0, -7);
            rotateX(radians(180));
            rotateY(radians(0));
            rotateZ(radians(90));


            //---//  "Selection" data visuals //---//
            // Hover over to view more info 
            //(commented out old code)


            // rectMode(CENTER);
            // fill(0, 180);
            // stroke(0, 255, 255);

            // rect(0, 0, 302, 13);
            // rect(0,10, 51, 17);
            // fill(129, 228, 232, 217);
            // blue fill 
            fill(255, 255, 255, 255);
            //white fill
            //fill(0, 234, 250, 120);
            
            textFont(font2);
            // textSize(1.5);
            textSize(5.0);
            //textAlign(RIGHT);
            textAlign(LEFT);
            //textLeading(3);
            textLeading(9);
            //text(destrName+", "+destrCountry+"\n"+destrYear+"\n"+"Magnitude "+destrMag, -8, -2, 2);

            // Line #1 = name of place

            text(destrName, 4, 0, 3);
            textSize(3.5);

            // Line #2 = name of Country

            //text(destrKilled+" killed"+"\n"+destrInjured+" injured"+"\n"+destrHomeless+" homeless", 9, -2, 2);
            text(destrCountry, 4, 4, 2);

            //Line #3 = magnitude size

            fill(255,255);
            textAlign(CENTER);
            textSize(6.5);
            text(destrMag, -8, 2, 1.5);
            popMatrix();
            popStyle();
            //                hint(ENABLE_DEPTH_TEST);
          } else {
            draw3D(2.5);
          }
          //on this line now.

          sizeIndex = drawRawLon.indexOf(destrRawLon);
          drawSize.set(sizeIndex, lerp(drawSize.get(sizeIndex), 2.3, 0.8));  
   //put this back after testing      
   
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
          textFont(font2);
          //textAlign(CENTER);
          //textSize(2.0);

          // fill(255);
          //hover over to small name (not needed anymore)
          //text(destrName, 0, 0, 10);

          popMatrix();
          popStyle();
          hint(ENABLE_DEPTH_TEST);
        } else if (destrRawLon >= (centerLon+5)) {
          sizeIndex = drawRawLon.indexOf(destrRawLon);
          drawSize.set(sizeIndex, lerp(drawSize.get(sizeIndex), 2.0, 0.1));         
         // draw3D(drawSize.get(sizeIndex));
        }
        popMatrix();
      } else {

        if (drawRawLon.remove(destrRawLon)) {            
          drawSize.remove(0);
        }

        // determines default size of the markers
        //keep this one
        draw3D(1.8);
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
    //---// This fills the destruction markers //---//

    pushMatrix();
    //---// These are the destruction 3d markers //---//
    fill(0, 234, 250, 120);
    stroke(5, 240, 250, 255);
    rotate(PI/4);
    rect(0, 0, t, t);
    popMatrix();
    
/*
    if (destrRawLon == triggerEvent) {
      pushMatrix();
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
      popMatrix();
    }
    */
  }
  void draw3Dhour(float t) {

    //---// This draws the hour Markers //---//
    //stroke(255, 73, 1, 255);
    stroke(245, 22, 0, 255);

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

