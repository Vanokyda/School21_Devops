#include <fcgi_stdio.h>
#include <stdlib.h>

void main(void) {
  /* Response loop. */
  while (FCGI_Accept() >= 0) {
    printf(
        "Content-type: text/html\r\n"
        "\r\n");
    printf("Hello, world!");
  }
}