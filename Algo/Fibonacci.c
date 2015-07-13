#include <stdio.h>
void Fibonacci()
{
  int a = 0;
  int b = 1;
  int c ;
  int i,n = 0;
  scanf("%d",&n);
  for (i = 0;i < n;i ++){
  c = a + b;
  b = c;
  a = b;
  printf("%d\n",c);
  }
}

int main()
{
  printf("hello");
  Fibonacci();
  return 0;
}

