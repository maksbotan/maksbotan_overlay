# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="*"
PYTHON_USE_WITH="xml"
SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="setup.py"

inherit vcs-snapshot distutils

DESCRIPTION="MIT licensed XMPP library for Python"
HOMEPAGE="http://sleekxmpp.com/"
SRC_URI="https://github.com/fritzy/SleekXMPP/tarball/${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples"

DEPEND="dev-python/setuptools"
RDEPEND="
	dev-python/dnspython
	dev-python/python-gnupg
"

src_install() {
	distutils_src_install
	if use doc; then
		dodoc -r docs
	fi
	if use examples; then
		dodoc -r examples
	fi
}
