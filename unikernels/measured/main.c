#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>

typedef uint16_t domid_t;

#include <xenbus.h>
#include <boot_measure.h>

#define WRITE_PATH  "/test/result"

int main(void) {
    char write_data [128];
    char *err;

    sleep(3);

    sprintf(write_data, "%llu", bootmeasure2 - bootmeasure1);    
	
    err = xenbus_write(XBT_NIL, WRITE_PATH, write_data);
	if(err != NULL)
	{
		printf("Error writing in %s: %s\n", WRITE_PATH, err);
	    free(err);
        return -1;
    }

    return 0;
}
