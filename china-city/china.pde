Table table;
ArrayList<City> graph = new ArrayList<City>();
ArrayList<Particle> p_list = new ArrayList<Particle>();
float phase = 0;
boolean save = true;

void setup() {
  size(2560, 1440);
  background(0);
  frameRate(60);
  
  fill(255);

  table = loadTable("cn.csv", "header");

  println(table.getRowCount() + " total rows in table");

  float min_lat = 18.2536;
  float max_lat = 52.9906;
  float min_lng = 75.9833;
  float max_lng = 131.1187;
  
  int min_connect = 3;
  int max_connect = 7;
  int connect_compensate = 3;
  
  int scale = 34;

  for (TableRow row : table.rows()) {
    float pop = row.getFloat("population");
    //if (Float.isNaN(pop) && random(1) > 0.6) {
    ArrayList<String> important = new ArrayList<String>();
    important.add("must");
    important.add("admin");
    important.add("primary");
    String importance = row.getString("capital");
    if (important.contains(importance) || random(1) < 0.5) {
      float lat = row.getFloat("lat");
      float lng = row.getFloat("lng");
      String name = row.getString("city");
      
      //float y = map(lat, max_lat, min_lat, height/6, height*5/6);
      //float x = map(lng, min_lng, max_lng, width/6, width*5/6);
      float y = height - (lat - min_lat) * scale - 150;
      float x = 300 + (lng - min_lng) * scale;
      if (Float.isNaN(pop)) {
        City city_tmp = new City(new PVector(x, y), 2, int(random(min_connect, max_connect+1)), name);
        graph.add(city_tmp);
      } else {
        float dot_size = map(pop, 600, 22200000, 3, 15);
        City city_tmp = new City(new PVector(x, y), dot_size, int(random(4, 6)), name);
        graph.add(city_tmp);
      }
    }
  }
  for (int i=0; i<graph.size(); i++) {
    int des_conet_i = graph.get(i).num_conet - graph.get(i).neighbor.size();
    //if (des_conet_i <= 0) continue;
    ArrayList<Float> dist_list = new ArrayList<Float>();
    for (int j=0; j<graph.size(); j++) {
      int des_conet_j = graph.get(j).num_conet - graph.get(j).neighbor.size();
      if (des_conet_j <= 0) {
        dist_list.add(99999.);
        continue;
      }
      float distant = dist(graph.get(i).loc.x, graph.get(i).loc.y, graph.get(j).loc.x, graph.get(j).loc.y);
      dist_list.add(distant);
    }
    
    for (int j=0; j<des_conet_i; j++) {
      float min_dist = 9999;
      int min_idx = 0;
      for (int k=0; k<dist_list.size(); k++) {
        if (dist_list.get(k) < min_dist) {
          min_dist = dist_list.get(k);
          min_idx = k;
        }
      }
      if (dist(graph.get(i).loc.x, graph.get(i).loc.y, graph.get(min_idx).loc.x, graph.get(min_idx).loc.y) < 200) {
        graph.get(i).connect(graph.get(min_idx));
        dist_list.set(min_idx, 99999.);
      } else {
        for (int ha=0; ha<connect_compensate; ha++) {
          float min_distance = 9999;
          int min_d_node = 0;
          for (int he=0; he<graph.size(); he++) {
            float distance = dist(graph.get(i).loc.x, graph.get(i).loc.y, graph.get(he).loc.x, graph.get(he).loc.y);
            if (i != he && (!graph.get(i).isConnected(graph.get(he))) && distance < min_distance) {
              min_distance = distance;
              min_d_node = he;
            }
          }
          graph.get(i).connect(graph.get(min_d_node));
        }
      }
    }
  }
  draw_graph();
  City city_zero = graph.get(int(random(0, graph.size())));
  spread_particle(city_zero);
}

void draw_graph() {
  noStroke();
  for (int i=0; i<graph.size(); i++) {
    fill(255., 255., 235, map(sin(graph.get(i).lightness), -1, 1, 20, 60));
    circle(graph.get(i).loc.x, graph.get(i).loc.y, graph.get(i).size);
    graph.get(i).lightness += 0.09;
  }
  stroke(255., map(sin(phase), -1, 1, 40, 60));
  strokeWeight(0.25);
  for (int i=0; i<graph.size(); i++) {
    ArrayList<City> nei = graph.get(i).neighbor;
    for (int j=0; j<nei.size(); j++) {
      if (graph.indexOf(nei.get(j)) > i) {
        line(graph.get(i).loc.x, graph.get(i).loc.y, nei.get(j).loc.x, nei.get(j).loc.y);
      }
    }
  }
}

void spread_particle(City city) {
  city.visited_count ++;
  if (city.visited_count % city.buffer_visit != 1) return;
  city.valid_visit ++;
  
  if (city.valid_visit > city.max_visit) {
    city.valid_visit --;
    return;
  }
  
  for (City c: city.neighbor) {
    if (c.equals(city)) continue;
    p_list.add(new Particle(city.loc.x, city.loc.y, c));
  }
}

void draw() {
  //background(30);
  
  draw_graph();
  fill(0., 50);
  rect(0, 0, width, height);
  ArrayList<Particle> collect = new ArrayList<Particle>();
  for (Particle p: p_list) {
    if (p.arrived) {
      collect.add(p);
    }
  }
  p_list.removeAll(collect);
  for (Particle p: collect) {
    spread_particle(p.target_city);
  }
  for (Particle p: p_list) {
    p.update();
    p.display();
  }
  phase += 0.05;
  if (save) {
    saveFrame("output\\frame#####.png");
  }
}
