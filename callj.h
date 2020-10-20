// Julia headers (for initialization and gc commands)
#include "uv.h"
#include "julia.h"


// prototype of the C entry points in our application
void greet(void);
int jlmax(int *cx, size_t len);
int jlmin(int *cx, size_t len);
int jlminus(int *cx, size_t len);
int jlreverse(int *cx, size_t len);
