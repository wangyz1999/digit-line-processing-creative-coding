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
  noStroke();

  float noiseMax = map(sin(diameter), -1, 1, 0.5, 0.8);
  int[] colors = {#b2d66d, #a8d26d, #95ca6e, #82c26e, #6fba6f, #5cb270};

  for (int i = 0; i < 6; i++) {
    fill(colors[i]);

    // Begin the shape
    beginShape();

    for (float a = 0; a < TWO_PI; a += radians(5)) {
      // Map the phase to the noise parameters
      float xoff = map(cos(a + phase), -1, 1, 0, noiseMax);
      float yoff = map(sin(a + phase), -1, 1, 0, noiseMax);

      // Map the diameter to the expansion size
      float expand = map(sin(diameter), -1, 1, 1 + i*1.5, 50 - i*2);

      // Map the noise to the radius
      float r = map(noise(xoff, yoff, zoff), 0, 1, expand + expand * (7-i) + collapse_space * i * 0.2, expand * (13 - i * 2));

      // Calculate the x and y coordinates
      float x = r * cos(a);
      float y = r * sin(a);

      vertex(x, y);
    }
    endShape(CLOSE);
  }
  
  // Increment the phase, z-offset and diameter
  phase += 0.05;
  zoff += 0.01;
  diameter += radians(0.8);
  
  if (save) {
    saveFrame("breathvid/frame####.png");
  }
}
