# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="KeePass plugin to expose password entries securely (256bit AES/CBC) over HTTP"
HOMEPAGE="https://github.com/pfn/keepasshttp"
SRC_URI="https://raw.github.com/pfn/keepasshttp/master/KeePassHttp.plgx"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=app-admin/keepass-2.20"
RDEPEND="${DEPEND}"

INSTALL_DIR="/usr/lib/keepass/"
PLUGIN_FILENAME="KeePassHttp.plgx"
S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${PLUGIN_FILENAME}" "${WORKDIR}" || die
}

src_install() {
	chmod 644 "${PLUGIN_FILENAME}"
	insinto "${INSTALL_DIR}"
	doins "${PLUGIN_FILENAME}"
}

pkg_postinst() {
	elog "Restart KeePass to complete the installation."
}
