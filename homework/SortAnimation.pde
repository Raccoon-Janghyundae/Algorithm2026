ArrayList<Array> lists;
Array list, plist, tlist;
int type=4, napTime=100, len=16, index=0, loop=0;
boolean autoFlag=true;
String[] titles = {"selectionSort", "bubbleSort", "insertSort", "mergeSort", "quickSort"};
PFont f;

void setup() {
  size(900, 600);  
  f = createFont("Arial", 24);
  textFont(f);
  run(type);
}

void draw() {
  background(200);
  list = lists.get(index);
  list.draw();
  fill(0);
  if (list.i0 <= 0)
    text("("+nf(-list.i0, 2)+","+nf(-list.j0, 2)+") - "+index+"/"+loop 
      +" napTime:"+napTime+"(a/s)" + " type:"+type+"(z/x)", 20, height-20);
  else
    text("("+nf(list.i0, 2)+","+nf(list.j0, 2)+") - "+index+"/"+loop 
      +" napTime:"+napTime+"(a/s)" + " type:"+type+"(z/x)", 20, height-20);
  text(titles[type], 20, 40);
  if (autoFlag) nextStep();
}

void nextStep() {
  if (index == 0)
    delay(10 * napTime);
  else 
    delay(napTime);
  if (index < loop) index++;
  else index = 0;
}

void keyPressed() {
  if (key == ' ') {
    autoFlag = !autoFlag;
  } else if (key == 'a') {
    if (napTime > 100)
      napTime -= 100;
  } else if (key == 's') {
    napTime += 100;
  } else if (key == 'z') {
    if (type > 0) {
      type--;
      run(type);
    }  
  } else if (key == 'x') {
    if (type < 4) {
      type++;
      run(type);
    }  
  } else if (key == CODED) {
    if (keyCode == LEFT) {
      if (index > 0) index--;
    } else if (keyCode == RIGHT) {
      if (index < loop) index++;
    } 
  }
}

void mousePressed() {
  if (autoFlag) autoFlag = false;
  if (mouseButton == LEFT) {
    if (index > 0) index--;
  } else if (mouseButton == RIGHT) {
    if (index < loop) index++;
  }
}

void run(int type) {
  loop = index = 0;
  tlist = new Array(len, 0, -1);
  lists = new ArrayList<Array>();
  lists.add(new Array(len, 0, -1));
  list = lists.get(0);
  list.printArray();
  
  if (type == 0) list.selectionSort();
  else if (type == 1) list.bubbleSort();
  else if (type == 2) list.insertSort();
  else if (type == 3) list.mergeSort();
  else if (type == 4) list.quickSort();  
  
  list = lists.get(loop);
  list.printArray();
}
