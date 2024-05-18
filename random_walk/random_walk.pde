final int gridSize = 20; // Size of each grid cell
final int stepPerFrame = 27; // Number of steps per frame for each walker
int[][] visitCount; // Array to keep track of visits to each cell by all walkers
int totalFrames = 280;
int[][] walkerAssignment;

color[] bubbleGradient = {
  color(35,137,218),
  color(116,204,244),
  color(180, 212, 255),
  color(238, 245, 255),
};

color[] redGradient = {
  color(255, 189, 189),
  color(255, 131, 131),
  color(255, 92, 92),
  color(255, 54, 54),
};

color[] blueGradient = {
  color(189, 189, 255),
  color(131, 131, 255),
  color(92, 92, 255),
  color(54, 54, 255),
};

class Walker {
  int x, y; // Current position of the walker
  int stepSize; // How far the walker moves in each step
  color[] gradient; // Color gradient for the walker

  Walker(int startX, int startY, int stepSize, color[] gradient) {
    this.x = startX;
    this.y = startY;
    this.stepSize = stepSize;
    this.gradient = gradient;
  }

  void step() {
    // Randomly select a direction
    int[] directions = {-1, 0, 1};
    x += randomSelectFromArray(directions) * stepSize;
    y += randomSelectFromArray(directions) * stepSize;

    // Implement Pac-Man style wrap-around
    x = (x + width) % width;
    y = (y + height) % height;
  }
}


// Declare an array of walkers
Walker[] walkers;

int randomSelectFromArray(int[] arr) {
  int index = int(random(arr.length));
  return arr[index];
}

void setup() {
  size(1080, 1920);
  frameRate(30);
  background(25);
  visitCount = new int[width/gridSize][height/gridSize];
  walkerAssignment = new int[width/gridSize][height/gridSize];

  // Initialize walkers with their respective gradients
  walkers = new Walker[2];
  walkers[0] = new Walker(width / 2, height * 2 / 5, gridSize, redGradient); // Top walker with red gradient
  walkers[1] = new Walker(width / 2, height * 3 / 5, gridSize, blueGradient); // Bottom walker with blue gradient
}


void draw() {
  for (int i = 0; i < stepPerFrame; i++) {
    for (int wakerIdx = 0; wakerIdx < walkers.length; wakerIdx++) {
      walkers[wakerIdx].step();
      updateGrid(walkers[wakerIdx], wakerIdx);
    }
  }
  saveFrame("output/screen-####.png");
  if (frameCount == totalFrames) {
    exit();
  }
}

void updateGrid(Walker walker, int walkerIdx) {
  // Calculate grid positions
  int gridX = walker.x / gridSize;
  int gridY = walker.y / gridSize;

  // Update visit count
  visitCount[gridX][gridY]++;
  walkerAssignment[gridX][gridY] = walkerIdx;

  // Draw the grid with the walker's specific gradient
  for (int i = 0; i < visitCount.length; i++) {
    for (int j = 0; j < visitCount[i].length; j++) {
      if (visitCount[i][j] > 0 && walkerAssignment[i][j] == walkerIdx) {
        float visitPortion = min(visitCount[i][j] * 0.2, 1.0);
        color fillColor = getGradientColor(visitPortion, walker.gradient); // Use walker's gradient
        strokeWeight(min(ceil(visitCount[i][j] * 0.5), 5));
        fill(fillColor);
        rect(i * gridSize, j * gridSize, gridSize, gridSize);
      }
    }
  }
}

color getGradientColor(float portion, color[] gradient) {
  float[] vPortions = new float[gradient.length];
  for (int i = 0; i < gradient.length; i++) {
    vPortions[i] = map(i, 0, gradient.length - 1, 0, 1);
  }

  for (int i = 0; i < vPortions.length - 1; i++) {
    if (portion >= vPortions[i] && portion <= vPortions[i + 1]) {
      float portionInThisRange = (portion - vPortions[i]) / (vPortions[i + 1] - vPortions[i]);
      return lerpColor(gradient[i], gradient[i + 1], portionInThisRange);
    }
  }
  return color(0);
}
