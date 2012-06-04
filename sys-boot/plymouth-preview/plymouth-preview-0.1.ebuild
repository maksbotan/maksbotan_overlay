# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Tool to preview the current Plymouth theme"
HOMEPAGE="https://launchpad.net/plymouth-preview"
SRC_URI="https://launchpad.net/${PN}/main/${PV}/+download/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="sys-boot/plymouth"

src_install() {
	dosbin ${PN}
}
