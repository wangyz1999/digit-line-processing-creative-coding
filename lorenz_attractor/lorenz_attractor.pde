// Configurable parameters
float initialX = 0.01; // Initial X position
float initialY = 0;    // Initial Y position
float initialZ = 0;    // Initial Z position

float a = 10;          // Lorenz system parameter
float b = 28;          // Lorenz system parameter
float c = 8.0 / 3.0;   // Lorenz system parameter

float dt = 0.007;      // Time step for the simulation

float scale = 31;      // Scale factor for drawing

float rotationSpeed = 0.005; // Speed of rotation

float strokeWeightStart = 0.7; // Starting stroke weight
float strokeWeightEnd = 2.5;   // Ending stroke weight

int total_time = 89;      // Total duration in seconds
int framerate = 30;       // Frame rate
int total_frames = total_time * framerate; // Total number of frames

// System variables (Do not modify)
ArrayList<PVector> points = new ArrayList<PVector>();

float x = initialX;
float y = initialY;
float z = initialZ;

float rotationX = 0.0;
float rotationY = 0.0;
float rotationZ = 0.0;

// Function to get color based on viridis colormap
color getViridisColor(float portion) {
  color[] vValues = {
    color(68, 1, 84),
    color(59, 82, 139),
    color(33, 145, 140),
    color(94, 201, 98),
    color(253, 231, 37),
  };
  float[] vPortions = {0, 0.25, 0.5, 0.75, 1};
  for (int i = 0; i < vPortions.length - 1; i++) {
    if (portion >= vPortions[i] && portion <= vPortions[i + 1]) {
      float portionInThisRange = (portion - vPortions[i]) / (vPortions[i + 1] - vPortions[i]);
      return lerpColor(vValues[i], vValues[i + 1], portionInThisRange);
    }
  }
  return color(0);
}

// Setup function for initial configuration
void setup() {
  size(1080, 1920, P3D);
  frameRate(framerate);
  colorMode(RGB);
  background(25);
}

// Main drawing loop
void draw() {
  background(25);

  // Adjust iteration count based on the frame count
  int iters = max(1, (frameCount / (30 * 10)) * 2);

  // Update system states and add new points
  for (int i = 0; i < iters; i++) {
    float dx = (a * (y - x)) * dt;
    float dy = (x * (b - z) - y) * dt;
    float dz = (x * y - c * z) * dt;
    x += dx;
    y += dy;
    z += dz;
    points.add(new PVector(x, y, z));
  }

  translate(width / 2, height / 2, -80);
  rotationX += rotationSpeed;
  rotationY += rotationSpeed;
  rotationZ += rotationSpeed;
  rotateX(rotationX);
  rotateY(rotationY);
  rotateZ(rotationZ);

  // Drawing the points with color and stroke weight variations
  noFill();
  beginShape();
  for (int i = 0; i < points.size(); i++) {
    float hu = map(i, 0, points.size(), 0, 1);
    strokeWeight(map(i, 0, points.size(), strokeWeightStart, strokeWeightEnd));
    stroke(getViridisColor(hu));
    PVector v = points.get(i);
    vertex((v.x - x) * scale, (v.y - y) * scale, (v.z - z) * scale);
  }
  endShape();

  // Save frames and stop the loop at the end
  saveFrame("output/screen-####.png");
  if (frameCount == total_frames) {
    noLoop();
  }
}
