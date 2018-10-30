int cols, rows;
int scale = 28;
int w = 1300;
int h = 660;
float flying = 0;
float terrainHeight = 55;
float[][] terrain;
color c1, c2;

import processing.io.*; // import the hardware IO library
int pin_z = 24;
int pin_a = 23;
long value = 0;
int lastEncoded = 0;

void setup() {
  //size(800, 480, P3D);
  fullScreen(P3D);
  noCursor();
  noFill();
  cols = w / scale;
  rows = h / scale;
  terrain = new float[cols][rows];
  c1 = color(0, 255);
  c2 = color(0, 0);
  
  GPIO.pinMode(pin_z, GPIO.INPUT_PULLUP);
  GPIO.pinMode(pin_a, GPIO.INPUT_PULLUP); 

  GPIO.attachInterrupt(pin_z, this, "updateEncoder", GPIO.CHANGE);
  GPIO.attachInterrupt(pin_a, this, "updateEncoder", GPIO.CHANGE);
}

void draw() {
  background(0);
  flying -= 0.025;
  float yOffset = flying;
  for (int y=0; y < rows; y++) {
    float xOffset = 0;
    for (int x=0; x < cols; x++) {
      //terrainHeight = map(mouseY, 0, height, 155, 0);
      //terrainHeight = 55;
      terrain[x][y] = map(noise(xOffset, yOffset), 0, 1, -terrainHeight, terrainHeight);
      xOffset += 0.1;
    } 
    yOffset += 0.1;
  }
  
  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  for (int y=0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x=0; x < cols; x++) {
      //stroke(map(terrain[x][y], 0, rows, 120, 180), 100, map(terrain[x][y], 0, rows, 140, 220), map(y, 0, rows+20, 0, 255));
      stroke(map(terrain[x][y], terrainHeight*-1, terrainHeight, 0, 255), map(y, 0, rows, 0, 255));
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
    }
    endShape();
  }
}

void updateEncoder(int pin) { 
  int MSB = GPIO.digitalRead(pin_z);
  int LSB = GPIO.digitalRead(pin_a);
  int encoded = (MSB << 1) | LSB;
  int sum = (lastEncoded << 2) | encoded;

  if (sum == unbinary("1101") || sum == unbinary("0100") || sum == unbinary("0010") || sum == unbinary("1011")) {
    if(terrainHeight < 160) {
      terrainHeight += 5;
    }
  }
  if (sum == unbinary("1110") || sum == unbinary("0111") || sum == unbinary("0001") || sum == unbinary("1000")) { 
    if(terrainHeight > 5) {
      terrainHeight -= 5;
    }
  }

  lastEncoded = encoded;
}
