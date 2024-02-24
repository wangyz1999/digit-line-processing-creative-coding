// Customizable variables
int numIterations = 1000000; // Number of points to draw
//float scaleFactor = 120 - 5 * 20; // Scale factor for drawing the fern
float scaleFactor = 120 - 5 * 20 + 5 * 1736;
color fernColor = color(34, 139, 34, 150); // Color of the fern
//float yOffset = 200 + 30 * 20; // Y offset for drawing the fern
float yOffset = 200 + 30 * 20 - 30 * 1736;
float xOffset = 0;

// Transformation probabilities
float probFernTip = 0.01;
float probLargestLeaflet = 0.85;
float probSmallestLeaflet = 0.07; // Note: This is adjusted from 0.93 to account for cumulative probability
float probStem = 0.07; // The rest of the probability space

PVector p;

PVector[] points = new PVector[numIterations];

void setup() {
  size(1080, 1920);
  background(25);
  p = new PVector(0, 0);
}

void draw() {
  background(25);
  for (int i = 0; i < numIterations; i++) {
    p = transformPoint(p);

    float screenX = width / 2 + (p.x * scaleFactor + xOffset);
    float screenY = height - (p.y * scaleFactor + yOffset);
    if (screenX >= 0 && screenX <= width && screenY >= 0 && screenY <= height) {
      stroke(34, 139, 34); // Fern color
      point(screenX, screenY);
    } else {
      i--;
    }

  }

  // Save the frame
  //saveFrame("output_3/screen-####.png");

  if (scaleFactor < 4000) {
    scaleFactor += 5;
    yOffset -= 30;
  }
  else if (frameCount > 860) {
    yOffset -= 3;
    xOffset -= 1;
  }
}

void precomputePoints(int numIterations) {
  for (int i = 0; i < numIterations; i++) {
    p = transformPoint(p);
    points[i] = new PVector(p.x, p.y);
  }
}


PVector transformPoint(PVector p) {
  float x = p.x;
  float y = p.y;

  float nextX, nextY;
  float r = random(1);

  // Apply transformations based on random choice
  if (r < probFernTip) {
    nextX = 0;
    nextY = 0.16 * y;
  } else if (r < probFernTip + probLargestLeaflet) {
    nextX = 0.85 * x + 0.04 * y;
    nextY = -0.04 * x + 0.85 * y + 1.6;
  } else if (r < probFernTip + probLargestLeaflet + probSmallestLeaflet) {
    nextX = 0.2 * x - 0.26 * y;
    nextY = 0.23 * x + 0.22 * y + 1.6;
  } else {
    nextX = -0.15 * x + 0.28 * y;
    nextY = 0.26 * x + 0.24 * y + 0.44;
  }
  return new PVector(nextX, nextY);
}
