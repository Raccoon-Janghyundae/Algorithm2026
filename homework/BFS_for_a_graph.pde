// BFS 애니메이션 (다크 테마 + 파동/패킷/토큰 이동 버전)
int n = 5;
int src = 0;
ArrayList<Integer>[] adj = new ArrayList[n];
PVector[] pos = {
  new PVector(150, 130), new PVector(450, 130), new PVector(300, 260),
  new PVector(170, 400), new PVector(430, 400)
};

boolean[] visited, done;
boolean[][] tree;
int[] dist;
ArrayList<Integer> queue, result;
int curr, ni, checkV;
boolean finished, paused = false;
String msg;
int interval = 60;          // 몇 프레임마다 한 단계 (작을수록 빠름)
int stepStart = 0;          // 마지막 단계가 시작된 프레임
int waitSteps = 0;
int restartDelay = 3;

// 애니메이션용 상태
float[] tx, ty;             // 토큰의 현재 위치
boolean lastNew = false;    // 방금 확인한 이웃이 새로 발견된 정점인지
int rippleNode = -1;        // 파동이 퍼지는 정점
int rippleStart = 0;

color BG = color(25, 28, 40);
color GRAY = color(90, 96, 115), YELLOW = color(255, 215, 80),
      ORANGE = color(255, 140, 50), GREEN = color(90, 210, 140);

void setup() {
  size(600, 700);
  textFont(createFont("Malgun Gothic", 16));  // 맥: "AppleSDGothicNeo-Regular"
  textAlign(CENTER, CENTER);
  for (int i = 0; i < n; i++) adj[i] = new ArrayList<Integer>();
  addEdge(1, 2); addEdge(1, 0); addEdge(2, 0); addEdge(2, 3); addEdge(2, 4);
  reset();
}

void addEdge(int u, int v) { adj[u].add(v); adj[v].add(u); }

void reset() {
  visited = new boolean[n];
  done = new boolean[n];
  tree = new boolean[n][n];
  dist = new int[n];
  tx = new float[n];
  ty = new float[n];
  queue = new ArrayList<Integer>();
  result = new ArrayList<Integer>();
  curr = -1; ni = 0; checkV = -1; finished = false;
  waitSteps = 0;
  rippleNode = -1;
  discover(src, 0);
  msg = "시작: " + src + " 방문 표시 후 enqueue";
  stepStart = frameCount;
}

// 정점 발견: 방문 표시 + 큐에 넣기 + 효과 시작
void discover(int v, int d) {
  visited[v] = true;
  dist[v] = d;
  queue.add(v);
  tx[v] = pos[v].x;           // 토큰이 그래프 위 정점에서 출발
  ty[v] = pos[v].y;
  rippleNode = v;
  rippleStart = frameCount;
}

// BFS 한 단계 진행
void step() {
  stepStart = frameCount;
  if (finished) {
    waitSteps++;
    msg = "BFS 종료 → 다시 시작까지 " + (restartDelay - waitSteps + 1);
    if (waitSteps > restartDelay) reset();
    return;
  }
  if (curr == -1) {
    checkV = -1;
    if (queue.isEmpty()) { finished = true; msg = "큐가 비었음 → BFS 종료"; return; }
    curr = queue.remove(0);
    result.add(curr);
    ni = 0;
    msg = "dequeue " + curr + " → 결과에 추가";
  } else if (ni < adj[curr].size()) {
    int x = adj[curr].get(ni++);
    checkV = x;
    if (!visited[x]) {
      discover(x, dist[curr] + 1);
      tree[curr][x] = tree[x][curr] = true;
      lastNew = true;
      msg = curr + "의 이웃 " + x + ": 미방문 → 방문 표시, enqueue";
    } else {
      lastNew = false;
      msg = curr + "의 이웃 " + x + ": 이미 방문 → 건너뜀";
    }
  } else {
    done[curr] = true;
    msg = curr + "의 이웃 확인 끝";
    curr = -1; checkV = -1;
  }
}

