SRC=main.c

include ../../Config.mk

all:
	make -C $(XEN_SRC_DIR)/stubdom/c clean
	cp -rf $(SRC) $(XEN_SRC_DIR)/stubdom/c/
	make -C $(XEN_SRC_DIR)/stubdom c-stubdom -j$(shell cat /proc/cpuinfo | grep processor | wc -l)
	cp -f $(XEN_SRC_DIR)/stubdom/mini-os-x86_64-c/mini-os.gz .

local_run: all
	xl create local_domain_config.xl -c

clean:
	rm -rf mini-os.gz
