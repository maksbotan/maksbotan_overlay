# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A transport and architecture agnostic rpc library"
HOMEPAGE="http://spyne.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

RDEPEND="dev-python/pytz[${PYTHON_USEDEP}]"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"