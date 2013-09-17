

// Used by drawWeatherBlock -- TO DO move to local scope
HDrawablePool squarePool;
HColorPool weatherColors;

// Set this to your Yahoo GeoPlanet Where On Earth ID (WOEID)
String myWOEID = "2487889";


void setup() {
  size(640,480);
  smooth();
  noLoop();

  // Initialize HYPE
  H.init(this).background(#202020);

  // Fetch the first five days' Yahoo weather forecasts for our WOEID.
  int[] forecastCodes = fetchForecastCodes();

  // Iterate through the five day forecast, draw blocks for each.
  int[] pro = new int[5];
  for ( int i = 0 ; i < 5 ; i++ ) {
    pro = convertCodeToProportion(forecastCodes[i]);
    drawWeatherBlock( ( 16+(128*i)), 16,
                        pro[0], pro[1], pro[2],
                        pro[3], pro[4] );
  }


  // Show it.
  H.drawStage();
}

void draw() {

}


/*  void drawWeatherBlock()

  Draws a four-by-four "block" of weather colored squares.
  Pass in the startX and startY of the first square in the block
  keeping in mind, we're anchoring at H.CENTER.

  The other variables set the proportion of weather colors to 
  put in the pool that we'll pick fill colors from.
                                                              */

void drawWeatherBlock ( int myStartX, int myStartY,
                        int sunny, int bluey, int cloudy, 
                        int rain, int meteors ) {
  // Put some weather-related colors in a pool.
  weatherColors = new HColorPool()
  .add(#FFE800, sunny)   // sunny
  .add(#8FDDF0, bluey)    // blue skies
  .add(#CCCCCC, cloudy)  // cloudy
  .add(#333333, rain)    // rain cloudy
  .add(#9E4AFF, meteors) // lavender.  why?  don't know.
  ;

  // Throw sixteen boring HRects in a pool.
  squarePool = new HDrawablePool(16)
    .autoAddToStage()
    .add ( 
      new HRect(), 16
    )

    // Apply a grid layout.  Fits thirty-by-thirty-sized squares nicely.
    .layout (
      new HGridLayout()
        .startX(myStartX)
        .startY(myStartY)
        .spacing(32,32)
        .cols(4)
    )

    // Make thirty-by-thirty squares, filled with weatherColors.
    .onCreate (
       new HCallback() {
        public void run(Object obj) {
          HDrawable d = (HDrawable) obj;
          d
            .noStroke()
            .fill( weatherColors.getColor() )
            .anchorAt(H.CENTER)
            .size( 30 )
          ;
        }
      }
    )

    .requestAll()
  ;

}


/*
  int[] fetchForecastCodes()
  
  Fetch a weather forecast from Yahoo for myWOEID.
  Parse the RSS' XML to find the first five forecasts.
  Extract the "code" for that forecast, which corresponds to
  the "human" meaning of the forecast, e.g. "partly cloudy," or
  "rainy."
  Return an array of the first five forecast codes.  
                                                      */

int[] fetchForecastCodes() {

  int[] fetchedForecastCodes = new int[5];

  // Set a more informative user-agent, in case ops get curious.
  System.setProperty("http.agent", "abstractForecast; https://github.com/fnaard/abstractForecast;");
  
  // Fetch weather forecast for myWOEID, which is set up top.
  // XML weatherXML = loadXML("http://xml.weather.yahoo.com/forecastrss?w=" + myWOEID);
  XML weatherXML = loadXML("forecastrss.xml");  // DEBUG

  XML forecastXML[] = weatherXML.getChildren("channel/item/yweather:forecast");

  for ( int i = 0 ; i < 5 ; i++ ) {
    fetchedForecastCodes[i] = forecastXML[i].getInt("code");
  }

  return fetchedForecastCodes;
}

/*
  int[] convertCodeToProportion()
  Take a Yahoo forecast "code" and return a proportion of colors
  to use when you want to draw a block.
                                              */

int[] convertCodeToProportion( int forecastCode ) {
  int colorProportion[] = new int[5];

  switch(forecastCode) {
    case 32:
      colorProportion[0] = 10;
      colorProportion[1] = 20;
      colorProportion[2] = 50;
      colorProportion[3] = 10;
      colorProportion[4] = 10;
      break;
    default:
      colorProportion[0] = 90;
      colorProportion[1] = 10;
      colorProportion[2] =  0;
      colorProportion[3] =  0;
      colorProportion[4] =  0;
      break;
  }
  return colorProportion;
}
