class eqData {

  JSONObject eqEvents;
  JSONObject metadata;
  JSONArray features;
  JSONObject objFeatures;
  JSONObject properties;
  JSONObject geometry;
  JSONArray coordinates;

  int count;
  int countHour;
  int newEvent;

  String title;
  ArrayList<String>titleList=new ArrayList<String>();
  //  ArrayList<String>place0List = new ArrayList<String>();

  void init(String URL) {
    eqEvents = loadJSONObject(URL);
    metadata = eqEvents.getJSONObject("metadata");
    count = metadata.getInt("count");
    features = eqEvents.getJSONArray("features");
  }

  void update(char dataFeeds) {
    countHour = 0;

    for (int i=0; i<count; i++) {
      objFeatures = features.getJSONObject(i);
      properties = objFeatures.getJSONObject("properties");
      title=properties.getString("title");

      switch(dataFeeds) {

      case 'M':
        titleList.add(0, title);      
        break;
        // *For all_hour data (checking every other minute)
      case 'H':                          
        // *Only add new data. Skip repeated events.              

        if (!titleList.contains(title)) {
          // newEvent = latList.size();
          titleList.add(0, title);
          countHour++;
        }
        //println("List Size: " + latList.size() + "  |  Count: " + countHour + "  |  Original Size: " + originalSize);
        // println(latList);
        break;
      }
      //println(mag + "," + place + "," + "(" + longitude+ ","+latitude+ ","+depth + ")");
    }
  }
}

