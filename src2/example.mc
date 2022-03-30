/* The GCD algorithm in NanoC */
int a;
int b;

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
  int x=0;
  int z;
  z=0;
  a = 18;
  b = 9;
  x = 2;
  y = 14;
  print(gcd(x,y));
  print(gcd(3,15));
  int x;
  print(gcd(99,121));
  print(gcd(a,b));
  return 0;
}
