// 심플 격자 BFS - 클릭한 곳에서 파동처럼 퍼짐
int N = 20, S = 25;       // 칸 수, 칸 크기
int[][] d = new int[N][N];
boolean[][] wall = new boolean[N][N];
int t = 0, maxD = 0;

void setup() {
  size(500, 500);
  for (int x = 0; x < N; x++)
    for (int y = 0; y < N; y++) wall[x][y] = random(1) < 0.2;
  bfs(N/2, N/2);
}

void bfs(int sx, int sy) {
  for (int x = 0; x < N; x++)
    for (int y = 0; y < N; y++) d[x][y] = -1;
  wall[sx][sy] = false;
  ArrayList<int[]> q = new ArrayList<int[]>();
  d[sx][sy] = 0; q.add(new int[]{sx, sy});
  int[] dx = {1, -1, 0, 0}, dy = {0, 0, 1, -1};
  maxD = 0;
  while (!q.isEmpty()) {
    int[] c = q.remove(0);
    for (int k = 0; k < 4; k++) {
      int nx = c[0] + dx[k], ny = c[1] + dy[k];
      if (nx < 0 || ny < 0 || nx >= N || ny >= N) continue;
      if (wall[nx][ny] || d[nx][ny] != -1) continue;
      d[nx][ny] = d[c[0]][c[1]] + 1;
      maxD = max(maxD, d[nx][ny]);
      q.add(new int[]{nx, ny});
    }
  }
  t = 0;
}

void draw() {
  if (frameCount % 5 == 0) t++;
  if (t > maxD + 15) t = 0;    // 끝나면 반복
  background(255);
  stroke(230);
  for (int x = 0; x < N; x++)
    for (int y = 0; y < N; y++) {
      if (wall[x][y]) fill(50);
      else if (d[x][y] != -1 && d[x][y] <= t)
        fill(lerpColor(color(255, 200, 80), color(80, 120, 230), d[x][y] / (float) maxD));
      else fill(255);
      rect(x * S, y * S, S, S);
    }
}

void mousePressed() {
  bfs(mouseX / S, mouseY / S);   // 클릭한 칸에서 다시 시작
}
