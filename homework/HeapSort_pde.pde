int[] arr;

void setup() {
  intArr(16);
  printArr();
  heapSorting();
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

void heapSorting() {
  int n = arr.length;

  // 1. buildHeap
  for (int i = n / 2 - 1; i >= 0; i--) {
    heapify(n, i);
  }

  // 2. 최대 원소 교환 및 heapify 반복
  for (int i = n - 1; i > 0; i--) {
    int tmp = arr[0];
    arr[0] = arr[i];
    arr[i] = tmp;

    heapify(i, 0);
  }
}

void heapify(int size, int root) {
  int largest = root;
  int left = 2 * root + 1;
  int right = 2 * root + 2;

  if (left < size && arr[left] > arr[largest]) {
    largest = left;
  }

  if (right < size && arr[right] > arr[largest]) {
    largest = right;
  }

  if (largest != root) {
    int tmp = arr[root];
    arr[root] = arr[largest];
    arr[largest] = tmp;

    heapify(size, largest);
  }
}

void draw() {
}
