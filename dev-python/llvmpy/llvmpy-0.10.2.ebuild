# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_{6,7} python3_{1,2} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="http://llvmpy.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-devel/llvm[multitarget]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-rpath.patch )

python_test() {
	pushd ${BUILD_DIR}/lib/ > /dev/null
	${PYTHON} -c "import llvm; llvm.test()"
	popd > /dev/null
}
