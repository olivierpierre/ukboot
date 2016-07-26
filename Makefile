all: uk_bg uk_measured chrono

@PHONY: uk_bg
uk_bg: unikernels/background/mini-os.gz
unikernels/background/mini-os.gz: unikernels/background/main.c
	make -C unikernels/background/ 

@PHONY: uk_measured
uk_measured: unikernels/measured/mini-os.gz
unikernels/measured/mini-os.gz: unikernels/measured/main.c
	make -C unikernels/measured/ 

@PHONY: chrono
chrono: tools/chrono/chrono
tools/chrono/chrono: tools/chrono/chrono.c tools/chrono/chronoquiet.c
	make -C tools/chrono/

@PHONY: clean
clean:
	make clean -C tools/chrono/
	make clean -C unikernels/background/
	make clean -C unikernels/measured/
