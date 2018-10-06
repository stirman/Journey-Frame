int cols, rows;
int scale = 20;
int w = 2000;
int h = 1400;
float flying = 0;
float terrainHeight;
float[][] terrain;
color c1, c2;

void setup() {
  size(800, 480, P3D);
  stroke(255);
  smooth();
  noFill();
  cols = w / scale;
  rows = h / scale;
  terrain = new float[cols][rows];
  c1 = color(0, 255);
  c2 = color(0, 0);
}

void draw() {
  
  background(0);

  flying -= map(mouseX, 0, width, 0.0, 0.06);
  float yOffset = flying;
  for (int y=0; y < rows; y++) {
    float xOffset = 0;
    for (int x=0; x < cols; x++) {
      terrainHeight = map(mouseY, 0, height, 150, 0);
      terrain[x][y] = map(noise(xOffset, yOffset), 0, 1, -terrainHeight, terrainHeight);
      xOffset += 0.1;
    } 
    yOffset += 0.1;
  }
  
  translate(width/2, height/2);
  rotateX(PI/2.7);
  translate(-w/2, -h/2);
  for (int y=0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x=0; x < cols; x++) {
      stroke(map(terrain[x][y], 0, 150, 150, 255), 100, 255, map(y, 0, rows, 0, 255));
      vertex(x*scale, y*scale, terrain[x][y]);
      vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
    }
    endShape();
  }
}
