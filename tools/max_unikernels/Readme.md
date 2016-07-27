# Max_Unikernels

This tool is used to determine the maximum amount of unikernel that can run 
on a given host.

## Usage

1. Compile with `make` (you might need to edit `../../Config.mk` to set xen sources directory)

2. Run `test.sh`, wait for it to crash because of too much unikernels running. Results are un the file `results`
