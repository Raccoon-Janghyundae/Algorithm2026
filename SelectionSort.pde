int[] list = new int[1000];
for (int i=0; i<list.length; i++) {
list[i] = (int)random(1000);
};
println(list);

int i, j, index, tmp, max;
for (i = 0; i < list.length-1; i++) {
max = index = -1;
for (j=0; j<list.length-1-i; j++) {
if (max < list[j]) {
max = list[j];
index = j;
}
}
if (index !=-1) {
tmp = list[j];
list[index] = tmp;
}
}

for (i=0; i<list.length; i++) {
print(list[i], " ");
}
