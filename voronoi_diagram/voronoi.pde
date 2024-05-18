PImage image; 
ArrayList<PVector> points; 
int[][] colors; 

int max_points = 900; 
int framerate = 30;
int current_points = 0;

void setup() {
  size(1080, 1920); 

  frameRate(framerate); 
   image = loadImage("mona_lisa.jpg");

  points = new ArrayList<PVector>();
  colors = new int[max_points + 200][3];  
}

void draw() {
  background(255);

  println(str(frameCount) + " / " + str(280));

  int pointsToDraw;
  if (frameCount <= 30) {
    pointsToDraw = 1;
  } else if (frameCount <= 90) {
    pointsToDraw = 2;
  } else if (frameCount <= 180) {
    pointsToDraw = 3;
  } else if (frameCount <= 300) {
    pointsToDraw = 4;
  } else {
    pointsToDraw = 5;
  } 

  for (int index = 0; index < pointsToDraw; index++) {
    float xpos = random(0, width);
    float ypos = random(0, height);
    points.add(new PVector(xpos, ypos));
    int newIndex = points.size() - 1;
    int xpos_img = int(map(xpos, 0, width, 0, image.width));
    int ypos_img = int(map(ypos, 0, height, 0, image.height));
    color c = image.get(xpos_img, ypos_img);

    
    colors[newIndex] = new int[3];
    colors[newIndex][0] = int(red(c));
    colors[newIndex][1] = int(green(c));
    colors[newIndex][2] = int(blue(c));
  }
  

  // For every pixel on the screen, determine which point it is closest to
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int closestIndex = 0;
      float recordDistance = dist(x, y, points.get(0).x, points.get(0).y);
      
      for (int i = 1; i < points.size(); i++) {
        float d = dist(x, y, points.get(i).x, points.get(i).y);
        if (d < recordDistance) {
          recordDistance = d;
          closestIndex = i;
        }
      }
      
      // Set the pixel to the color of the closest point
      stroke(colors[closestIndex][0], colors[closestIndex][1], colors[closestIndex][2]);
      point(x, y);
    }
  }
  
  // Draw the points on top
  // for (PVector p : points) {
  //   fill(255);
  //   stroke(0);
  //   ellipse(p.x, p.y, 10, 10);
  // }

  saveFrame("mona_lisa/screen-####.png");
  if (frameCount == 280) {
    exit();
  }
}
