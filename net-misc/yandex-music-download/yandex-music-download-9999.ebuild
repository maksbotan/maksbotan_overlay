# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

EGIT_REPO_URI="git://github.com/kaimi-ru/yandex-music-download.git"

inherit git-r3

DESCRIPTION="Yandex Music downloader"
HOMEPAGE="https://github.com/kaimi-ru/yandex-music-download"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/Mozilla-CA
	dev-perl/MP3-Tag
	dev-perl/Getopt-Long-Descriptive"

src_prepare() {
	sed -i 's/\r//g' src/ya.pl || die "sed failed"
	sed -i '1 i\#\!\/usr\/bin\/env perl' src/ya.pl || die "sed failed"
}

src_install() {
	dobin src/ya.pl || die "dobin failed"
}
