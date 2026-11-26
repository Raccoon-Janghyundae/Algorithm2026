import java.util.Collections;
import java.util.Comparator;

ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();
ArrayList<Edge> mstEdges = new ArrayList<Edge>();

UnionFind uf;
PFont korFont;
int currentEdgeIndex = 0;
int totalWeight = 0;
boolean mstFinished = false;
boolean autoStep = true;
int lastStepTime = 0;
int stepDelay = 700;

void setup() {
  size(900, 600);
  smooth(8);
  korFont = createFont("Malgun Gothic", 16, true);
  textFont(korFont);
  textAlign(CENTER, CENTER);
  textSize(14);
  initGraph();
}

void initGraph() {
  nodes.clear();
  edges.clear();
  mstEdges.clear();
  currentEdgeIndex = 0;
  totalWeight = 0;
  mstFinished = false;
  lastStepTime = millis();

  nodes.add(new Node(0, 180, 160));
  nodes.add(new Node(1, 360, 110));
  nodes.add(new Node(2, 560, 140));
  nodes.add(new Node(3, 720, 260));
  nodes.add(new Node(4, 580, 440));
  nodes.add(new Node(5, 340, 450));
  nodes.add(new Node(6, 170, 360));

  addEdge(0, 1, 7);
  addEdge(0, 6, 8);
  addEdge(1, 6, 3);
  addEdge(1, 2, 6);
  addEdge(1, 5, 4);
  addEdge(2, 5, 2);
  addEdge(2, 3, 5);
  addEdge(3, 4, 9);
  addEdge(4, 5, 10);
  addEdge(5, 6, 11);

  Collections.sort(edges, new Comparator<Edge>() {
    public int compare(Edge a, Edge b) {
      return Integer.compare(a.weight, b.weight);
    }
  });

  uf = new UnionFind(nodes.size());

  println("=== Kruskal MST 시작 ===");
  println("정렬된 간선 수: " + edges.size());
}

void addEdge(int u, int v, int w) {
  edges.add(new Edge(nodes.get(u), nodes.get(v), w));
}

void draw() {
  background(248, 250, 252);

  if (!mstFinished && autoStep && millis() - lastStepTime > stepDelay) {
    stepKruskal();
    lastStepTime = millis();
  }

  drawEdges();
  drawNodes();
  drawHUD();
}

void stepKruskal() {
  if (mstFinished || currentEdgeIndex >= edges.size() || mstEdges.size() >= nodes.size() - 1) {
    mstFinished = true;
    println("=== MST 완성! 총 가중치: " + totalWeight + " ===");
    return;
  }

  Edge e = edges.get(currentEdgeIndex);
  currentEdgeIndex++;

  if (uf.union(e.u.id, e.v.id)) {
    e.state = 1;
    mstEdges.add(e);
    totalWeight += e.weight;
    println("선택 간선 (" + e.u.id + " - " + e.v.id + ") 가중치: " + e.weight + " | 누적 비용: " + totalWeight);

    if (mstEdges.size() == nodes.size() - 1) {
      mstFinished = true;
      println("=== MST 완성! 총 가중치: " + totalWeight + " ===");
    }
  } else {
    e.state = -1;
    println("제외 간선 (" + e.u.id + " - " + e.v.id + ") 가중치: " + e.weight + " (사이클 형성)");
  }
}

void drawEdges() {
  for (Edge e : edges) {
    if (e.state == 1) {
      stroke(16, 185, 129);
      strokeWeight(4.5);
    } else if (e.state == -1) {
      stroke(220, 226, 232);
      strokeWeight(1.5);
    } else {
      stroke(148, 163, 184);
      strokeWeight(2);
    }

    line(e.u.x, e.u.y, e.v.x, e.v.y);

    float mx = (e.u.x + e.v.x) / 2.0;
    float my = (e.u.y + e.v.y) / 2.0;

    fill(255);
    stroke(203, 213, 225);
    strokeWeight(1);
    ellipse(mx, my, 24, 24);

    if (e.state == 1) {
      fill(5, 150, 105);
    } else if (e.state == -1) {
      fill(156, 163, 175);
    } else {
      fill(30, 41, 59);
    }
    text(e.weight, mx, my);
  }
}

void drawNodes() {
  for (Node n : nodes) {
    fill(30, 64, 175);
    stroke(255);
    strokeWeight(2.5);
    ellipse(n.x, n.y, 38, 38);

    fill(255);
    text(n.id, n.x, n.y);
  }
}

void drawHUD() {
  fill(15, 23, 42);
  textAlign(LEFT, TOP);
  textSize(16);
  String status = mstFinished ? "완료 (MST 완성)" : (autoStep ? "자동 진행 중" : "일시정지 (SPACE로 한 단계 진행)");
  text("최소 신장 트리 (Kruskal) | 상태: " + status, 24, 20);

  textSize(14);
  text("선택된 간선: " + mstEdges.size() + " / " + (nodes.size() - 1) + "   |   현재 최소 비용 합계: " + totalWeight, 24, 46);

  fill(100, 116, 139);
  textSize(12);
  text("[SPACE] 한 단계 진행 / 자동 전환   |   [R] 그래프 초기화", 24, height - 28);

  textAlign(RIGHT, TOP);
  fill(5, 150, 105);
  text("초록선: MST 채택 간선", width - 24, 20);
  fill(156, 163, 175);
  text("연회색선: 사이클 발생으로 제외", width - 24, 40);

  textAlign(CENTER, CENTER);
  textSize(14);
}

void keyPressed() {
  if (key == ' ') {
    autoStep = !autoStep;
    if (!autoStep && !mstFinished) {
      stepKruskal();
    }
  } else if (key == 'r' || key == 'R') {
    initGraph();
  }
}

class Node {
  int id;
  float x, y;

  Node(int id, float x, float y) {
    this.id = id;
    this.x = x;
    this.y = y;
  }
}

class Edge {
  Node u, v;
  int weight;
  int state = 0;

  Edge(Node u, Node v, int weight) {
    this.u = u;
    this.v = v;
    this.weight = weight;
  }
}

class UnionFind {
  int[] parent;
  int[] rank;

  UnionFind(int n) {
    parent = new int[n];
    rank = new int[n];
    for (int i = 0; i < n; i++) {
      parent[i] = i;
      rank[i] = 0;
    }
  }

  int find(int x) {
    if (parent[x] != x) {
      parent[x] = find(parent[x]);
    }
    return parent[x];
  }

  boolean union(int a, int b) {
    int rootA = find(a);
    int rootB = find(b);
    if (rootA == rootB) {
      return false;
    }

    if (rank[rootA] < rank[rootB]) {
      parent[rootA] = rootB;
    } else if (rank[rootA] > rank[rootB]) {
      parent[rootB] = rootA;
    } else {
      parent[rootB] = rootA;
      rank[rootA]++;
    }
    return true;
  }
}
