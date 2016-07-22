# ukboot
Unikernels boot time comprehensive measurements

## Requirements
Xen must be installed from sources, and these sources must be available somewhere on the file system.

## Usage
1. Edit `Config.mk` and set the `XEN_SRC_DIR` variable pointing to the sources of Xen.
2. Patch your mini-os sources using the provided patch (replace `<xen sources dir>` and `<ukboot root>` below according to your environment):

   ``` shell
  cd <xen sources dir>/extra/mini-os
  cp <ukboot root>/tools/mini-os-patch/mini-os-patch/mini-os-ukboot.patch .
  patch -p1 < mini-os-ukboot.patch
  ```
 
3. Compile unikernels and tools using `make`.
   If you experiment issues, please run the following command in this folder: `<xen sources dir>/stubdom`

   ``` shell
   ./configure --enable-c-stubdom
   ```
   
4. Edit the experiment parameters in Config.mk - see the comments inside for documentation about each variable.
5. Launch the experiment using `launch.sh`
