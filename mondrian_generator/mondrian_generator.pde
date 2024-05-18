int lineThickness = 10; // Set the line thickness
int gridWidth = 840;
int gridHeight = 840;

int cols = 4; // Number of columns in the grid
int rows = 4; 

float colorPercent = 0.5;
int rectangleMaxSide = 2; // Maximum side size for rectangles
int noiseMax = 32; // Maximum noise value for color
float rectangleMaxSizePercent = 0.7; // Maximum size of a rectangle as a percentage of the grid size

int frameGap = 37; // Gap between frames

boolean[][] gridFilled = new boolean[rows][cols];

class Rectangle {
  int x, y, width, height;
  
  Rectangle(int x, int y, int width, int height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
}

Rectangle findLargestRectangle(boolean[][] grid) {
  int rows_ = grid.length;
  int cols_ = rows_ > 0 ? grid[0].length : 0;
  
  // Initialize height map
  int[] height = new int[cols_];
  int maxArea = 0;
  Rectangle maxRect = new Rectangle(0, 0, 0, 0); // x, y, width, height
  
  for (int i = 0; i < rows_; i++) {
    for (int j = 0; j < cols_; j++) {
      // Update height map
      height[j] = !grid[i][j] ? height[j] + 1 : 0;
    }
    
    // Use a stack to find the largest rectangle with bottom line at current row
    ArrayList<Integer> stack = new ArrayList<Integer>();
    stack.add(-1); // Add sentinel value for easier calculations
    
    for (int j = 0; j <= cols_; j++) { // Add extra column to ensure the stack is emptied at the end
      while (stack.get(stack.size() - 1) != -1 && (j == cols_ || height[j] <= height[stack.get(stack.size() - 1)])) {
        int h = height[stack.remove(stack.size() - 1)];
        int w = j - stack.get(stack.size() - 1) - 1;
        if (h * w > maxArea) {
          maxArea = h * w;
          maxRect = new Rectangle(stack.get(stack.size() - 1) + 1, i - h + 1, w, h);
        }
      }
      stack.add(j);
    }
  }
  
  return maxRect;
}

void setup() {
  size(1080, 1920); 
  frameRate(30);
  background(255, 254, 251); 
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      gridFilled[i][j] = false;
    }
  }
}

void draw() {
  int imageNum = frameCount / frameGap;
  print("Frame: " + frameCount + " Image: " + imageNum + "\n");
  if ((frameCount-1) % frameGap == 0) {
    stroke(0); 
    strokeWeight(lineThickness); 
    println(cols + " " + rows);
    gridFilled = new boolean[rows][cols];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        gridFilled[i][j] = false;
      }
    }
    background(255, 254, 251);

    float colSpacing = gridWidth / (float) cols;
    float rowSpacing = gridHeight / (float) rows;

    float offsetX = (width - gridWidth) / 2;
    float offsetY = (height - gridHeight) / 2;

    fillRandomRectangles(offsetX, offsetY, colSpacing, rowSpacing);

    if (imageNum > 0 && imageNum % 2 == 0) {
      cols++;
      rows++;
      rectangleMaxSide = (int) (cols * rectangleMaxSizePercent);
    }
    if (imageNum > 0 && imageNum % 13 == 0) {
      colorPercent += 0.1;
      colorPercent = min(1, colorPercent);
      rectangleMaxSizePercent -= 0.1;
    }
  }
  // saveFrame("output/screen-####.png");

  if (frameCount > 1652) {
    exit();
  }
}

void fillRandomRectangles(float offsetX, float offsetY, float colSpacing, float rowSpacing) {
  while (true) {
    Rectangle rect = findLargestRectangle(gridFilled);
    if (rect.width == 0 || rect.height == 0) {
      break;
    }
    int gridFillWidth = min((int) random(1, rectangleMaxSide + 1), rect.width);
    int gridFillHeight = min((int) random(1, rectangleMaxSide + 1), rect.height);
    int rectX = (int) (offsetX + rect.x * colSpacing);
    int rectY = (int) (offsetY + rect.y * rowSpacing);
    int rectWidth = (int) (gridFillWidth * colSpacing);
    int rectHeight = (int) (gridFillHeight * rowSpacing);
    color baseColor = getRandomColor();
    for (int i = rectX+lineThickness/5; i < rectX + rectWidth-lineThickness/5; i++) {
      for (int j = rectY+lineThickness/5; j < rectY + rectHeight-lineThickness/5; j++) {
        int noiseR = (int) random(0, noiseMax) - noiseMax / 2;
        int noiseG = (int) random(0, noiseMax) - noiseMax / 2;
        int noiseB = (int) random(0, noiseMax) - noiseMax / 2;
        stroke(red(baseColor) + noiseR, green(baseColor) + noiseG, blue(baseColor) + noiseB);
        point(i, j);
      }
    }
    noFill();
    stroke(0);
    rect(rectX, rectY, rectWidth, rectHeight);
    for (int i = rect.y; i < rect.y + gridFillHeight; i++) {
      for (int j = rect.x; j < rect.x + gridFillWidth; j++) {
        gridFilled[i][j] = true;
      }
    }
  }
  rect(offsetX, offsetY, gridWidth, gridHeight);
}



color getRandomColor() {
  if (random(1) < colorPercent) {
    int choice = (int)random(4); 
    switch (choice) {
      case 0: return color(236, 64, 40); // Red
      case 1: return color(55, 85, 161); // Blue
      case 2: return color(247, 201, 64); // Yellow
      case 3: return color(51, 51, 51); // Black
      default: return color(255, 254, 251); // White
    }
  } else {
    return color(255, 254, 251); // White
  }
}
