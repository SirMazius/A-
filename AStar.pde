import java.util.*; //<>// //<>//
World w;
Node test_init, test_end, test_init2, test_end2;
Boid boid_a, boid_b;
int cell_tam;
int col, row;
float dt = 0.1;
boolean follow;

void setup() {
  size(800, 800);
  cell_tam = 40;
  boid_a = new Boid(140/cell_tam * cell_tam + cell_tam/2, 140/cell_tam * cell_tam + cell_tam/2, new PVector(0, 0), 10, 40, 5, random_pos(), random_pos());
  //boid_b = new Boid(140/cell_tam * cell_tam + cell_tam/2, 140/cell_tam * cell_tam + cell_tam/2, new PVector(0, 0), 10, 40, 5);
  col = width / cell_tam;
  row = height / cell_tam;
  follow = false;
  test_init = new Node(60/cell_tam * cell_tam + cell_tam/2, 60/cell_tam * cell_tam + cell_tam/2);
  test_end = new Node(140/cell_tam * cell_tam + cell_tam/2, 140/cell_tam * cell_tam + cell_tam/2);

  test_init2 = new Node(60/cell_tam * cell_tam + cell_tam/2, 60/cell_tam * cell_tam + cell_tam/2);
  test_end2 = new Node(140/cell_tam * cell_tam + cell_tam/2, 140/cell_tam * cell_tam + cell_tam/2);
  w = new World();
  w.set_obstacles();
  follow = true;
  boid_a.generate_path();
}

void draw() {
  background(75);
  w.draw_world();
  w.update();
}

void keyPressed()
{
  switch(key) {
  case 'a':
    //print("HAY asd SHUR");
    if (w.aSTAR(test_init, test_end))
      print(" HAY CAMINO SHUR");
    else
      print(" NO HAY CAMINO SHUR");
    break;
  case 'o':
    w.set_obstacles();
    break;
  case 'r':
    w.init_grid();
    break;
  case 's':
    follow = true;
    //w.set_path(boid_a);
    //w.set_path(boid_b);
    boid_a.generate_path();
    break;
  }
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    test_init = new Node(mouseX/cell_tam * cell_tam + cell_tam/2, mouseY/cell_tam * cell_tam + cell_tam/2);
  } else if (mouseButton == RIGHT) {
    test_end = new Node(mouseX/cell_tam * cell_tam + cell_tam/2, mouseY/cell_tam * cell_tam + cell_tam/2);
    for (Boid b : l_boids_a)
      b.pos = new PVector(mouseX/cell_tam * cell_tam + cell_tam/2, mouseY/cell_tam * cell_tam + cell_tam/2);
    boid_a.pos = new PVector(mouseX/cell_tam * cell_tam + cell_tam/2, mouseY/cell_tam * cell_tam + cell_tam/2);
  }
}


Node random_pos() {
  //Node aux = new Node((int)random(50,width-100), (int)random(50,height-100));
  Node aux = new Node((int)random(100, width-100)/cell_tam * cell_tam + cell_tam/2, (int)random(100, height-100)/cell_tam * cell_tam + cell_tam/2);
  return aux;
}