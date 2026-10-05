# SPDX-License-Identifier: Apache-2.0
TARGET_KERNEL_EXT_MODULE_ROOT := kernel/mainline/sm6125-mainline-6.18-modules
TARGET_KERNEL_EXT_MODULES := panel:kbuild
# Drivers built into ACK are still packaged by the normal Lineage module rules.
# The panel remains disabled in the current SimpleDRM bringup configuration.
