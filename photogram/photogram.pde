int numPoints = 100;
PVector[] points = new PVector[numPoints];
PVector[] noiseOffsets = new PVector[numPoints];
float[][] distances;
int k = 4;
float maxDistance;

// Parameters for controlling thickness and opacity
float thicknessMin = 0.5;
float thicknessMax = 4.0;
float opacityMin = 50;
float opacityMax = 255;

// Parameters for controlling Perlin noise movement
float noiseScale = 0.01;
float noiseSpeed = 0.01;

// Parameters for the soft boundary
int boundaryWidth = 800;
int boundaryHeight = 1600;
int boundaryX, boundaryY;
float boundaryForce = 0.1; // Force strength pushing points back inside

int[] keySecs = {5, 5+10, 5+10+5, 5+10+5+10, 5+10+5+10+5};
int[] keyframes = new int[keySecs.length];

void setup() {
  size(1080, 1920, P3D);
  stroke(255);
  noFill();
  frameRate(30);

  boundaryX = (width - boundaryWidth) / 2;
  boundaryY = (height - boundaryHeight) / 2;

  // Generate random points inside the soft boundary
  for (int i = 0; i < numPoints; i++) {
    points[i] = new PVector(
      random(boundaryX, boundaryX + boundaryWidth),
      random(boundaryY, boundaryY + boundaryHeight),
      random(-500, 500)
    );
    noiseOffsets[i] = new PVector(random(1000), random(1000), random(1000));
  }
  
  // Calculate distances between points
  distances = new float[numPoints][numPoints];
  for (int i = 0; i < numPoints; i++) {
    for (int j = i + 1; j < numPoints; j++) {
      float d = PVector.dist(points[i], points[j]);
      distances[i][j] = d;
      distances[j][i] = d;
      if (d > maxDistance) {
        maxDistance = d;
      }
    }
  }

  for (int i = 0; i < keySecs.length; i++) {
    keyframes[i] = keySecs[i] * 30;
  }

}

void draw() {
  float dividerY;

  // Calculate the divider position based on frameCount
  if (frameCount <= keyframes[0]) {
    background(255);
    stroke(0);
    dividerY = -1;  // off-screen
  } else if (frameCount <= keyframes[1]) {
    background(25);
    stroke(255);
    dividerY = map(frameCount, keyframes[0], keyframes[1], 0, height / 2);
  } else if (frameCount <= keyframes[2]) {
    background(25);
    stroke(255);
    dividerY = height / 2;
  } else if (frameCount <= keyframes[3]) {
    background(25);
    stroke(255);
    dividerY = map(frameCount, keyframes[2], keyframes[3], height / 2, height);
  } else {
    background(25);
    stroke(255);
    dividerY = height + 1;  // off-screen
  }

  if (frameCount > keyframes[0] && frameCount <= keyframes[3]) {
    noStroke();
    fill(25);
    rect(0, 0, width, dividerY); // Upper half background
    fill(255);
    rect(0, dividerY, width, height - dividerY); // Lower half background
    stroke(127);
    line(0, dividerY, width, dividerY);
  }

  // Move points using Perlin noise
  for (int i = 0; i < numPoints; i++) {
    points[i].x += map(noise(noiseOffsets[i].x + frameCount * noiseSpeed), 0, 1, -1, 1);
    points[i].y += map(noise(noiseOffsets[i].y + frameCount * noiseSpeed), 0, 1, -1, 1);
    points[i].z += map(noise(noiseOffsets[i].z + frameCount * noiseSpeed), 0, 1, -1, 1);

    // Apply boundary force
    if (points[i].x < boundaryX) {
      points[i].x += boundaryForce;
    } else if (points[i].x > boundaryX + boundaryWidth) {
      points[i].x -= boundaryForce;
    }
    if (points[i].y < boundaryY) {
      points[i].y += boundaryForce;
    } else if (points[i].y > boundaryY + boundaryHeight) {
      points[i].y -= boundaryForce;
    }
  }

  // Draw the points and their connections
  for (int i = 0; i < numPoints; i++) {
    // Find the k-nearest neighbors
    int[] neighbors = getKNearestNeighbors(i);

    // Draw lines to the k-nearest neighbors
    for (int j = 0; j < k; j++) {
      int neighborIndex = neighbors[j];
      float distance = distances[i][neighborIndex];
      
      // Calculate stroke weight and color based on z-value (depth)
      float weight = map(points[i].z, -500, 500, thicknessMin, thicknessMax);
      float alpha = map(points[i].z, -500, 500, opacityMin, opacityMax);

      // Determine if the edge intersects the dividing line
      if ((points[i].y < dividerY && points[neighborIndex].y >= dividerY) || 
          (points[i].y >= dividerY && points[neighborIndex].y < dividerY)) {
        // Calculate intersection point
        float t = (dividerY - points[i].y) / (points[neighborIndex].y - points[i].y);
        float ix = points[i].x + t * (points[neighborIndex].x - points[i].x);

        // Draw the line in two segments
        if (points[i].y < dividerY) {
          // Upper half segment
          stroke(255, alpha);
          strokeWeight(weight);
          line(points[i].x, points[i].y, ix, dividerY);
          // Lower half segment
          stroke(0, alpha);
          strokeWeight(weight);
          line(ix, dividerY, points[neighborIndex].x, points[neighborIndex].y);
        } else {
          // Lower half segment
          stroke(0, alpha);
          strokeWeight(weight);
          line(points[i].x, points[i].y, ix, dividerY);
          // Upper half segment
          stroke(255, alpha);
          strokeWeight(weight);
          line(ix, dividerY, points[neighborIndex].x, points[neighborIndex].y);
        }
      } else {
        // Single segment line
        if (points[i].y < dividerY) {
          stroke(255, alpha);
        } else {
          stroke(0, alpha);
        }
        strokeWeight(weight);
        line(points[i].x, points[i].y, points[neighborIndex].x, points[neighborIndex].y);
      }
    }
  }

  // Save the frame as a PNG file
  saveFrame("output_2/screen-####.png");
  if (frameCount == keyframes[4]) {
    exit();
  }
  
}

// Function to get k-nearest neighbors of a point
int[] getKNearestNeighbors(int index) {
  float[] distancesFromPoint = new float[numPoints];
  for (int i = 0; i < numPoints; i++) {
    distancesFromPoint[i] = distances[index][i];
  }
  
  int[] indices = new int[numPoints];
  for (int i = 0; i < numPoints; i++) {
    indices[i] = i;
  }
  
  // Sort indices based on distances
  for (int i = 0; i < numPoints; i++) {
    for (int j = i + 1; j < numPoints; j++) {
      if (distancesFromPoint[indices[i]] > distancesFromPoint[indices[j]]) {
        int temp = indices[i];
        indices[i] = indices[j];
        indices[j] = temp;
      }
    }
  }
  
  int[] kNearest = new int[k];
  for (int i = 0; i < k; i++) {
    kNearest[i] = indices[i + 1];
  }
  
  return kNearest;
}
