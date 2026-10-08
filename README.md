# Mi A3 6.18 external kernel modules

Current source (2026-10-08): the panel uses the committed deferred 20 ms
brightness worker. The experimental exported DSI frame-wait API and retries
were reverted; matching kernel and freshly built panel modules remain required.
See the companion kernel Documentation/android/DISPLAY_STARTUP.md for history
and WIFI_REVIEW.md for the current publication and validation limits.

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

Build #17 recovery investigation: initial panel commands now succeed after
the companion kernel's controller quiesce change, but the first high-speed
brightness command times out and the screen stays black. The exact Laurel
4.14 panel description requests delay_until_first_frame for brightness.
The next source candidate waits 20 ms in panel enable, after host video
startup and before DRM enables the backlight. This is a frame-interval delay,
not a vblank synchronization guarantee. Brightness read/write callbacks now
restore their original DSI mode flags on both success and failure.
High-speed brightness mode is retained, matching the downstream description.
These module edits have not been compiled or device validated; rebuild the
module packaged in both recovery and vendor, and inspect the first brightness
transfer and physical recovery display. See NATIVE_GRAPHICS.md for logs and
the separately validated MDSS reset workaround.

The maintainer reports the synchronous 20 ms candidate still has black
recovery and delayed Android output. The installed vendor panel module hash
matches the local rebuilt module. MSM commit-tail enables bridges before
flush_commit kicks off the frame: sleeping inside panel enable delays the
frame as well. The revised candidate schedules the initial brightness update
on delayed work instead, allowing enable to return. Early brightness updates
are deferred; the worker applies the current backlight state. Disable/removal
cancel the work synchronously. The 20 ms interval is still a scheduling
heuristic, not a hardware first-frame completion guarantee. This revision
was initially uncompiled. The latest maintainer build reports working recovery
through the companion kernel's SimpleDRM fallback, but Android's display
transition delay remains. That fallback does not bind this panel driver;
recovery success does not validate the delayed-brightness change. No new
device logs isolate its effect on native Android output.

## Wi-Fi candidate

WCN3990 board wiring belongs to the devicetrees repo; upstream ath10k and
its vendor modules belong to the ACK kernel, not a duplicate external driver.
Android firmware links and services belong to the ROM tree. See the companion
kernel `Documentation/android/WIFI.md` for provenance, integration and pending
2.4/5 GHz validation. Build #23 reaches FW_READY in QMI-only mode; full mode hangs during CE MMIO
initialization. Wi-Fi connectivity remains unvalidated. See WIFI_REVIEW.md.

## Complete display rollback, 2026-10-08

Following the report of a stuck Lineage boot logo, all remaining uncommitted
display experiments have now been restored to the committed baseline:
DPU teardown/MMU reordering, exported DSI frame wait and panel brightness
retry changes are removed, in addition to splash retention. The panel again
uses the committed deferred 20 ms brightness worker. Earlier historical
candidate descriptions above no longer describe the current source.
Wi-Fi, recovery UI and Connectivity BPF changes remain independent.
Archived display diffs are in out/display-revert-20261008 locally. Matching
kernel and panel modules must be rebuilt together; no runtime fix is claimed
until the maintainer validates.
