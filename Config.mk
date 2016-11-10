# Variables defining the experiment
# ---------------------------------

# Number of uks to boot
TO_BOOT=500

# Xen source dir for unikernel compilation
XEN_SRC_DIR="/root/popcorn-xen"

# UK path
RUNNING_UK="unikernels/background-idle/mini-os.gz"

# Default memory given to each unikernel
UK_MEMORY="32"

# Path to the chrono utility to measure execution time of xl
CHRONO="tools/chrono/chronoquiet"

# Less important parameters below
# ------------------------------

# Default basename for background unikernels
BG_BASENAME="mini-os"

# Folder to store temporary files
TMPDIR="./.tmp"
