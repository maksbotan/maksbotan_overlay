# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://github.com/RD777/rt3573sta.git"

inherit git-r3 linux-info linux-mod

DESCRIPTION="Realtek 8192 chipset driver, ported to kernel 3.11"
HOMEPAGE="https://github.com/pvaret/rtl8192cu-fixes"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MODULE_NAMES="rt3573sta(kernel/drivers/net/wireless::os/linux/)"
BUILD_TARGETS="all"

CONFIG_CHECK="WEXT_PRIV"

src_prepare() {
	sed -e 's@/tftpboot@/dev/null@g' -i Makefile || die "sed failed"
}
