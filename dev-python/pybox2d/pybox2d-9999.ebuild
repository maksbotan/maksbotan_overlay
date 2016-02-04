# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

EGIT_REPO_URI="git://github.com/pybox2d/pybox2d.git"

inherit distutils-r1 git-2

DESCRIPTION="2D Game Physics for Python"
HOMEPAGE="https://github.com/pybox2d/pybox2d"
SRC_URI=""

LICENSE="ZLIB"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-lang/swig:0
	dev-python/pygame
"
RDEPEND=""
