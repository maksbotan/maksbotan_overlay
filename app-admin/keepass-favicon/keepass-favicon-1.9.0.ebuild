# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PLUGIN_FILENAME="KeePassFaviconDownloader.plgx"
DESCRIPTION="A KeePass plugin that downloads and stores favicons"
HOMEPAGE="https://sourceforge.net/projects/keepass-favicon/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${PLUGIN_FILENAME}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-admin/keepass-2.09"
RDEPEND="${DEPEND}"

INSTALL_DIR="/usr/lib/keepass/"
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