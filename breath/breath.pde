float phase = 0;
float zoff = 0;
float diameter = 0;
float collapse_space = 20;
boolean save = true;

void setup() {
  size(1920, 1080);
  frameRate(60);
}

void draw() {
  background(#bbda6c);
 
  translate(width / 2, height / 2);
  //stroke(255);
  noStroke();
  //strokeWeight(2);
  //noFill();
  float noiseMax = map(sin(diameter), -1, 1, 0.5, 0.8);
  //float noiseMax = 0.55;
  beginShape();
  fill(#b2d66d);
  for (float a = 0; a < TWO_PI; a += radians(5)) {
    float xoff = map(cos(a + phase), -1, 1, 0, noiseMax);
    float yoff = map(sin(a + phase), -1, 1, 0, noiseMax);
    float expand = map(sin(diameter), -1, 1, 1, 50);
    float r = map(noise(xoff, yoff, zoff), 0, 1, expand+expand*7+collapse_space*0.0, expand*13);
    float x = r * cos(a);
    float y = r * sin(a);
    vertex(x, y);
  }
  endShape(CLOSE);
  
  beginShape();
  fill(#a8d26d);
  for (float a = 0; a < TWO_PI; a += radians(5)) {
    float xoff = map(cos(a + phase), -1, 1, 0, noiseMax);
    float yoff = map(sin(a + phase), -1, 1, 0, noiseMax);
    float expand = map(sin(diameter), -1, 1, 2, 48);
    float r = map(noise(xoff, yoff, zoff), 0, 1, expand+expand*6+collapse_space*0.2, expand*11);
    float x = r * cos(a);
    float y = r * sin(a);
    vertex(x, y);
  }
  endShape(CLOSE);
  
  beginShape();
  fill(#95ca6e);
  for (float a = 0; a < TWO_PI; a += radians(5)) {
    float xoff = map(cos(a + phase), -1, 1, 0, noiseMax);
    float yoff = map(sin(a + phase), -1, 1, 0, noiseMax);
    float expand = map(sin(diameter), -1, 1, 4, 46);
    float r = map(noise(xoff, yoff, zoff), 0, 1, expand+expand*5+collapse_space*0.4, expand*9);
    float x = r * cos(a);
    float y = r * sin(a);
    vertex(x, y);
  }
  endShape(CLOSE);
  
  beginShape();
  fill(#82c26e);
  for (float a = 0; a < TWO_PI; a += radians(5)) {
    float xoff = map(cos(a + phase), -1, 1, 0, noiseMax);
    float yoff = map(sin(a + phase), -1, 1, 0, noiseMax);
    float expand = map(sin(diameter), -1, 1, 5.5, 44);
    float r = map(noise(xoff, yoff, zoff), 0, 1, expand+expand*4+collapse_space*0.6, expand*7);
    float x = r * cos(a);
    float y = r * sin(a);
    vertex(x, y);
  }
  endShape(CLOSE);
  
  beginShape();
  fill(#6fba6f);
  for (float a = 0; a < TWO_PI; a += radians(5)) {
    float xoff = map(cos(a + phase), -1, 1, 0, noiseMax);
    float yoff = map(sin(a + phase), -1, 1, 0, noiseMax);
    float expand = map(sin(diameter), -1, 1, 7.5, 42);
    float r = map(noise(xoff, yoff, zoff), 0, 1, expand+expand*3+collapse_space*0.8, expand*5);
    float x = r * cos(a);
    float y = r * sin(a);
    vertex(x, y);
  }
  endShape(CLOSE);
  
  beginShape();
  fill(#5cb270);
  for (float a = 0; a < TWO_PI; a += radians(5)) {
    float xoff = map(cos(a + phase), -1, 1, 0, noiseMax);
    float yoff = map(sin(a + phase), -1, 1, 0, noiseMax);
    float expand = map(sin(diameter), -1, 1, 9, 40);
    float r = map(noise(xoff, yoff, zoff), 0, 1, expand+expand*2+collapse_space, expand*3);
    float x = r * cos(a);
    float y = r * sin(a);
    vertex(x, y);
  }
  endShape(CLOSE);
  
  phase += 0.05;
  zoff += 0.01;
  diameter += radians(0.8);
  
  if (save) {
    saveFrame("breathvid/frame####.png");
  }
  
}
