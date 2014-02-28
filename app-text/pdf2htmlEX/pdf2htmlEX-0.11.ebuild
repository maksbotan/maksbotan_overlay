# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/coolwanglu/${PN}.git"
	SRC_URI=""
	inherit git-r3
else
	SRC_URI="https://github.com/coolwanglu/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

inherit cmake-utils

DESCRIPTION="Convert PDF to HTML without losing text or format."
HOMEPAGE="http://coolwanglu.github.com/pdf2htmlEX/"

LICENSE="GPL-3 MIT"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~x86"
IUSE="svg"

DEPEND="
	app-text/poppler[jpeg2k]
	media-gfx/fontforge[python,unicode]
	svg? (
		media-libs/freetype
		x11-libs/cairo[svg]
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable svg)
	)

	cmake-utils_src_configure
}
