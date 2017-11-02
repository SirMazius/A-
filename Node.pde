class Node {
  Node parent;
  int x;
  int y;
  float f, g, h;
  boolean obstacle;
  Node(int _x, int _y) {
    x = _x;
    y = _y;
    f = g = h = 0;
    parent = null;
    obstacle = false;
  }

  void draw_node() {
    
    rect(x-cell_tam/2, y-cell_tam/2, cell_tam, cell_tam);
    //ellipse(x,y,10,10);
  }

  float heuristic(Node b) {
    //return dist(x,b,x,y,b.y);
    return abs(x - b.x) + abs(y - b.y);
  }
}