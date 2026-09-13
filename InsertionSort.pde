int[] arr;

void setup() {
  intArr(16);
  printArr();
  insertionSorting();
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

void insertionSorting() {
  int i, loc, newItem;
  for (i = 1; i < arr.length; i++) {
    loc = i - 1;
    newItem = arr[i];
    while (loc >= 0 && newItem < arr[loc]) {
      arr[loc + 1] = arr[loc];
      loc--;
    }
    arr[loc + 1] = newItem;
  }
}

void draw() {
}
