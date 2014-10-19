class leapControl {

  boolean oneFinger = false;
  boolean leap_trigger = false;
  boolean osc_trigger = false;
  float r_yStart;
  boolean isZoom;
  char zoomGlobe = 'D';
  int triGlitch_osc;
  float zoom = 370;
  float triggerEvent;

  void isOneFinger() {

    if (num_finger > 1) {
      oneFinger = false;
    } else {
      oneFinger = true;
    }
  }


  void handControl() {

    //--HANDS controlling the globe    
    if (hand_position.z >= 30) {
      // println("hand_position.y: "+hand_position.y);
      if (hand_position.x <= 1200.0 && hand_position.x >= 100.0) {

        if (!oneFinger) {               
          if (leap_trigger) {
            r_yStart = setRotationY(hand_position.x, r_mapY);
            leap_trigger = false;
          }

          //--Rotate the globe left-right 
          r_mapY = map(hand_position.x, 100.0, 1200.0, r_yStart, r_yStart+270);

          //--Rotate the globe up-down
          r_mapX = map(hand_roll, 38, -37, 40, -50);  

          //--Limit the rotationX range
          if (r_mapX < -50.0) {
            r_mapX = -50.0;
          } else if (r_mapX > 40.0) {
            r_mapX = 40.0;
          }
          
          osc_trigger = false;
          
        } else {
//          println(hand_position.y);
          //--Use one finger to trigger the event  
          if (hand_position.y < 500 && hand_position.y > 120 && !osc_trigger) {

            //--randomly trigger an event within the area.
            if (eqCords.drawRawLon.size()!= 0) {
              triGlitch_osc = eqData.destrRawLonList.indexOf(triggerEvent);
  
              println("trigger || Lon: "+triggerEvent+" | Index: "+triGlitch_osc);
              osc.send();
              osc_trigger = true;
            }
          }
          
        }
      } else {
        r_mapY += 0.05;
      }
    } else {
      leap_trigger = true;
      r_mapY += 0.05;
    }
  }	

  float setRotationY(float hand_positionX, float r_mapY_start) {
    r_yStart = r_mapY_start - ((270.0 / (1200.0-100.0)) * (hand_positionX-100.0));
    return r_yStart;
  }
}

