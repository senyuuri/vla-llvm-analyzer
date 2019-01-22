// sample test program - only an example
#include <stdlib.h>
 #include <stdint.h>

extern int f(int *);

/* given test cases */
int unsafe_func(size_t len)
{
    int array[len];
	return f(array);
}

int safe_func(size_t len)
{
    if (len > 100)
        abort();
    int array[len];
	return f(array);
}

int unsafe_func_2(size_t len, int unrelated)
{
    if (unrelated > 100)
        abort();
    int array[len];
	return f(array);
}

/* constant length array */
int const_func()
{
    int array[10];
	return f(array);
}
