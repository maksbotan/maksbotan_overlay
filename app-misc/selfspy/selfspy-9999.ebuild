# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

EGIT_REPO_URI="git://github.com/gurgeh/selfspy.git"

PYTHON_REQ_USE="tk"
inherit distutils-r1 git-2

DESCRIPTION="X11 personal keylogger daemon with statistical analysis"
HOMEPAGE="https://github.com/gurgeh/selfspy"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/python-daemon[${PYTHON_USEDEP}]
	dev-python/lockfile[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
