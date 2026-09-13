int[] arr;

void setup() {
  intArr(16);
  printArr();
  quickSorting(0, arr.length - 1);
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

void quickSorting(int p, int r) {
  if (p < r) {
    int q = partition(p, r);
    quickSorting(p, q - 1);
    quickSorting(q + 1, r);
  }
}

int partition(int p, int r) {
  int x = arr[r];
  int i = p - 1;
  int tmp;

  for (int j = p; j < r; j++) {
    if (arr[j] <= x) {
      i++;
      tmp = arr[i];
      arr[i] = arr[j];
      arr[j] = tmp;
    }
  }

  tmp = arr[i + 1];
  arr[i + 1] = arr[r];
  arr[r] = tmp;

  return i + 1;
}

void draw() {
}
