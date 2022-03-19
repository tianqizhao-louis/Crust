/* The GCD algorithm in MicroC */
int a;
// THis is a single line comment 
int b;
float c;
char d;
string e;

int gcd(int a, int b) {
  while (a != b) {
    if (b < a) a = a - b;
    else b = b - a;
  }
  return a;
}

int main() {
  int x;
  int y;
  a = 18;
  b = 9;
  x = 2;
  y = 14;
  d = 'a';
  d = '\n';
  c = 3.1415926;
  c = 5;
  e = "";
  e = "123\t456";
  print(gcd(x,y));
  print(gcd(3,15));
  print(gcd(99,121));
  print(gcd(a,b));
  [1,2,3]
  return 0;
}
