float phi = 1.618;

// Fractal-like Patterns
float[] angles = {0, 1, 0, 1, 0}; 
float[] lengths = {100, 80, 100, 80, 100}; 
float[] angleSpeeds = {0.05, -0.025, 0.000625, -0.025, 0.05}; 

ArrayList<PVector> points = new ArrayList<PVector>(); // Store the end points

// Initialize starting positions for the iteration
float[] xs = new float[angles.length + 1]; // Plus one for the starting point at index 0
float[] ys = new float[angles.length + 1]; // Plus one for the starting point


float drawPerFrame = 1; // Start with 1 iteration per frame
float drawPerFrameMin = 1; // Minimum value for iterations per frame
float drawPerFrameMax = 12; // Final value for iterations per frame
float drawPerFrameDelta = 0.05; // Rate at which drawPerFrame increases

int endFrame = 1150;
int drawPerFrameChangeTotal = (int) ((drawPerFrameMax - drawPerFrameMin) / drawPerFrameDelta);

int prepareFrames = 116;

int maxDotSize = 6;

void setup() {
  size(1080, 1920); // Set window size
  background(25); // Set background color
  frameRate(30); // Set frame rate
  println("Angle Ratio = " + (angleSpeeds[0] / angleSpeeds[1])); // Print the ratio of the two angles
}

void draw() {
  background(25); // Clear the background each frame
  translate(width / 2, height / 2); // Move the origin to the center
  strokeWeight(2); // Set line thickness

  if (frameCount <= prepareFrames) {
    // Calculate the total length of all segments
    float totalLength = 0;
    for (int i = 0; i < lengths.length; i++) {
        totalLength += lengths[i];
    }

    float coveredLength = map(frameCount, 1, prepareFrames, 0, totalLength);

    xs[0] = 0;
    ys[0] = 0;

    float lengthSoFar = 0;
    int lastSegmentIndex = 0; 
    boolean lastSegmentFound = false;

    stroke(255); 
    strokeWeight(3); 

    for (int i = 0; i < angles.length; i++) {
        if (!lastSegmentFound) {
            float nextLengthSoFar = lengthSoFar + lengths[i];
            if (nextLengthSoFar >= coveredLength) {
                float excessLength = nextLengthSoFar - coveredLength;
                float segmentLength = lengths[i];
                float dotPositionOnSegment = segmentLength - excessLength;

                float dotX = xs[i] + cos(angles[i]) * dotPositionOnSegment;
                float dotY = ys[i] + sin(angles[i]) * dotPositionOnSegment;
                line(xs[i], ys[i], dotX, dotY);

                lastSegmentFound = true;
                lastSegmentIndex = i;
            } else {
                xs[i + 1] = xs[i] + cos(angles[i]) * lengths[i];
                ys[i + 1] = ys[i] + sin(angles[i]) * lengths[i];
                line(xs[i], ys[i], xs[i + 1], ys[i + 1]);
                ellipse(xs[i + 1], ys[i + 1], maxDotSize, maxDotSize);
            }

            lengthSoFar = nextLengthSoFar;
        }
    }

    float dotX = xs[lastSegmentIndex] + cos(angles[lastSegmentIndex]) * (lengths[lastSegmentIndex] - (lengthSoFar - coveredLength));
    float dotY = ys[lastSegmentIndex] + sin(angles[lastSegmentIndex]) * (lengths[lastSegmentIndex] - (lengthSoFar - coveredLength));
    ellipse(dotX, dotY, maxDotSize, maxDotSize); 

    //saveFrame("output/screen-####.png");
    return; 
}

  if (frameCount <= drawPerFrameChangeTotal + prepareFrames) {
    drawPerFrame += drawPerFrameDelta;
    if (drawPerFrame > drawPerFrameMax) {
      drawPerFrame = drawPerFrameMax;
    }
  }

  if (frameCount >= (endFrame - drawPerFrameChangeTotal + 27)) {
    drawPerFrame -= drawPerFrameDelta;
    if (drawPerFrame < drawPerFrameMin) {
      drawPerFrame = drawPerFrameMin;
    }
  }
  if (frameCount <= endFrame + 4) {
 
    xs[0] = 0; 
    ys[0] = 0; 
    
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

  // Draw all lines stored in the points list with varying alpha
  for (int i = 1; i < points.size(); i++) {
    PVector start = points.get(i - 1);
    PVector end = points.get(i);

    // Calculate distance from the center to adjust alpha
    float distance = dist(0, 0, end.x, end.y);
    int max_dist = 0;
    for (int l = 0; l < lengths.length; l++) {
      max_dist += lengths[l];
    }
    float alpha = map(distance, 0, max_dist, 100, 255); // Adjust these values as needed
    float portion = map(distance, 0, max_dist, 0, 1);
    color c = getColor(portion, false, 2.5);
    stroke(c, alpha); // Set stroke color with alpha
    line(start.x, start.y, end.x, end.y);
  }
  
  int strokeAlpha;
  if (frameCount <= endFrame + 4) {
    strokeAlpha = 255;
  } else {
    strokeAlpha = (int) map(frameCount, endFrame + 4, endFrame + 4 + 8, 255, 0);
  }
    
  // Draw lines
  stroke(255, strokeAlpha); // Set stroke color
  fill(255, strokeAlpha); // Set fill color
  strokeWeight(3); // Set line thickness
  for (int i = 1; i < xs.length; i++) {
    line(xs[i - 1], ys[i - 1], xs[i], ys[i]);
    ellipse(xs[i], ys[i], maxDotSize, maxDotSize);
  }

  if (frameCount >= endFrame + 4 + 8) {
    exit(); 
  }
}

color getColor(float portion, boolean reverse, float saturationAdjust) {
  color[] vValues = {
    color(68, 1, 84),
    color(59, 82, 139),
    color(33, 145, 140),
    color(94, 201, 98),
    color(253, 231, 37),
  };

  if (reverse) {
    for (int i = 0; i < vValues.length / 2; i++) {
      color temp = vValues[i];
      vValues[i] = vValues[vValues.length - 1 - i];
      vValues[vValues.length - 1 - i] = temp;
    }
  }

  float[] vPortions = new float[vValues.length];
  for (int i = 0; i < vPortions.length; i++) {
    vPortions[i] = (float) i / (vPortions.length - 1);
  }

  color output = color(0); // Default black color
  
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
      break; // Found the correct range, no need to continue the loop
    }
  }
  return output;
}
