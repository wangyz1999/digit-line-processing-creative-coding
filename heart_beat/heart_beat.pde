float heartSize = 2800; // Base size of the heart
float maxScale = 0.5; // Maximum scale variation for the beat
float scale = 1;
float[] onsetList = {0, 1.8, 3.2, 4.4, 5.4, 6.3, 7.1, 7.87, 8.61, 9.35, 10.08, 10.83, 11.57, 12.31, 13.05, 13.79, 14.53, 15.27, 16.01, 16.75, 17.49, 18.23, 18.97, 19.71, 20.45, 21.19, 21.93, 22.67, 23.41, 24.15, 24.89, 25.63, 26.37, 27.11, 27.85, 28.59, 29.33}; // Onset times in seconds
int lastOnsetIndex = 0; // Tracks the last onset we passed

void setup() {
  size(1080, 1920);
  frameRate(30);
}

void draw() {
  background(0);
  translate(width / 2, height / 2);
  handleHeartbeat();
  
  saveFrame("output_2/screen-####.png");
  if (frameCount == (int) (30 * 29.33)) {
    exit();
  }
}

void handleHeartbeat() {
  float currentTime = frameCount / 30.0;
  float progress = 0;
  float duration = 0;

  // Find the current and next onset times
  for (int i = lastOnsetIndex; i < onsetList.length - 1; i++) {
    if (currentTime >= onsetList[i] && currentTime < onsetList[i + 1]) {
      float currentBeatTime = onsetList[i];
      float nextBeatTime = onsetList[i + 1];
      duration = nextBeatTime - currentBeatTime;
      progress = (currentTime - currentBeatTime) / duration;
      lastOnsetIndex = i; // Update last onset index
      break;
    }
  }

  // Beat to rest ratio
  float beatDuration = duration * 0.3; // 20% of interval
  float restDuration = duration * 0.7; // 80% of interval
  float phaseProgress = currentTime - onsetList[lastOnsetIndex];

  // Adjust scale based on beat or rest phase
  if (phaseProgress <= beatDuration) {
    // Scale up quickly during the beat phase
    scale = 1 + maxScale * (phaseProgress / beatDuration);
  } else {
    // Scale down smoothly during the rest phase
    float restProgress = (phaseProgress - beatDuration) / restDuration;
    scale = 1 + maxScale * (1 - restProgress);
  }

  // Apply transformations and draw the heart
  pushMatrix();
  scale(scale);
  color c = color(136,8,8);
  float sync_factor = map(abs(phaseProgress - beatDuration), 0, restDuration, 1.3, 1);
  color c_synced = adjustBrightness(c, sync_factor);
  fill(136,8,8,10);
  stroke(c_synced);
  strokeWeight(4);

  if (frameCount > 30 * 5) {
    heartSize = map(frameCount - 30*5, 0, 30 * 29.33- 30*5, 2800, 2800 * 1.18);
  }
  drawHeart(heartSize);
  popMatrix();
}

// void drawHeart(float size) {
//   beginShape();
//   for (float t = 0; t < TWO_PI; t += 0.01) {
//     float x = 16 * pow(sin(t), 3) * size / 200;
//     float y = -(13 * cos(t) - 5 * cos(2*t) - 2 * cos(3*t) - cos(4*t)) * size / 200;
//     vertex(x, y);
//   }
//   endShape(CLOSE);
// }

void drawHeart(float size) {
  // Random displacement for glitch effect
  float glitchDisplacement;
  
  if (frameCount < 30 * 5) {
    glitchDisplacement = 0;
  } else if (frameCount < 30 * 15){
    float glitchMagnitude = map(frameCount, 30 * 5, 30 * 12, 0, 15);
    glitchDisplacement = random(-glitchMagnitude, glitchMagnitude);
  } else {
    float glitchMagnitude = map(frameCount, 30 * 12, 30 * 29.33, 15, 45);
    glitchDisplacement = random(-glitchMagnitude, glitchMagnitude);
  }
  
  beginShape();
  for (float t = 0; t < TWO_PI; t += 0.01) {
    float x = 16 * pow(sin(t), 3) * size / 200 + random(-glitchDisplacement, glitchDisplacement);
    float y = -(13 * cos(t) - 5 * cos(2*t) - 2 * cos(3*t) - cos(4*t)) * size / 200 + random(-glitchDisplacement, glitchDisplacement);
    vertex(x, y);
  }
  endShape(CLOSE);
}

// Util function to adjust the brightness of a color
// colorValue: the original color
// brightnessFactor: the factor to adjust brightness (1 for no change, <1 for darker, >1 for brighter)
color adjustBrightness(color colorValue, float brightnessFactor) {
  // Extract the RGB components from the color
  float r = red(colorValue);
  float g = green(colorValue);
  float b = blue(colorValue);
  
  // Scale the RGB components
  r = constrain(r * brightnessFactor, 0, 255);
  g = constrain(g * brightnessFactor, 0, 255);
  b = constrain(b * brightnessFactor, 0, 255);
  
  // Re-create the color with the new RGB values and return it
  return color(r, g, b);
}
