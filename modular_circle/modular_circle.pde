int totalDots = 150; 
int maxMultiplier = 150;
float circleRadius; 
float multiplier = 0; 
int frameCount = 0; // New variable to count frames
int totalFrames = 822; // Total frames to reach the end (adjust as needed for timing)

void setup() {
  size(1080, 1920);
  circleRadius = min(width, height) / 2 * 0.8;
  frameRate(30);
}

void draw() {
  background(25); // Synthwave background color
  translate(width / 2, height / 2); // Move the origin to the center

  // Draw the lines
  stroke(255, 255, 255, 100);
  for (int i = 0; i < totalDots; i++) {
    float startAngle = map(i, 0, totalDots, 0, TWO_PI);
    float startX = circleRadius * cos(startAngle);
    float startY = circleRadius * sin(startAngle);

    float endAngle = map((i * multiplier) % totalDots, 0, totalDots, 0, TWO_PI);
    float endX = circleRadius * cos(endAngle);
    float endY = circleRadius * sin(endAngle);

    line(startX, startY, endX, endY);
  }

  // Increment frame count and calculate progress
  float progress = (float)frameCount / totalFrames;
  float easedProgress = easeInOut(progress);
  multiplier = easedProgress * maxMultiplier;
  
  saveFrame("output/screen-####.png");

  frameCount++;
  if (multiplier >= maxMultiplier) {
    noLoop();
  }

  // Draw the circle
  noFill();
  stroke(255, 255, 255, 255);
  ellipse(0, 0, circleRadius * 2, circleRadius * 2);
}

// Quadratic ease-in-out
float easeInOut(float t) {
  return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
}
