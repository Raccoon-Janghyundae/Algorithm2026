int[] arr;

void setup() {
  intArr(16);
  printArr();
  mergeSorting(0, arr.length - 1);
  printArr();
}

void intArr(int n) {
  arr = new int[n];
  for (int i = 0; i < arr.length; i++) {
    arr[i] = (int) random(100);
  }
}

void printArr() {
  for (int i = 0; i < arr.length; i++) {
    print(arr[i], " ");
  }
  println();
}

void mergeSorting(int p, int r) {
  if (p < r) {
    int q = (p + r) / 2;
    mergeSorting(p, q);
    mergeSorting(q + 1, r);
    merge(p, q, r);
  }
}

void merge(int p, int q, int r) {
  int i = p, j = q + 1, t = 0;
  int[] tmp = new int[r - p + 1];

  while (i <= q && j <= r) {
    if (arr[i] <= arr[j]) {
      tmp[t++] = arr[i++];
    } else {
      tmp[t++] = arr[j++];
    }
  }

  while (i <= q) {
    tmp[t++] = arr[i++];
  }
  while (j <= r) {
    tmp[t++] = arr[j++];
  }

  i = p;
  t = 0;
  while (i <= r) {
    arr[i++] = tmp[t++];
  }
}

void draw() {
}
