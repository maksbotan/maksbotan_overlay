# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://github.com/maksbotan/plymouth-theme-preview.git"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_VERSIONED_SCRIPTS="/usr/libexec/plymouth-theme-preview-helper"

inherit git-2 distutils

DESCRIPTION="Previewer and configurator for Plymouth boot splash"
HOMEPAGE="https://github.com/maksbotan/plymouth-theme-preview"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="dev-python/dbus-python
	dev-python/python-slip
	dev-python/pygtk
	sys-auth/polkit
	sys-boot/plymouth"
