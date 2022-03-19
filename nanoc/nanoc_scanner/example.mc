/* The GCD algorithm in MicroC */
int a;
int b;
float c;
char d;

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
  d = ' ';
  d = '&';
  c = 3.1415926;
  print(gcd(x,y));
  print(gcd(3,15));
  print(gcd(99,121));
  print(gcd(a,b));
  return 0;
}