void draw() {
  if (!paused && frameCount % interval == 0) step();
  background(BG);

  float t = constrain((frameCount - stepStart) / (interval * 0.8), 0, 1);
  t = t * t * (3 - 2 * t);    // 부드러운 가속/감속

  // 간선
  for (int u = 0; u < n; u++) {
    for (int v : adj[u]) {
      if (u > v) continue;
      boolean checking = (u == curr && v == checkV) || (v == curr && u == checkV);
      if (checking)        { stroke(255, 80, 80); strokeWeight(3); }
      else if (tree[u][v]) { stroke(90, 160, 255); strokeWeight(4); }
      else                 { stroke(70, 76, 95); strokeWeight(2); }
      line(pos[u].x, pos[u].y, pos[v].x, pos[v].y);
    }
  }

  // 확인 중인 간선 위를 날아가는 패킷
  if (curr != -1 && checkV != -1) {
    PVector a = pos[curr], b = pos[checkV];
    float px = lerp(a.x, b.x, t), py = lerp(a.y, b.y, t);
    noStroke();
    fill(lastNew ? color(90, 210, 140) : color(255, 80, 80));
    ellipse(px, py, 14, 14);
  }

  // 파동 효과
  if (rippleNode != -1) {
    float p = (frameCount - rippleStart) / 40.0;
    if (p < 1) {
      noFill();
      stroke(255, 215, 80, 255 * (1 - p));
      strokeWeight(3);
      float r = 56 + 60 * p;
      ellipse(pos[rippleNode].x, pos[rippleNode].y, r, r);
    }
  }

  // 정점 (원형)
  for (int i = 0; i < n; i++) {
    // 현재 정점은 숨쉬듯 빛남
    if (i == curr) {
      noFill();
      stroke(255, 140, 50, 120);
      strokeWeight(6);
      float g = 70 + 8 * sin(frameCount * 0.15);
      ellipse(pos[i].x, pos[i].y, g, g);
    }
    fill(nodeColor(i));
    if (i == checkV) { stroke(255, 80, 80); strokeWeight(4); }
    else             { stroke(240); strokeWeight(2); }
    ellipse(pos[i].x, pos[i].y, 56, 56);
    fill(20);
    textSize(22);
    text(i, pos[i].x, pos[i].y - 2);
    if (visited[i]) {
      fill(200);
      textSize(13);
      text("d=" + dist[i], pos[i].x, pos[i].y + 42);
    }
  }

  // 설명 메시지
  fill(255);
  textSize(17);
  text(msg, width/2, 480);

  // Queue / Result 칸 + 날아다니는 토큰
  textAlign(LEFT, CENTER);
  fill(220); textSize(16);
  text("Queue", 30, 540);
  text("Result", 30, 600);
  textAlign(CENTER, CENTER);
  drawSlots(120, 540);
  drawSlots(120, 600);

  for (int v = 0; v < n; v++) {
    if (!visited[v]) continue;
    float targetX, targetY;
    int qi = queue.indexOf(v);
    if (qi >= 0) { targetX = 140 + qi * 52; targetY = 540; }
    else         { targetX = 140 + result.indexOf(v) * 52; targetY = 600; }
    tx[v] = lerp(tx[v], targetX, 0.12);
    ty[v] = lerp(ty[v], targetY, 0.12);
    fill(qi >= 0 ? YELLOW : GREEN);
    stroke(240); strokeWeight(1.5);
    ellipse(tx[v], ty[v], 40, 40);
    fill(20);
    textSize(16);
    text(v, tx[v], ty[v] - 1);
  }

  // 범례 & 조작법
  drawLegend(40, 650);
  fill(140);
  textSize(13);
  text("SPACE: 일시정지   →: 한 단계   R: 다시 시작", width/2, 685);
}

color nodeColor(int i) {
  if (i == curr) return ORANGE;
  if (done[i] || result.contains(i)) return GREEN;
  if (visited[i]) return YELLOW;
  return GRAY;
}

void drawSlots(float x, float y) {
  noFill();
  stroke(70, 76, 95);
  strokeWeight(1.5);
  for (int k = 0; k < n; k++) ellipse(x + 20 + k * 52, y, 40, 40);
}

void drawLegend(float x, float y) {
  String[] names = {"미방문", "큐에 있음", "현재 정점", "꺼낸 정점"};
  color[] cs = {GRAY, YELLOW, ORANGE, GREEN};
  textSize(13);
  textAlign(LEFT, CENTER);
  for (int k = 0; k < 4; k++) {
    fill(cs[k]); stroke(240); strokeWeight(1);
    ellipse(x + k * 135, y, 16, 16);
    fill(220);
    text(names[k], x + k * 135 + 14, y - 1);
  }
  textAlign(CENTER, CENTER);
}

void keyPressed() {
  if (key == ' ') paused = !paused;
  if (key == 'r' || key == 'R') reset();
  if (keyCode == RIGHT) step();
}
