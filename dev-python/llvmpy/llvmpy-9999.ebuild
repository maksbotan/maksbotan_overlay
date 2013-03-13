# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_{6,7} python3_{1,2} )

EGIT_REPO_URI="git://github.com/llvmpy/llvmpy.git"

inherit distutils-r1 git-2

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="http://llvmpy.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-devel/llvm[multitarget]"
RDEPEND="${DEPEND}"

python_test() {
	pushd "${BUILD_DIR}"/lib > /dev/null
	${PYTHON} -c "import llvm; llvm.test()"
	popd > /dev/null
}
