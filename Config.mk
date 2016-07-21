# Variables defining the experiment
# ---------------------------------

# For each one of these number of currently running unikernels
# we do a measurement
CURRENTLY_RUNNING="0 2 4 8 16 32"

# Path to the unikernel binary that will be the currently 
# running one
RUNNING_UK="unikernels/background/mini-os.gz"

# Path to the unikernel binary of the one which will have its
# execution time measured
MEASURED_UK="unikernels/measured/mini-os.gz"

# Path to the chrono utility to measure execution time of xl
CHRONO="tools/chrono/chronoquiet"

# Folder to store temporary files
TMPDIR="./.tmp"

# Default memory given to each unikernel
UK_MEMORY="32"

# Default basename for background unikernels
BG_BASENAME="mini-os"

# Time to wait (s) between the boot of the background uks 
# and the boot of the measured uk
SAFETYSLEEP=0

# Name of the measured uk
MEASURED_NAME="measured"
