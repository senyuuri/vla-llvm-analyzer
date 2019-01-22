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

/* same/diff block assignment */
int same_blK_assign_unsafe_func(size_t len, int unrelated)
{
    if (unrelated > 100)
		abort();
    int new_var = rand()%10+1;	
	int array[new_var];
	return f(array);
}

int diff_blK_assign_safe_func(size_t len, int unrelated)
{
	// new_var is created in the entry block
	size_t new_var = len * 2;
	if(len < 100){
		
		if (unrelated > 100)
			abort();
		int array[new_var];
		return f(array);
	}
	abort();
}
