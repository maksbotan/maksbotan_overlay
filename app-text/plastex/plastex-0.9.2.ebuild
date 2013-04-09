# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=(python2_{6,7})
PYTHON_REQ_USE="xml"

inherit versionator distutils-r1

MY_PV=$(replace_all_version_separators '-')

DESCRIPTION="LaTeX document processing framework written entirely in Python"
HOMEPAGE="http://plastex.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/rel-${MY_PV}/${P}.tgz"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
