# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://git.code.sf.net/p/kiwix/other"
AUTOTOOLS_AUTORECONF=1

inherit autotools-utils git-r3

DESCRIPTION="console tool to create ZIM files from a localy stored directory containing HTML content"
HOMEPAGE="https://sourceforge.net/p/kiwix/other/ci/master/tree/zimwriterfs/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-libs/gumbo
	dev-libs/zimlib
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/${PN}"

src_prepare() {
	sed -i configure.ac \
		-e 's/AC_PROC_CC/AC_PROG_CC/' \
		-e 's/-Igumbo//' \
		-e 's/^CFLAGS="/CFLAGS="$CFLAGS /' \
		|| die 'sed configure.ac failed'
	sed -i Makefile.am \
		-e 's/gumbo\/[^ ]\+//g' \
		-e 's/LDFLAGS=/LDFLAGS=-lgumbo /' \
		|| die 'sed Makefile.am failed'

	autotools-utils_src_prepare
}
