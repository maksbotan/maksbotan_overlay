# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="PronouncePwGen"
DESCRIPTION="A pronounceable password generator plugin for KeePass"
HOMEPAGE="https://sourceforge.net/projects/pronouncepwgen/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${MY_PN}-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-admin/keepass-2.19"
RDEPEND="${DEPEND}"

INSTALL_DIR="/usr/lib/keepass/"
PLUGIN_FILENAME="PronouncePwGen.plgx"
S="${WORKDIR}"

src_install() {
	chmod 644 "${PLUGIN_FILENAME}"
	insinto "${INSTALL_DIR}"
	doins "${PLUGIN_FILENAME}"
}

pkg_postinst() {
	elog "Restart KeePass to complete the installation."
}