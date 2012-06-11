# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="http://code.google.com/p/re2/"
SRC_URI="http://dev.gentoo.org/~maksbotan/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		NM="$(tc-getNM)" \
		CXXFLAGS="${CXXFLAGS} -pthread" \
		LDFLAGS="${LDFLAGS} -pthread"
}

src_install() {
	emake \
		prefix="${EPREFIX}"/usr \
		libdir="${EPREFIX}"/usr/$(get_libdir) \
		DESTDIR="${D}" \
		install
}

src_test() {
	emake \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		NM="$(tc-getNM)" \
		CXXFLAGS="${CXXFLAGS} -pthread" \
		LDFLAGS="${LDFLAGS} -pthread" \
		test
	dodoc README AUTHORS
}
