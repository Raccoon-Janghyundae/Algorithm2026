int cnt = 3;
int[][] m = new int[cnt + 1][cnt + 1];

void setup() {
  int[][] sampleData = {
    {0, 4, 0},
    {2, 0, 5},
    {6, 1, 3}
  };

  for (int i = 0; i < cnt; i++) {
    for (int j = 0; j < cnt; j++) {
      m[i + 1][j + 1] = sampleData[i][j];
      print(nfp(m[i + 1][j + 1], 2) + " ");
    }
    println();
  }

  println(matrixPath(cnt, cnt));
}

void draw() {
}

int matrixPath(int i, int j) {
  if (i == 1 && j == 1) {
    return m[1][1];
  } else if (i == 1) {
    return matrixPath(1, j - 1) + m[i][j];
  } else if (j == 1) {
    return matrixPath(i - 1, 1) + m[i][j];
  } else {
    return min(matrixPath(i - 1, j), matrixPath(i, j - 1)) + m[i][j];
  }
}
