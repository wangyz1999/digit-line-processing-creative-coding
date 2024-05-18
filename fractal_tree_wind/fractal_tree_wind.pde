float t = 0; 
float angleAmplitude; 

void setup() {
  size(1080, 1920); 
  frameRate(30);
  background(25); 
}

void draw() {
  background(25); 
  stroke(255); 
  t += 0.01; 

  angleAmplitude = pow(sin(t / 5)/2 + 0.7, 2) / 3;

  for (int i = 12; i > 0; i--) {
    drawBranch(PI / 6 * i, 7, width / 2, height / 2, 90); 
  }
  
  //saveFrame("output/screen-####.png");
  
  if (frameCount == 30 * 20) {
    exit();
  }
}

void drawBranch(float direction, int strokeSize, float x, float y, float length) {
  if (strokeSize > 0) {
    strokeWeight(strokeSize); 
    
    float noiseFactor = 20 - strokeSize, noiseValue = noise(x / width - t, y / height + t) * noiseFactor;
    
    float endX = x + length * cos(direction) + noiseFactor * cos(noiseValue);
    float endY = y + length * sin(direction) + noiseFactor * sin(noiseValue);
    
    line(x, y, endX, endY);
    
    // Recursively draw smaller branches, adjusting direction by the angle amplitude
    for (float angle : new float[]{angleAmplitude, -angleAmplitude}) {
      drawBranch(direction + angle, strokeSize - 1, endX, endY, length * 0.8);
    }
  }
}
