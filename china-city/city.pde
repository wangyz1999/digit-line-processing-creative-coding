class City
{
  PVector loc;
  float size;
  ArrayList<City> neighbor;
  int num_conet;
  String name;
  int visited_count;
  int max_visit;
  int valid_visit;
  int buffer_visit;
  float lightness;
  City previous_incomming;
  City(PVector iloc, float isize, int inum_connet, String iname) {
    loc = iloc;
    size = isize;
    num_conet = inum_connet;
    neighbor = new ArrayList<City>();
    name = iname;
    visited_count = 0;
    max_visit = 10;
    buffer_visit = 5;
    valid_visit = 0;
    lightness = random(2*PI);
  }
  
  void connect(City other) {
    this.neighbor.add(other);
    other.neighbor.add(this);
  }
  
  boolean isConnected(City other) {
    return this.neighbor.contains(other);
  }
}
