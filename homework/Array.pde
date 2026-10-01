class Array {
  int i0, j0, len, max, w;
  int[] arr;

  Array(int len, int i0, int j0) {
    max = 100;
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;
    arr = new int[len];
    w = (int) (width - 4) / len;
    shuffle();
  }

  Array(int len, int[] arr, int i0, int j0) {
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;
    this.arr = new int[len];
    w = (int) (width - 4) / len;
    for (int i = 0; i < len; i++)
      this.arr[i] = arr[i];
  }

  void draw() {
    int x, y, h;
    for (int i = 0; i < len; i++) {
      if ((j0 == i)) 
        fill(64);
      else
        fill(128);
      x = i * w + 2;
      h = arr[i];
      y = height - 5 * h - 60;
      rect(x, y, w, 5 * h);
    }
  }

  void shuffle() {
    for (int i = 0; i < len; i++)
      arr[i] = (int) random(max);
  }

  void printArray() {
    print("(" + nf(i0, 2) + "," + nf(j0, 2) + ")- ");
    for (int i = 0; i < len; i++)
      print(nf(arr[i], 2) + " ");
    println();
  }

  void swap(int[] targetArr, int i, int j) {
    int tmp = targetArr[j];
    targetArr[j] = targetArr[i];
    targetArr[i] = tmp; 
  }

  void selectionSort() {
    int i, j, maxVal, maxIdx, tlen = len;
    for (i = 0; i < len; i++) {
      plist = lists.get(i);
      lists.add(new Array(len, plist.arr, i + 1, len - i - 1));
      loop++;
      list = lists.get(i + 1);    
      maxVal = -1;
      maxIdx = -1;
      for (j = 0; j < tlen; j++) {
        if (maxVal < list.arr[j]) {
          maxVal = list.arr[j];
          maxIdx = j;
        }
      }
      if (maxIdx != -1) swap(list.arr, maxIdx, tlen - 1);
      tlen--;
    }
  }

  void bubbleSort() {
    int i, j;
    for (j = 0; j < len - 1; j++) {
      plist = lists.get(loop);
      lists.add(new Array(len, plist.arr, j + 1, 0));
      loop++;
      for (i = 0; i < len - j - 1; i++) {
        plist = lists.get(loop);
        lists.add(new Array(len, plist.arr, j + 1, i + 1));
        loop++;
        list = lists.get(loop);    
        if (list.arr[i] > list.arr[i + 1])
          swap(list.arr, i, i + 1);
      }
    }
  }

  void insertSort() {
    int i, j, temp;
    for (i = 1; i < len; i++) {
      plist = lists.get(loop);
      lists.add(new Array(len, plist.arr, i, i));
      loop++;
      list = lists.get(loop);    
      temp = list.arr[i];
      for (j = i - 1; j >= 0 && temp < list.arr[j]; j--) {
        list.arr[j + 1] = list.arr[j];
      }
      list.arr[j + 1] = temp;
    }
  }

  void mergeSort() {
    mergeSort(0, len - 1);
  }

  void mergeSort(int low, int high) {
    if (low < high) {
      int middle = low + (high - low) / 2;
      plist = lists.get(loop);
      lists.add(new Array(len, plist.arr, -low, -high));
      loop++;
      list = lists.get(loop);    
      mergeSort(low, middle);
      mergeSort(middle + 1, high);
      merge(list, low, middle, high);
    }
  }

  void merge(Array currentList, int low, int middle, int high) {
    int i, j, k;
    i = low;
    j = middle + 1;
    k = low;
    for (i = low; i <= high; i++) 
      tlist.arr[i] = currentList.arr[i];
    for (i = low; i <= high; i++) {
      while (i <= middle && j <= high) {
        if (tlist.arr[i] <= tlist.arr[j]) {
          currentList.arr[k] = tlist.arr[i];
          i++;
        } else {
          currentList.arr[k] = tlist.arr[j];
          j++;
        }
        k++;
      }
      while (i <= middle) {
        currentList.arr[k] = tlist.arr[i];
        k++;
        i++;
      }
    }
  }

  void quickSort() {
    quickSort(0, len - 1);
  }

  void quickSort(int low, int high) {
    if (low < high) {
      int i = low, j = high;
      plist = lists.get(loop);
      
      lists.add(new Array(len, plist.arr, low + 1, high + 1));
      loop++;
      list = lists.get(loop);
      
      int pivot = list.arr[low + (high - low) / 2];
      
      while (i <= j) {
        while (list.arr[i] < pivot) i++;
        while (list.arr[j] > pivot) j--;
        if (i <= j) {
          swap(list.arr, i, j);
          i++;
          j--;
        }
      }
      
      if (low < j) quickSort(low, j);
      if (i < high) quickSort(i, high);
    }
  }
}
