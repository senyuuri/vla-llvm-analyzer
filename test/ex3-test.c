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
    if (len < 100)
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


/* ult+ule size_t*/
int ult_safe_func(size_t len){
	if (len < 1000){
		int array[len];
		return f(array);
	}
    abort();
}

int ult_unsafe_func(size_t len){
	if (len < 1001){
		int array[len];
		return f(array);
	}
    abort();
}


int ule_safe_func(size_t len){
	if (len <= 999){
		int array[len];
		return f(array);
	}
    abort();
}

int ule_unsafe_func(size_t len){
	if (len <= 1000){
	    int array[len];
		return f(array);
	}
	abort();
}

/* ult uint32_t */
int ult32_safe_func(uint32_t len){
	if (len < 1000){
		int array[len];
		return f(array);
	}
    abort();
}

int ult32_unsafe_func(uint32_t len){
	if (len < 1001){
		int array[len];
		return f(array);
	}
    abort();
}

/* ult uint64_t */
int ult64_safe_func(uint64_t len){
	if (len < 1000){
		int array[len];
		return f(array);
	}
    abort();
}

int ult64_unsafe_func(uint64_t len){
	if (len < 1001){
		int array[len];
		return f(array);
	}
    abort();
}


/* slt int32_t */
int slt32_safe_func(int32_t len){
	if (len < 1000){
		int array[len];
		return f(array);
	}
    abort();
}

int slt32_unsafe_func(int32_t len){
	if (len < 1001){
		int array[len];
		return f(array);
	}
    abort();
}

/* slt int64_t */
int slt64_safe_func(int64_t len){
	if (len < 1000){
		int array[len];
		return f(array);
	}
    abort();
}

int slt64_unsafe_func(int64_t len){
	if (len < 1001){
		int array[len];
		return f(array);
	}
    abort();
}

/* more complicated test cases */
int nested_cond_safe_func(int64_t len){
	if (len <= 999)
	{
		if(len < 1500){
			if(len < 2500){
				int array[len];
				return f(array);
			}
		}
	}
    abort();
}

int nested_cond_unsafe_func(int64_t len){
	if (len < 2000)
	{
		if(len < 1500){
			if(len < 1100){
				int array[len];
				return f(array);
			}
		}
	}
    abort();
}

int two_vars_unsafe_func(size_t len){
	int len2 = len;
	int array[len2];
	return f(array);
}

int two_vla_unsafe_func(size_t len, int unrelated){
	if(unrelated > 100)
		abort();
	int array[len];
	int array2[len];
	return f(array) + f(array2);
}