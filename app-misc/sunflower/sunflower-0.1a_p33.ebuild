# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"

inherit python

DESCRIPTION="Small and highly customizable twin-panel file manager"
HOMEPAGE="http://code.google.com/p/sunflower-fm/"
SRC_URI="http://sunflower-fm.googlecode.com/files/Sunflower-0.1a-33.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/notify-python
	dev-python/gnome-vfs-python
	dev-python/libwnck-python
	x11-libs/vte"

S="${WORKDIR}"/Sunflower

pkg_setup(){
	python_set_active_version 2
}

src_install(){
	insinto /opt/sunflower
	doins -r .
	dodir /usr/bin
	cat > "${ED}"/usr/bin/sunflower << EOF
#!/bin/sh

python2 "${EPREFIX}"/opt/sunflower/Sunflower.py
EOF
	chmod +x "${ED}"/usr/bin/sunflower
}

pkg_postinst(){
	python_mod_optimize "${EPREFIX}"/opt/sunflower/application
}

pkg_postrm(){
	python_mod_cleanup "${EPREFIX}"/opt/sunflower/application
}
