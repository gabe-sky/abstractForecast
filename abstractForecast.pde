

HDrawablePool squarePool;
HColorPool weatherColors;


void setup() {
  size(640,480);
  smooth();

  // Initialize HYPE
  H.init(this).background(#202020);

  // Put some weather-related colors in a pool.
  weatherColors = new HColorPool()
  .add(#FFE800, 1)  // sunny
  .add(#8FDDF0, 1)  // blue skies
  .add(#CCCCCC, 1)  // cloudy
  .add(#333333, 1)  // rain cloudy
  .add(#9E4AFF, 0)  // lavender.  why?  don't know.
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
        .startX(16)
        .startY(16)
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

  H.drawStage();

  noLoop();

}

void draw() {

}
