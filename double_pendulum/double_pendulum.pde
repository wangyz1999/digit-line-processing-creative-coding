boolean saveframe = false;

// Pendulum lengths and masses
float r1 = 175;
float r2 = 225;
float m1 = 10;
float m2 = 10;
// Initial angles
float a1 = PI/2;
float a2 = PI/2;
// Angular velocities and accelerations
float a1_velocity = 0;
float a2_velocity = 0;
float g = 1; // Gravity

float x1;
float y1;
float x2;
float y2;
ArrayList<PVector> trail = new ArrayList<PVector>();

int total_time = 89;
int framerate = 30;
int total_frames = total_time * framerate;

float strokeWeightStart = 0.7;
float strokeWeightEnd = 2.5;

void setup() {
  size(1080, 1920);
  frameRate(framerate);
  // Use DOUBLE for smoother animation
  pixelDensity(displayDensity());
}

void draw() {
  background(25);
  translate(width/2, height/5*2);

  int iters = 1;
  if (frameCount > 30 * 10) {
    iters = 2;
  }
  if (frameCount > 30 * 25) {
    iters = 4;
  }
  if (frameCount > 30 * 38) {
    iters = 8;
  }
  if (frameCount > 30 * 49) {
    iters = 16;
  }
  if (frameCount > 30 * 59) {
    iters = 24;
  }
  if (frameCount > 30 * 68) {
    iters = 32;
  }
  if (frameCount > 30 * 76) {
    iters = 40;
  }

  for (int i = 0; i < iters; i++) {
    float num1 = -g * (2 * m1 + m2) * sin(a1);
    float num2 = -m2 * g * sin(a1 - 2 * a2);
    float num3 = -2*sin(a1 - a2) * m2;
    float num4 = a2_velocity * a2_velocity * r2 + a1_velocity * a1_velocity * r1 * cos(a1 - a2);
    float den = r1 * (2 * m1 + m2 - m2 * cos(2 * a1 - 2 * a2));
    float a1_acceleration = (num1 + num2 + num3 * num4) / den;

    float num5 = 2 * sin(a1 - a2);
    float num6 = (a1_velocity * a1_velocity * r1 * (m1 + m2));
    float num7 = g * (m1 + m2) * cos(a1);
    float num8 = a2_velocity * a2_velocity * r2 * m2 * cos(a1 - a2);
    float den2 = r2 * (2 * m1 + m2 - m2 * cos(2 * a1 - 2 * a2));
    float a2_acceleration = (num5 * (num6 + num7 + num8)) / den2;

    float timeScale = 0.3;

    a1_velocity += a1_acceleration * timeScale;
    a2_velocity += a2_acceleration * timeScale;
    a1 += a1_velocity;
    a2 += a2_velocity;

    // Drawing the first arm
    x1 = r1 * sin(a1);
    y1 = r1 * cos(a1);
    // Drawing the second arm
    x2 = x1 + r2 * sin(a2);
    y2 = y1 + r2 * cos(a2);
    
    // Add new position to the trail
    trail.add(new PVector(x2, y2));
  }  

  // Draw the trail
  for (int i = 1; i < trail.size(); i++) {
    float portion = map(i, 0, trail.size(), 0, 1);
    PVector start = trail.get(i-1);
    PVector end = trail.get(i);
    stroke(getColor(portion));
    strokeWeight(map(i, 0, trail.size(), strokeWeightStart, strokeWeightEnd));
    line(start.x, start.y, end.x, end.y);
  }

  // Limit the trail length to keep performance
  if (trail.size() > 500) {
    trail.remove(0);
  }

  stroke(255);
  strokeWeight(2);
  // Arm 1
  //line(0, 0, x1, y1);
  fill(255);
  ellipse(x1, y1, m1, m1);
  // Arm 2
  line(x1, y1, x2, y2);
  fill(240, 249, 33);
  ellipse(x2, y2, m2, m2);

  if (saveframe) {
    saveFrame("output/screen-####.png");
  }

  if (frameCount >= total_frames) {
    noLoop();
  }
}

color getColor(float portion)  {
  color[] vValues = {
      color(13, 8, 135),     // #0d0887
      color(106, 0, 168),   // #6a00a8
      color(177, 42, 144),  // #b12a90
      color(225, 100, 98),  // #e16462
      color(252, 166, 54),  // #fca636
      color(240, 249, 33),  // #f0f921
  };

  float[] vPortions = {
    0,
    0.2,
    0.4,
    0.6,
    0.8,
    1
  };
  for (int i = 0; i < vPortions.length - 1; i++) {
    if (portion >= vPortions[i] && portion <= vPortions[i + 1]) {
      float portionInThisRange = (portion - vPortions[i]) / (vPortions[i + 1] - vPortions[i]);
      return lerpColor(vValues[i], vValues[i + 1], portionInThisRange);
    }
  }
  return color(0);
}