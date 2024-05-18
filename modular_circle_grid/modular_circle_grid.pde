int totalDots = 120;
float circleRadius;
float multiplier = 0;
int circleNumX = 3;
int circleNumY = 5;
int gap = 85;
int gapy = 140;
float animationSpeed = 0.03; // Control the speed of the animation
float delay = 0.15; // Delay between each circle's start time
int moduleDelayFrame = 10;

int[] timesList = {2, 3, 4, 5, 6, 8, 10, 12, 15, 20, 24, 30, 40, 60, 120};

void setup() {
  size(1080, 1920);
  background(25); // Synthwave background color
  circleRadius = 130;
  frameRate(30);
}

void plotCircles() {
  noFill();
  strokeWeight(2);
  stroke(255);
  for (int i = 0; i < circleNumX; i++) {
    for (int j = 0; j < circleNumY; j++) {
      float x = map(i, 0, circleNumX - 1, 0 + circleRadius + gap, width - circleRadius - gap);
      float y = map(j, 0, circleNumY - 1, 0 + circleRadius + gapy, height - circleRadius - gapy);
      // Calculate the delay based on the position of the circle
      float currentDelay = delay * (i + j * circleNumX);
      float currentMultiplier = max(0, multiplier - currentDelay);
      if (currentMultiplier > 1) currentMultiplier = 1; // Ensure it does not exceed 1
      float currentRadius = circleRadius * currentMultiplier;
      ellipse(x, y, currentRadius * 2, currentRadius * 2);
    }
  }
}
void draw() {
  if (frameCount < 120) {
    background(25);
    plotCircles();
    multiplier += animationSpeed;
  } 
  else if (frameCount > 138) { // Start drawing lines after the initial animation
    plotCircles();
    stroke(255, 255, 255, 100);
    int d = (int) (frameCount - 138) / 5;
    for (int i = 0; i < circleNumX; i++) {
      for (int j = 0; j < circleNumY; j++) {
        int index = i + j * circleNumX;
        // Calculate delay for each circle based on its position
        int circleDelay = (int) 138 + index * moduleDelayFrame;
        if (frameCount > circleDelay) { // Check if the current frame is beyond the delay for this circle
          int adjust_d = d - (circleDelay - 138) / 5; // Adjust d based on the circle's delay
          float x = map(i, 0, circleNumX - 1, circleRadius + gap, width - circleRadius - gap);
          float y = map(j, 0, circleNumY - 1, circleRadius + gapy, height - circleRadius - gapy);
          float startAngle = map(adjust_d, 0, totalDots, 0, TWO_PI);
          float startX = circleRadius * cos(startAngle) + x;
          float startY = circleRadius * sin(startAngle) + y;

          float times = timesList[index]; // Use the correct index to get the times value

          float endAngle = map((adjust_d * (int)times) % totalDots, 0, totalDots, 0, TWO_PI);
          float endX = circleRadius * cos(endAngle) + x;
          float endY = circleRadius * sin(endAngle) + y;

          line(startX, startY, endX, endY);
        }
      }
    }
    //if (d > totalDots) {
    //  noLoop(); // Stop the loop once all lines are drawn
    //  exit(); // Exit the sketch
    //}
  }
  saveFrame("output_2/screen-####.png");
}
