boolean saveframe = false;

color rootColorEnd = color(7, 103, 98);
color rootColorMid = color(82, 60, 30);
color leafColorEnd = color(195, 252, 66); 
color leafColorMid = color(255, 168, 61);
float startAngle = 8;
float endAngle = 360 - startAngle;
float length = 230;
float reduction = 0.71;
int framerate = 30;
int totalSec = 15;
int totalFrames = framerate * totalSec;
float maxAngleChange = 0.4;
float angle;
int depthTotal = 14;

color rootColor;
color leafColor;

void setup() {
  size(1080, 1920);
  frameRate(framerate);
  background(25);
  strokeWeight(1.6);
  
  // Initialize changing colors
  rootColor = rootColorEnd;
  leafColor = leafColorEnd;
  
  translate(width / 2, height / 10 * 6);
  drawBranch(length, depthTotal);
}

void draw() {
  float progressPercent = map(frameCount, 0, totalFrames, 0, 1);
  float progressPercentLoop = sin(progressPercent * PI);
  
  // Calculate dynamic angle
  angle = calculateAngle(frameCount % totalFrames); // Loop the animation
  if (angle > 180) angle = 360 - angle;

  // Update colors based on animation progress
  leafColor = lerpColor(leafColorEnd, leafColorMid, progressPercentLoop);
  rootColor = lerpColor(rootColorEnd, rootColorMid, progressPercentLoop);

  // Redraw background and tree
  background(25);
  stroke(rootColor);
  line(width / 2, height, width / 2, height / 2);
  translate(width / 2, height / 10 * 6);
  drawBranch(length, depthTotal);

  if (saveframe) {
    saveFrame("output/screen-####.png");
  }
  if (frameCount == totalFrames) noLoop();
}

void drawBranch(float len, int depth) {
  if (depth == 0) return;
  
  float inter = map(depth, depthTotal, 0, 0.0, 1.0); // Adjusted to use depthTotal
  color branchColor = lerpColor(rootColor, leafColor, inter);
  stroke(branchColor);
  
  line(0, 0, 0, -len);
  translate(0, -len);
  
  // Branching
  pushMatrix();
  rotate(radians(angle));
  drawBranch(len * reduction, depth - 1);
  popMatrix();
  
  pushMatrix();
  rotate(-radians(angle));
  drawBranch(len * reduction, depth - 1);
  popMatrix();
}

float calculateAngle(int frame) {
  float progress = map(frame, 0, totalFrames, 0, PI); // Full sine wave cycle
  float smoothFactor = (sin(progress - PI / 2) + 1) / 2; // Smooth start and end
  return lerp(startAngle, endAngle, smoothFactor); // Interpolate angle
}
