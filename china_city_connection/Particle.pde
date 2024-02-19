class Particle {
 
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;
  
  City target_city;
  City from_city;
  boolean arrived;
 
  Particle(float x, float y, City target) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 4.0;
    maxspeed = random(2, 8);
    maxforce = random(0.2, 1.5);
    target_city = target;
    arrived = false;
  }
 
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
    arrived = this.arrive(this.target_city.loc);
  }
 
  void applyForce(PVector force) {
    acceleration.add(force);
  }
 
  void display() {
    fill(255, 255, 225);
    circle(location.x,location.y, r);
  }
  
  boolean arrive(PVector target) {
    PVector desired = PVector.sub(target,location);
    
    float d = desired.mag();
    if (d < 1.5) return true;
    desired.normalize();
    if (d < 100) {
      float m = map(d,0,100,0,maxspeed);
      desired.mult(m);
    } else {
      desired.mult(maxspeed);
    }
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    applyForce(steer);
    return false;
  }
}
