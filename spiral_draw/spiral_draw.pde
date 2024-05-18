// Declare global variables for angles, lengths, speed, and point storage
float[] angles = {0, 1}; // Angles for the lines
float[] lengths = {200, 200}; // Lengths of the lines
float[] angleSpeeds = {-0.05, 0.0095}; // Speed of rotation for the lines

float phi = 1.618;
ArrayList<PVector> points = new ArrayList<PVector>(); 

float[] xs = new float[angles.length + 1]; 
float[] ys = new float[angles.length + 1]; 


float drawPerFrame = 1; 
float drawPerFrameMin = 1; 
float drawPerFrameMax = 14; 
float drawPerFrameDelta = 0.05; 

int endFrame = 1950;
int drawPerFrameChangeTotal = (int) ((drawPerFrameMax - drawPerFrameMin) / drawPerFrameDelta);

int prepareFrames = 116;

void setup() {
  size(1080, 1920); 
  background(25); 
  frameRate(30); 
}

void draw() {
  background(25); 
  translate(width / 2, height / 2); 
  strokeWeight(2);

  if (frameCount <= drawPerFrameChangeTotal) {
    drawPerFrame += drawPerFrameDelta;
    if (drawPerFrame > drawPerFrameMax) {
      drawPerFrame = drawPerFrameMax;
    }
  }

  if (frameCount >= (endFrame - drawPerFrameChangeTotal + 9)) {
    drawPerFrame -= drawPerFrameDelta;
    if (drawPerFrame < drawPerFrameMin) {
      drawPerFrame = drawPerFrameMin;
    }
  }

  // saveFrame("output/screen-####.png"); 
  if (frameCount <= endFrame + 7) {
 
    xs[0] = 0; // Starting x position
    ys[0] = 0; // Starting y position
    
    for (int f = 0; f < (int) drawPerFrame; f++) {
      for (int i = 0; i < angles.length; i++) {
        xs[i + 1] = xs[i] + cos(angles[i]) * lengths[i];
        ys[i + 1] = ys[i] + sin(angles[i]) * lengths[i];
  
        angles[i] += angleSpeeds[i];
  
        if (i == angles.length - 1) {
          points.add(new PVector(xs[i + 1], ys[i + 1]));
        }
      }
    }
  }

  for (int i = 1; i < points.size(); i++) {
    PVector start = points.get(i - 1);
    PVector end = points.get(i);

    float distance = dist(0, 0, end.x, end.y);
    int max_dist = 0;
    for (int l = 0; l < lengths.length; l++) {
      max_dist += lengths[l];
    }
    float alpha = map(distance, 0, max_dist, 100, 255); // Adjust these values as needed
    float portion = map(distance, 0, max_dist, 0, 1);
    color c = getColor(portion, false, 1.7);
    stroke(c, alpha); 
    line(start.x, start.y, end.x, end.y);
  }
  
  int strokeAlpha;
  if (frameCount <= endFrame + 7) {
    strokeAlpha = 255;
  } else {
    strokeAlpha = (int) map(frameCount, endFrame + 7, endFrame + 15, 255, 0);
  }
    
  // Draw lines
  stroke(255, strokeAlpha); 
  fill(255, strokeAlpha); 
  strokeWeight(3); 
  for (int i = 1; i < xs.length; i++) {
    line(xs[i - 1], ys[i - 1], xs[i], ys[i]);
    ellipse(xs[i], ys[i], 6, 6);
  }

  //saveFrame("output/screen-####.png");
  if (frameCount >= endFrame + 15) {
    exit(); // Stop the program after the animation is complete
  }
}

color getColor(float portion, boolean reverse, float saturationAdjust) {
  color[] vValues = {
    color(13, 8, 135),    // #0d0887
    color(106, 0, 168),   // #6a00a8
    color(177, 42, 144),  // #b12a90
    color(225, 100, 98),  // #e16462
    color(252, 166, 54),  // #fca636
  };

  if (reverse) {
    for (int i = 0; i < vValues.length / 2; i++) {
      color temp = vValues[i];
      vValues[i] = vValues[vValues.length - 1 - i];
      vValues[vValues.length - 1 - i] = temp;
    }
  }

  float[] vPortions = {
    0.0,
    0.25,
    0.5,
    0.75,
    1.0
  };
  
  color output = color(0); 
  
  for (int i = 0; i < vPortions.length - 1; i++) {
    if (portion >= vPortions[i] && portion <= vPortions[i + 1]) {
      float portionInThisRange = (portion - vPortions[i]) / (vPortions[i + 1] - vPortions[i]);
      color interpolatedColor = lerpColor(vValues[i], vValues[i + 1], portionInThisRange);
      if (saturationAdjust != 1.0) {
        // Adjust the color's vibrance/saturation
        float r = red(interpolatedColor);
        float g = green(interpolatedColor);
        float b = blue(interpolatedColor);
        // Move RGB values towards or away from the average to adjust saturation
        float average = (r + g + b) / 3;
        r = lerp(average, r, saturationAdjust);
        g = lerp(average, g, saturationAdjust);
        b = lerp(average, b, saturationAdjust);
        output = color(r, g, b);
      } else {
        output = interpolatedColor;
      }
      break; 
    }
  }
  return output;
}
