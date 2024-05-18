float time = -0.31;
float deltaT = 0.003;

float A1 = 250, A2 = 250, A3 = 250, A4 = 250;
float f1 = 4, f2 = 1, f3 = 4, f4 = 1;
float d1 = 0.0005, d2 = 0.005, d3 = 0.0005, d4 = 0.005;
float p1 = PI/2, p2 = 0, p3 = 0, p4 = PI/2;

int draw_frame_end = 256;
int collapse_frame = 579;
int total_frame = 630;
int total_step = 95000;
int step_per_frame = total_step / draw_frame_end;

float[] as = {A1, A2, A3, A4};
float[] fs = {f1, f2, f3, f4};
float[] ds = {d1, d2, d3, d4};
float[] ps = {p1, p2, p3, p4};

// Define a class to hold the coordinates
class Point {
  float x, y;
  
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

// Create an array list to store points
ArrayList<Point> points = new ArrayList<Point>();

void setup() {
  size(1080, 1920);
  background(25);

  frameRate(30);
}


int current_step = 0; 

int calculateStepsForFrame(int frame, int totalFrames, int totalSteps) {
  float progress = (float)frame / totalFrames;
  float weight = pow(progress, 3); 
  return (int)(weight * totalSteps)+1;
}

void draw() {
  background(25);
  stroke(255, 55);
  strokeWeight(2);
  translate(width/2, height/2);

  if (frameCount <= draw_frame_end) {
    int stepsForThisFrame;
    if (frameCount == 1) {
      // Calculate steps for the first frame
      stepsForThisFrame = calculateStepsForFrame(1, draw_frame_end, total_step) - current_step;
    } else {
      // Calculate steps for the current frame
      stepsForThisFrame = calculateStepsForFrame(frameCount, draw_frame_end, total_step) - current_step;
    }

    stepsForThisFrame = max(stepsForThisFrame, 1);

    if (frameCount > 1) {
      stepsForThisFrame += 3;
    }
    println(frameCount, stepsForThisFrame);


    for (int i = 0; i < stepsForThisFrame; i++) {
      float x = as[0] * sin(fs[0] * time + ps[0]) * exp(-ds[0] * time) + as[1] * sin(fs[1] * time + ps[1]) * exp(-ds[1] * time);
      float y = as[2] * sin(fs[2] * time + ps[2]) * exp(-ds[2] * time) + as[3] * sin(fs[3] * time + ps[3]) * exp(-ds[3] * time);
      
      // Add the point to the list
      points.add(new Point(x, y));
      
      time += deltaT;
      current_step++;
    }
  }
  else if (frameCount <= collapse_frame) {
    float time = -0.52;
    points.clear();
    float mid_fs1 = map(frameCount - draw_frame_end, 0, collapse_frame - draw_frame_end, 4, 5);
  
    fs[0] = mid_fs1;
    fs[1] = 1;
    fs[2] = mid_fs1;
    fs[3] = 1;


    for (int i = 0; i <= total_step; i++) {
      float x = as[0] * sin(fs[0] * time + ps[0]) * exp(-ds[0] * time) + as[1] * sin(fs[1] * time + ps[1]) * exp(-ds[1] * time);
      float y = as[2] * sin(fs[2] * time + ps[2]) * exp(-ds[2] * time) + as[3] * sin(fs[3] * time + ps[3]) * exp(-ds[3] * time);
      
      // Add the point to the list
      points.add(new Point(x, y));
      
      time += deltaT;
    }
  }
  else if (frameCount <= total_frame) {
    float time = -0.52;
    points.clear();

    float aaa = map(frameCount - collapse_frame, 0, total_frame - collapse_frame, 250, 0);

    as[0] = aaa;
    as[1] = aaa;
    as[2] = aaa;
    as[3] = aaa;

    for (int i = 0; i <= total_step; i++) {
      float x = as[0] * sin(fs[0] * time + ps[0]) * exp(-ds[0] * time) + as[1] * sin(fs[1] * time + ps[1]) * exp(-ds[1] * time);
      float y = as[2] * sin(fs[2] * time + ps[2]) * exp(-ds[2] * time) + as[3] * sin(fs[3] * time + ps[3]) * exp(-ds[3] * time);
      
      // Add the point to the list
      points.add(new Point(x, y));
      
      time += deltaT;
    }
  }
  else {
    exit();
  }
  
  // Now draw lines between successive points
  for (int i = 1; i < points.size(); i++) {
    Point p1 = points.get(i-1);
    Point p2 = points.get(i);
    line(p1.x, p1.y, p2.x, p2.y);
  }

  // Draw the last point
  if (frameCount <= draw_frame_end || frameCount > total_frame - 20) {
    stroke(255);
    if (points.size() >= 1) {
      Point lastPoint = points.get(points.size()-1);
      ellipse(lastPoint.x, lastPoint.y, 5, 5);
    }
  }
  
  //saveFrame("output/screen-####.png");
}
