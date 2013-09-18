/*  Abstract Forecast

    This Processing sketch queries the Yahoo weather API to get a
    five-day forecast for a location.  It then draws a four-by-four
    block of colored squares to represent a day's forecast.  It draws
    one for each day, across the page.

                                                          */


// First specify your Yahoo weather Where On Earth ID.  Tips here:
//   http://developer.yahoo.com/weather/#req

String myWOEID = "2487889";


// Everything happens in setup().  We just run once.

void setup() {
  size(640,128);
  smooth();
  noLoop();

  // Initialize HYPE with a grey background.
  H.init(this).background(#202020);

  // Fetch the first five days' Yahoo weather forecast codes for our WOEID.
  int[] forecastCodes = fetchForecastCodes();

  // Iterate through the five day forecast, draw a block for each, in a row.
  for ( int i = 0 ; i < 5 ; i++ ) {
    int[] proportion = convertCodeToProportion(forecastCodes[i]);
    drawWeatherBlock(( 16 + (128*i) ), 16,
                      proportion[0],
                      proportion[1],
                      proportion[2],
                      proportion[3],
                      proportion[4] 
                    );
    // DEBUG
    // print( "day: " + i + "  code: " + forecastCodes[i] + "  {");
    // print( " sunny: " + proportion[0] );
    // print( "  blue: " + proportion[1] );
    // print( "  cloudy: " + proportion[2] );
    // print( "  rainy: " + proportion[3] );
    // print( "  meteors: " + proportion[4] );
    // println(" }");
  }


  // Show it.
  H.drawStage();

}

// Everything happens in setup(), we only run once.
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
  final HColorPool weatherColors = new HColorPool()
  .add(#FFE800, sunny)   // sunny
  .add(#8FDDF0, bluey)    // blue skies
  .add(#CCCCCC, cloudy)  // cloudy
  .add(#333333, rain)    // rain cloudy
  .add(#9E4AFF, meteors) // lavender.  why?  don't know.
  ;

  // Throw sixteen boring HRects in a pool.
  HDrawablePool squarePool = new HDrawablePool(16)
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
  XML weatherXML = loadXML("http://xml.weather.yahoo.com/forecastrss?w=" + myWOEID);
  // XML weatherXML = loadXML("forecastrss.xml");  // DEBUG

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

  Human readable equivalents of the codes are located here:
    http://developer.yahoo.com/weather/#codes
                                              */

int[] convertCodeToProportion( int forecastCode ) {
  
  int colorProportion[] = new int[5];

  //                       { sunny, blue, cloudy, rainy, meteors }
  switch(forecastCode) {
    case 26:  // cloudy
      colorProportion = new int[] {  0, 10, 90,  0,  0}; break;
    case 27:  // mostly cloudy night
      colorProportion = new int[] {  0, 25, 75,  0,  0}; break;
    case 28:  // mostly cloudy day
      colorProportion = new int[] {  0, 25, 75,  0,  0}; break;
    case 29:  // partly cloudy night
      colorProportion = new int[] {  0, 50, 50,  0,  0}; break;
    case 30:  // partly cloudy day
      colorProportion = new int[] {  0, 50, 50,  0,  0}; break;
    case 31:  // clear night
      colorProportion = new int[] {  0, 90, 10,  0,  0}; break;
    case 32:  // sunny
      colorProportion = new int[] { 50, 50,  0,  0,  0}; break;
    case 33:  // fair night
      colorProportion = new int[] {  0, 90, 10,  0,  0}; break;
    case 34:  // fair day
      colorProportion = new int[] {  0, 90, 10,  0,  0}; break;

    default:  // anything not yet proportionized
      colorProportion = new int[] {  0, 0, 25,  25,  50}; break;
  }
  return colorProportion;
}
