#include <stdio.h>
#include <unistd.h>

int main(void) 
{
	struct timespec ts;
	ts.tv_sec = 0;
	ts.tv_nsec = 1;

        while(1)
	{
		nanosleep(&ts, NULL);
	}

        return 0;
}
