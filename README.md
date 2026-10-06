# Mi A3 6.18 external kernel modules

The optional Samsung S6E8FCO panel driver is maintained under qcom/opensource/display-drivers/panel/ with its
original license, copyright and attributed commit history. Kbuild compiles it
only when CONFIG_DRM_PANEL_SAMSUNG_S6E8FCO=m. Its configuration dependencies
remain in the kernel; the option cannot be selected built-in after extraction.
The current SimpleDRM profile keeps it disabled and module load lists empty.

BoardConfigModules.mk uses Lineage's TARGET_KERNEL_EXT_MODULE_ROOT and
TARGET_KERNEL_EXT_MODULES with qcom/opensource/display-drivers/panel:kbuild. Lineage builds against the same
kernel output, installs into the common staging directory and generates the
combined module dependency metadata for vendor packaging. Do not introduce
prebuilt or mismatched modules.

ACK's upstream loadable drivers stay in ACK, like GKI core modules; their
newly built .ko files are still installed by Lineage. Boot-critical UFS, USB,
CPU, power and thermal drivers stay built in. This repository is for external
board/vendor drivers, not a copy of every upstream driver. Generic touch, GPU
and subsystem patches remain in ACK until independently modularized.

Companions: sm6125-mainline-6.18 and sm6125-mainline-6.18-devicetrees.
This split awaits a maintainer build and boot check. See the kernel's
Documentation/android/SPLIT_SOURCES.md and IMPORT_HISTORY.txt.

Native-profile status (2026-10-06): the ROM packages the freshly built Samsung
panel module in recovery-as-boot and vendor. The maintainer's build #15 has
working native physical scanout; live Settings scrolling confirms hardware
composition. No panel-driver source change was needed for this milestone.
Do not commit generated .ko, .o, .mod or Kbuild command files.
