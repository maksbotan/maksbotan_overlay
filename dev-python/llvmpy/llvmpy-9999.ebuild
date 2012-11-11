# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_COMPAT=( python2_{6,7} python3_{1,2} )

EGIT_REPO_URI="git://github.com/llvmpy/llvmpy.git"

inherit distutils-r1 git-2

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="http://llvmpy.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-devel/llvm[multitarget]"
RDEPEND="${DEPEND}"

python_prepare() {
	distutils-r1-python_prepare
	if [[ ${EPYTHON} == python3.* ]]; then
		einfo "Running 2to3..."
		2to3 -w --no-diffs "${BUILD_DIR}"/llvm > /dev/null
	fi
}

python_test() {
	pushd "${BUILD_DIR}"/build/lib* > /dev/null
	${PYTHON} -c "import llvm; llvm.test()"
	popd > /dev/null
}
