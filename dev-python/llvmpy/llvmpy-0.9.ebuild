# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

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

python_prepare() {
	distutils-r1_python_prepare
	if [[ ${EPYTHON} == python3.* ]]; then
		einfo "Running 2to3..."
		2to3 -w --no-diffs "${BUILD_DIR}"/llvm > "${T}"/${EPYTHON}-2to3.log 2>&1 || die "2to3 failed, log file: ${T}/${EPYTHON}-2to3.log"
	fi
}

python_test() {
	pushd "${BUILD_DIR}"/build/lib* > /dev/null
	${PYTHON} -c "import llvm; llvm.test()"
	popd > /dev/null
}
