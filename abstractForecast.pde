

HDrawablePool squarePool;
HColorPool weatherColors;


void setup() {
  size(640,480);
  smooth();
  noLoop();

  // Initialize HYPE
  H.init(this).background(#202020);

  // Draw a weather block.
  // Arguments are startX, startY,
  // sunny, bluey, cloudy, rainy, meteors
  drawWeatherBlock( (16+(128*0)), 16, 10, 80, 10,  0,  0 );
  drawWeatherBlock( (16+(128*1)), 16, 10, 60, 30,  0,  0 );
  drawWeatherBlock( (16+(128*2)), 16, 10, 20, 70,  0,  0 );
  drawWeatherBlock( (16+(128*3)), 16,  0,  0, 70, 30,  0 );
  drawWeatherBlock( (16+(128*4)), 16,  0,  0, 80, 15,  5 );

  H.drawStage();
}

void draw() {

}


/*  drawWeatherBlock draws a four-by-four "block" of weather
    colored squares.
    Pass in the startX and startY of the first square in the block
    keeping in mind, we're anchoring at H.CENTER.

    The other variables set the proportion of weather colors to 
    put in the pool that we'll pick fill colors from. */

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

  // Throw sixteen HRects in a pool.  Pool might be useful later.
  squarePool = new HDrawablePool(16)
    .autoAddToStage()
    .add ( 
      new HRect(), 16
    )

    // Apply a grid layout.  Fits thirty-by-thirty squares nicely.
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
