import processing.video.Capture;
import processing.video.*;

//Experimenting with macbook webcam data and HSB values
//click mouse to pause background


Capture video;


// Number of columns and rows in camera system
int cols, rows;
int cellSize = 15;

//color variables
float colorChange;
float color1=0;
float color2=300;

//size variables
float growth=5;
boolean[] flip = new boolean[4];
float mY= 30;


void setup() {
  size(displayWidth, displayHeight);

  video = new Capture(this, width, height);
  video.start();

  cols = width / cellSize;
  rows = height / cellSize;

  flip[3]=true;

  noCursor();
}


void draw() {

  //check to prevent unintentional glitches from lost video frames
  if (video.available()) {

    //update background color and position values

    backgroundUpdate();

    if (flip[3]==true) {
      //show glitch background
      glitchBackground();
    }

    //update and display camera data
    captureCamera(floor((color1+width/2)%width));


    //Update and display cursor
    cursorUpdate();
  }

  textSize(24);
  text("Click to Pause Background", 40, 60);
}

void glitchBackground() {
  
  colorMode(HSB, width);
  int colorCols = floor(width*1.2);
  int colorRows=40;

  for (int i = 0; i < colorRows; i+=2) {
    for (int j = 100; j < colorCols; j+=2) {

      float stroke=color1+i*4;
      float fill=color1+i*4;

      //Following if statements turn on vertical and horizontal stripes
      if (j>200&&j<300) {
        fill+=200;
        stroke+=200;
      }


      if (j>800&&j<900) {
        fill+=600;
        stroke+=600;
      }   

      if (i>10&&i<14) {
        fill+=600;
        stroke+=600;
      } 

      if (j>0&&j<width) {
        stroke(stroke, j*4, width*8/9);
        fill(fill, j*4, width*8/9);
      } 

      if (floor(random(0, 50))==2) {
        rect((j-100), i*mY-200, 300/growth, 300/growth);
      }
    }
  }
}


void captureCamera(int coloring) {
  ///Video Capture and display

  if (video.available()) {
    video.read();
    video.loadPixels();

    // background(0, 0, 255);
    rectMode(CENTER);
    // Begin loop for columns
    for (int i = 0; i < cols; i++) {
      // Begin loop for rows
      for (int j = 0; j < rows; j++) {

        // Where are we, pixel-wise?
        float x = (i * cellSize);
        float y = (j * cellSize);
        int loc = floor((video.width - x - 1) + y*video.width); // Reversing x to mirror the image
        colorMode(RGB, 255, 255, 255, 100);

        // Each rect is colored white with a size determined by brightness
        color c = video.pixels[loc];
        float visibility = (brightness(c) / 255.0) * cellSize;


        int tint = floor(random(width*9/10, width));

        // Apply fill from coloring value
        colorMode(HSB, width);
        fill(coloring, width, width, tint);
        noStroke();

        // map sensitivity to mouse Y axis
        int threshold=floor(map(mouseY, 0, height, 8, 0));

        for (int v = 0; v<3; v++) {

          // determines visible rectangles
          if (visibility < threshold+v) {
            fill(coloring, width, width*3/4, tint/(v+1));
            rect(x + cellSize/2, y + cellSize/2, 30, 30);
          }
        }
      }
    }
  }
  rectMode(CORNER);
}

void backgroundUpdate() {

  //update values that shift color background up, down, and hue


    if (millis()%4==0) {
    if (flip[0]==true) {
      mY++;
    }
    if (mY>60) {
      flip[0]=false;
    }

    if (flip[0]==false) {
      mY--;
    }
    if (mY<20) {
      flip[0]=true;
    }
  }
  if (color1>width-1) {
    flip[1]=true;
  }
  if (color1<0) {
    flip[1]=false;
  }
  if (flip[1]==false) {
    color1+=10;
  } else if (flip[1]==true) {
    color1-=10;
  }
  color2+=5;

  if (floor(random(0, 5))==2) {
  }


  growth=map(constrain(mouseX, width/2, width), width/2, width, 5, 15);

  println(growth);
}

void cursorUpdate() {

  //draws a black blob on screen 

  colorMode(HSB, width);
  for (int i = 400; i < 450; i+=2) {
    for (int j =  450; j < 500; j+=2) {
      if (j>0&&j<500) {
        stroke(((color1)+i*4), j*2, 0);
        fill(color1+i*4, j*2, 0);
      } 

      float xCoord=(j-100)+mouseX-400;
      float yCoord=i+mouseY-450;

      if (floor(random(0, 50))==2) {
        rect(xCoord, yCoord, 50, 50);
      }
    }
  }
}

void mousePressed() {
  flip[3]= !flip[3];
}
