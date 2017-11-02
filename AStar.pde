World w;
Node test_init, test_end;
int cell_tam;
int col, row;

void setup() {
  size(800, 800);
  cell_tam = 20;
  col = width / cell_tam;
  row = height / cell_tam;
  test_init = new Node(60, 60);
  test_end = new Node(140, 140);
  w = new World();
}

void draw() {
  background(75);
  w.draw_world();
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
  }
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    test_init = new Node(mouseX/cell_tam * cell_tam + cell_tam/2, mouseY/cell_tam * cell_tam + cell_tam/2);
  } else if (mouseButton == RIGHT) {
    test_end = new Node(mouseX/cell_tam * cell_tam + cell_tam/2, mouseY/cell_tam * cell_tam + cell_tam/2);
  }
}