int main() {
    array char [7] x;
    array int [10] y;
    int i=0;

    array int [5] z;
    z={1,-482848242,110,19,91};
    y[0]=10;
    x[0]='a';
    while(i<8){
      y[i+1]=i;
      print(string_of_int(y[i]));
      print("\n");
      i=i+1;
    }
    print(string_of_int(y[0]));
    print("\n");
    print("Size of array x is ");
    print(string_of_int(x.length));
    print("\n");
	print(string_of_int(z[1]));
print("\n");
    return 0;
}
