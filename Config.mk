# Variables defining the experiment
# ---------------------------------

# For each one of these number of currently running unikernels
# we do a measurement
CURRENTLY_RUNNING="0 2 4 8 16 32"

# Xen source dir for unikernel compilation
XEN_SRC_DIR="/root/popcorn-xen"

# Xenstore tracing file, set to "" to disable collecting results 
# related to this
XS_TRACEFILE="/var/log/xenstore"

# File where we put the results
OUTPUT_FILE="./result"

# Path to the background unikernels binary, and the measured one
RUNNING_UK="unikernels/background-idle/mini-os.gz"
MEASURED_UK="unikernels/measured/mini-os.gz"

# Default memory given to each unikernel
UK_MEMORY="32"

# Path to the chrono utility to measure execution time of xl
CHRONO="tools/chrono/chronoquiet"

# Time to wait (s) between the boot of the background uks 
# and the boot of the measured uk
SAFETYSLEEP=5

# VCPU pinning for background unikernels. Possibles values are: 
# - no: no pinning at all
# - sub: specify a range of CPUs to use with first and last. Do not pin
#        on any specific CPU on that range but let xen decide
# - rr: pin on specific CPUs in a round-robin way from first to 
#       last. For example with first=1 and last=3, newly created background 
#       unikernel will be pinned to PCPU #1, then 2, then 3, 1, 2, 3, etc.
# 
# Note that first and last are inclusive.
PINNING_BG="no"
PINNING_BGRR_FIRST=4
PINNING_BGRR_LAST=63

# CPU on which to pin the measured unikernel. To not pin, set this to 
# "no"
PINNING_M="no"

# Should we print the config before the results
PRINT_CONFIG="yes"

# Xenstore path where the measured unikernel write its boot time. Must 
# be concordant with the measured unikernel source code
XS_RESULT="/test/result"

# Less important parameters below
# ------------------------------

# Default basename for background unikernels
BG_BASENAME="mini-os"

# Name of the measured uk, and the background ones
MEASURED_NAME="measured"
BG_BASENAME="mini-os"

# Folder to store temporary files
TMPDIR="./.tmp"

# Should we clear the temporary files after one run ?
TMPCLEAR="yes"
