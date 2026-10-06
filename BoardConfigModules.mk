# SPDX-License-Identifier: Apache-2.0
TARGET_KERNEL_EXT_MODULE_ROOT := kernel/mainline/sm6125-mainline-6.18-modules
TARGET_KERNEL_EXT_MODULES := qcom/opensource/display-drivers/panel:kbuild
# Drivers built into ACK are still packaged by the normal Lineage module rules.
# The native profile selects the panel; SimpleDRM keeps it disabled.
