int main() {
    array char [7] x;
    array int [10] y;
    int i=0;

    y[5]=10;
    x[0]='a';
    while(i<8){
      y[i+1]=i;
      i=i+1;
    }
    string_of_int(y[0]);

    return 0;
}
