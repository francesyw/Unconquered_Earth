class eqData {

  JSONObject eqEvents;
  JSONObject metadata;
  JSONArray features;
  JSONObject objFeatures;
  JSONObject properties;
  JSONObject geometry;
  JSONArray coordinates;

  int count;
  int countFilter;
  int countHour;
  int countSet0;
  int newEvent;
  float mag;
  float longitude;
  float latitude;
  float depth;
  long time;
  String place;
  String title;

  float mapLong;
  float mapLat;
  float mapDepth;
  float  mapMag;

  Table destrTable;
  TableRow destrRow;
  float destrLon;
  float destrLat;
  float destrDepth;
  String destrName;
  String destrCountry;
  String destrYear;
  String destrMag;
  String destrKilled;
  String destrInjured;
  String destrHomeless;

  ArrayList<Float> latList = new ArrayList<Float>();
  ArrayList<Float> lonList = new ArrayList<Float>();
  ArrayList<Float> depthList = new ArrayList<Float>();
  ArrayList<Float> magList = new ArrayList<Float>();
  ArrayList<Long> timeList = new ArrayList<Long>();
  ArrayList<Float> depth0List = new ArrayList<Float>();
  ArrayList<String>placeList = new ArrayList<String>();
  ArrayList<Float> mag0List = new ArrayList<Float>();
  ArrayList<String>titleList=new ArrayList<String>();
  //  ArrayList<String>place0List = new ArrayList<String>();

  ArrayList<Float> destrLonList = new ArrayList<Float>();
  ArrayList<Float> destrLatList = new ArrayList<Float>();
  ArrayList<Float> destrDepthList = new ArrayList<Float>();
  ArrayList<Float> destrRawLonList = new ArrayList<Float>();
  ArrayList<Float> destrRawLatList = new ArrayList<Float>();
  ArrayList<String> destrNameList = new ArrayList<String>();
  ArrayList<String> destrCountryList = new ArrayList<String>();
  ArrayList<String> destrYearList = new ArrayList<String>();
  ArrayList<String> destrMagList = new ArrayList<String>();
  ArrayList<String> destrKilledList = new ArrayList<String>();
  ArrayList<String> destrInjuredList = new ArrayList<String>();
  ArrayList<String> destrHomelessList = new ArrayList<String>();

  void init(String URL) {
    eqEvents = loadJSONObject(URL);
    metadata = eqEvents.getJSONObject("metadata");
    count = metadata.getInt("count");
    features = eqEvents.getJSONArray("features");

    destrTable = loadTable("Destruction Data_03.csv", "header");
    destrData();
    //    println(destrLonList);
    //    println(destrLatList);
    //    println(destrDepthList);
  }

  void update(char dataFeeds) {

    countFilter = 0;
    countHour = 0;
    //    countSet0 = 0;

    for (int i=0; i<count; i++) {
      objFeatures = features.getJSONObject(i);
      properties = objFeatures.getJSONObject("properties");
      if (properties.isNull("mag")==true) {
        properties.setInt("mag", 0);
      }
      mag = properties.getFloat("mag");          
      place = properties.getString("place");
      time = properties.getLong("time");
      geometry = objFeatures.getJSONObject("geometry");
      coordinates = geometry.getJSONArray("coordinates");
      title=properties.getString("title");
      longitude = coordinates.getFloat(0);
      latitude = coordinates.getFloat(1);
      depth = coordinates.getFloat(2);

      // *Adjust the offset between the actual coordinates and the world map image.
      mapLong = map(longitude, -180.0, 180.0, -90.0, 270.0);
      mapLat = map(latitude, -90.0, 90.0, 0.0, 180.0);
      mapDepth = globeR - (globeR*depth/earthRadius);
      //      mapMag = map(mag, 0, 7.5, 0.4, 1.5);    
      switch(dataFeeds) {

        // *For all_month data (only read once)
      case 'M':
        // *filter out the events with mag <= 2.5               
        if (mag >= 2.5) {
          latList.add(countFilter, mapLat);
          lonList.add(countFilter, mapLong);
          depthList.add(countFilter, mapDepth);        
          magList.add(countFilter, mag);    
          placeList.add(0, place); 
          titleList.add(0, title);      
          countFilter++;  
          // println(countFilter);
        }
        break;

        // *For all_hour data (checking every other minute)
      case 'H':                          
        // *Only add new data. Skip repeated events.              

        if (!latList.contains(mapLat)) {
          // newEvent = latList.size();
          latList.add(0, mapLat);
          lonList.add(0, mapLong);
          depthList.add(0, mapDepth);
          placeList.add(0, place);
          titleList.add(0, title);
          magList.add(0, mag);
          countHour++;
        }
        println("List Size: " + latList.size() + "  |  Count: " + countHour + "  |  Original Size: " + originalSize);
        // println(latList);
        break;

      case 'S':
        depth0List.add(0, depth);
        mag0List.add(0, mag);
        timeList.add(0, time);
        //        place0List.add(0, place);
        //        countSet0++;
        break;
      }

      //println(mag + "," + place + "," + "(" + longitude+ ","+latitude+ ","+depth + ")");
    }
  }


  void destrData() {

    float mapLong;
    float mapLat;
    float mapDepth;

    for (int i=0; i<71; i++) {
      destrRow = destrTable.getRow(i);
      destrLon = float(destrRow.getString("Longitude"));
      destrLat = float(destrRow.getString("Latitude"));
      destrDepth = float(destrRow.getString("Focal depth (km)"));
      destrName = destrRow.getString("Event Name");
      destrYear = destrRow.getString("Year");
      destrMag = destrRow.getString("Magnitude");
      destrCountry = destrRow.getString("Country");
      destrKilled = destrRow.getString("People killed string");
      destrInjured = destrRow.getString("People injured string");
      destrHomeless = destrRow.getString("People homeless string");

      mapLong = map(destrLon, -180.0, 180.0, -90.0, 270.0);
      mapLat = map(destrLat, -90.0, 90.0, 0.0, 180.0);
      mapDepth = globeR - (globeR*destrDepth/earthRadius);

      destrLonList.add(0, mapLong);
      destrLatList.add(0, mapLat);
      destrDepthList.add(0, mapDepth);
      destrRawLonList.add(0, destrLon);
      destrRawLatList.add(0, destrLat);
      destrNameList.add(0, destrName);
      destrCountryList.add(0, destrCountry);
      destrYearList.add(0, destrYear);
      destrMagList.add(0, destrMag);
      destrKilledList.add(0, destrKilled);
      destrInjuredList.add(0, destrInjured);
      destrHomelessList.add(0, destrHomeless);
    }
  }
}

