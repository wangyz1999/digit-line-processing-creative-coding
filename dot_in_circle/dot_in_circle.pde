boolean saveframe = false;

float circleRadius = 400; // Radius of the circle
float dotRadius = 4; // Radius of the dot, adjust as needed
float speed = 15.0; // Speed of the dot
float duplicationChance = 0.5; 

int maxDuplicate = 1300;

int framerate = 30;
int totalSec = 33;
int breakSec = 28;

boolean isIn = false;
ArrayList<Float> x = new ArrayList<Float>(); // Positions of the dots
ArrayList<Float> y = new ArrayList<Float>();
ArrayList<Float> vx = new ArrayList<Float>(); // Velocities of the dots
ArrayList<Float> vy = new ArrayList<Float>();

void setup() {
  size(1080, 1920);
  frameRate(framerate);
  float initialX = width / 2; // Center horizontally
  float initialY = -9;
  x.add(initialX);
  y.add(initialY);
  vx.add(0.0);
  vy.add(speed); // Initial speed is 8 p
}

void addDot(float px, float py) {
  x.add(px);
  y.add(py);
  float targetX = width / 2; 
  float targetY = height / 2; 
  float angle = atan2(targetY - py, targetX - px);
  angle = angle + random(-PI/8, PI/8); 
  vx.add(cos(angle) * speed); 
  vy.add(sin(angle) * speed); 
}

void draw() {
  background(25);
  // Draw the circle
  //noFill(); 
  //stroke(255); 
  //strokeWeight(2);
  //ellipse(width / 2, height / 2, circleRadius * 2, circleRadius * 2);
  
  for (int i = 0; i < x.size(); i++) {
    // Update dot position
    x.set(i, x.get(i) + vx.get(i));
    y.set(i, y.get(i) + vy.get(i));
    
    float distance = dist(x.get(i), y.get(i), width / 2, height / 2) + dotRadius;

    if (distance < circleRadius) {
      isIn = true;
    }
    if (isIn && distance > circleRadius && frameCount <= breakSec * framerate) {
      // Reflect the dot
      float overlap = distance - circleRadius;
      float backStepRatio = overlap / sqrt(vx.get(i) * vx.get(i) + vy.get(i) * vy.get(i));
      x.set(i, x.get(i) - vx.get(i) * backStepRatio);
      y.set(i, y.get(i) - vy.get(i) * backStepRatio);

      // Calculate reflection vector
      float nx = (x.get(i) - width / 2) / (distance - dotRadius); // Corrected normal x
      float ny = (y.get(i) - height / 2) / (distance - dotRadius); // Corrected normal y
      float dotProduct = vx.get(i) * nx + vy.get(i) * ny;

      // Reflect velocity vector
      vx.set(i, vx.get(i) - 2 * dotProduct * nx);
      vy.set(i, vy.get(i) - 2 * dotProduct * ny);

      // Normalize and scale to original speed
      float norm = sqrt(vx.get(i) * vx.get(i) + vy.get(i) * vy.get(i));
      vx.set(i, (vx.get(i) / norm) * speed);
      vy.set(i, (vy.get(i) / norm) * speed);

      // Optional: Random deflection
      float deflectAngle = random(-PI/8, PI/8); // Random deflection within ±22.5 degrees
      float tempVx = vx.get(i), tempVy = vy.get(i); // Temporary variables for calculation
      vx.set(i, cos(deflectAngle) * tempVx - sin(deflectAngle) * tempVy);
      vy.set(i, sin(deflectAngle) * tempVx + cos(deflectAngle) * tempVy);

      float chance;
      if (x.size() < 10) {
        chance = 0;
      } else {
        chance = random(1);
      }

      if (chance < duplicationChance && x.size() < maxDuplicate){
        addDot(x.get(i), y.get(i)); // Duplicate the dot at its current position
      }
    }
    fill(255); // Set fill color for dot to white
    ellipse(x.get(i), y.get(i), dotRadius * 2, dotRadius * 2);
  }

  if (saveframe) {
    saveFrame("output/screen-####.png");
  }

  if (frameCount == totalSec * framerate) {
    noLoop();
  }
}
