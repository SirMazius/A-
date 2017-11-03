class Boid {
  Vector<Node> path;
  Node init, end;
  PVector pos, vel, acc;
  float mass, max_vel, max_force, r;
  float cohesion, separation, aligment = 1;

  Boid(float x, float y, PVector _vel, float _max_vel, float _max_force, float tam, Node _init, Node _end) {
    path = new Vector<Node>();
    init = _init;
    end = _end;
    pos = new PVector(_end.x, _end.y);
    acc = new PVector(0, 0);
    vel = _vel;

    separation =2;
    cohesion = 1;
    aligment = 1;

    max_vel = _max_vel;
    max_force = _max_force;
    mass = 5.5;
    r = tam;
  }

  //Mult es un valor para los pesos 
  void seek(PVector target, float mult) {
    PVector desired = PVector.sub(target, pos);
    desired.setMag(max_vel);
    PVector seek = PVector.sub(desired, vel);
    seek.limit(max_force);
    add_force(PVector.mult(seek, mult));
  }

  void arrive(PVector target) {
    PVector desired = PVector.sub(target, pos);
    if (desired.mag() < 200)
      desired.setMag(map(desired.mag(), 0, 500, 0, max_vel));
    else
      desired.setMag(max_vel);
    PVector seek = PVector.sub(desired, vel);
    seek.limit(max_force);
    add_force(PVector.mult(seek, 1));
  }

  void flee(PVector target, float mult) {  
    if (PVector.dist(pos, target) < 25) //350
      seek(PVector.add(pos, PVector.sub(pos, target)), mult);
  }

  void flock(ArrayList<Boid> l_boid) {
    cohesion(cohesion, l_boid);
    separate(separation, l_boid);
    align(aligment, l_boid);
  }

  void pursue(Boid target) {
    seek(pred_pos(target), 1);
  }

  void evade(Boid target) {
    flee(pred_pos(target), 1);
  }

  void separate(float mult, ArrayList<Boid> l_boids) {
    float separation = 35;
    float count = 0;
    PVector steer = new PVector(0, 0, 0);

    for (Boid b : l_boids) {
      float distance = PVector.dist(b.pos, pos);
      if ( distance < separation && distance > 0) {
        PVector dist = PVector.sub(b.pos, pos);
        dist.normalize();
        steer.add(dist);
        count++;
      }
    }

    if (count > 0) {
      steer.setMag(max_vel);
      flee(PVector.add(pos, steer), mult);
    }
  }

  void cohesion(float mult, ArrayList<Boid> l_boids) {
    float dist_max = 75; 
    PVector suma_pos = new PVector(0, 0);
    float count = 0;
    for (Boid b : l_boids)
      if (PVector.dist(pos, b.pos) < dist_max && PVector.dist(pos, b.pos) > 15  ) {
        suma_pos.add(b.pos);
        count++;
      }
    if (count > 0) 
      seek(PVector.div(suma_pos, count), mult);
  }

  void align(float mult, ArrayList<Boid> l_boids) {
    float dist_max = 50; //Distancia maxima a la que se alinearan
    PVector suma_vel = new PVector(0, 0);
    for (Boid b : l_boids)
      if (PVector.dist(pos, b.pos) < dist_max)
        suma_vel.add(b.vel);

    suma_vel.setMag(max_vel); //normaliza y multiplica la velocidad resultante por la velocidad maxima
    seek(PVector.add(suma_vel, pos), mult);
  }

  // Calcula la posicion en la que estara un objeto en un determinado instante
  // en funcion de su velocidad
  PVector pred_pos(Boid b) { 
    float k = 0.05;
    float t_lim = 5;
    float t = k * PVector.dist(b.pos, pos);
    //t = t < t_lim ? t : t_lim;
    if (t < t_lim) {
      print(t + "LA T \n");
    } else {
      print(t + "LA t_lim \n");
      t = t_lim;
    }
    PVector pred_pos = PVector.add(b.pos, PVector.mult(b.vel, t));
    ellipse(pred_pos.x, pred_pos.y, 10, 10);
    return(pred_pos);
  }

  void add_force(PVector f) {
    acc.add(PVector.div(f, mass));
  }

  void update() {
    vel = PVector.add(vel, PVector.mult(acc, dt));
    vel.limit(max_vel);
    pos = PVector.add(pos, PVector.mult(vel, dt));
    acc.set(0, 0, 0);
  }

  void follow_path() {
    Node a = path.firstElement();
    PVector objective = new PVector(a.x, a.y);
    seek(objective, 1.0);
    if (PVector.dist(objective, pos) < 20 && path.size() > 1)
      path.remove(0);

    if (path.size() == 1) {

      path.clear();
      Node aux_pos = init;
      end = aux_pos;

      do {
        init = new Node((int)random(100, width-100)/cell_tam * cell_tam + cell_tam/2, (int)random(100, height-100)/cell_tam * cell_tam + cell_tam/2);
      } while (w.is_obstacle(test_init) || !w.aSTAR(init, end));

      w.set_path(this);
    }
  }

  void generate_path() {
    do {
      init = random_pos();
      end = random_pos();
    } while (!w.aSTAR(init, end));
      pos = new PVector(end.x,end.y);
      w.set_path(this);
  }

  void set_path(Vector<Node> _path) {
    path.clear();
    path = _path;
  }


  void display() {
    float theta = vel.heading() + PI/2;
    //fill(170, 0, 162);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
  }
}