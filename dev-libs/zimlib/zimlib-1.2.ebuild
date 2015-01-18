# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1

if [[ ${PV} == 9999 ]]; then
	AUTOTOOLS_AUTORECONF=1
	EGIT_REPO_URI="https://gerrit.wikimedia.org/r/p/openzim.git"
	KEYWORDS=""
	SRC_URI=""
	S="${WORKDIR}/${P}/${PN}"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://www.openzim.org/download/${P}.tar.gz"
fi

inherit autotools-utils

DESCRIPTION="The zimlib is the standard implementation of the ZIM specification"
HOMEPAGE="http://www.openzim.org//wiki/Libzim"

LICENSE="GPL-2"
SLOT="0"
IUSE="bzip2 +lzma test zlib"

RDEPEND="
	app-arch/xz-utils
"
DEPEND="${RDEPEND}
	test? ( dev-libs/cxxtools )
"

src_configure() {
	# Do not compile
	# $(use_with cxxtools)
	# $(use_enable benchmark)
	local myeconfargs=(
		$(use_enable zlib)
		$(use_enable bzip2)
		$(use_enable lzma)
		$(use_enable test unittest)
	)

	autotools-utils_src_configure
}
