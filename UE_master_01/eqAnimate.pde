class eqAnimate {

  //Spherical Coordinates
  //  float theta;
  //  float phi;
  float lon;
  float lat;
  float rS = globeR;  // *r from the surface
  float rD;           // *r from the depth
  PVector drawPosS = new PVector(); // *position of the obj on surface
  PVector drawPosD = new PVector(); // *position of the obj inside the globe
  String title;

  public void update() {   
    //////here!!!
    rS = globeR;
    // *Generate the vector of the obj on the surface
    drawPosS = sphereToCart(lon, lat, rS);
    // *Generate the vector of the obj inside the globe
    drawPosD = sphereToCart(lon, lat, rD);
  }


  public void render(char dataFeeds) {
    hint(ENABLE_DEPTH_TEST);
    pushMatrix();

    //  *Convert Processing coordinate system to Geo coordinate system
    rotateZ(radians(-90));
    rotateY(radians(-90));

    pushMatrix();

    translate(drawPosS.x, drawPosS.y, drawPosS.z);
    rotateZ(radians(lon));
    rotateY(radians(lat));   
    switch (dataFeeds) {
    case 'H':
      pushMatrix();          
      rotateX(radians(180));
      rotateZ(radians(0));
      translate(0, 0, -1);
      draw3D(0.8);
      popMatrix();
      break;
    }
    popMatrix();

    popMatrix();
  }

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

  void textForNew() {
    String[] titleList=split(title, "-");
    String[] titleList1=split(titleList[1], " of ");
    //String finalTitle=  titleList[0]+" / "+titleList1[0]+"  / "+titleList1[1];
    String text1=titleList1[1];
    String text2=titleList[0];
    pushMatrix();
    pushStyle();
    textAlign(CENTER, CENTER);
    noStroke();
    if (isHands == true || mousePressed == true){
        fill(253,160,85,139);
    } else {
        fill(253, 81, 53, 90);
    }
    
    scale(0.1);
    textFont(font2);
    translate(0, -109, 6);
    rotate(PI/2);
    rotateY(PI);

    text(text1, 15, 0);
    text(text2, 15, 15);
    popStyle();
    popMatrix();
  }

  void draw3D(float t) {

    pushMatrix();
    translate(0, 0, t);
    noFill();
    circle(t*10);
    hint(DISABLE_DEPTH_TEST);
    textForNew();
    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }

  void circle(float r) {
    float plus=0;
    for (int i=2;i<r+1;i++) {

      plus=frameCount/2;
      strokeWeight(0.7);
      stroke(230,87,54,60);
      ellipse(0, 0, (i+plus)%9, (i+plus)%9);
    }
  }
}

