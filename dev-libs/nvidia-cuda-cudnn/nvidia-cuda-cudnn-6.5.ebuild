# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PKG="cudnn-6.5-linux-x64-v2"
SRC_URI="${PKG}.tgz"

DESCRIPTION="NVIDIA cuDNN GPU Accelerated Deep Learning"
HOMEPAGE="https://developer.nvidia.com/cuDNN"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="fetch"

S="${WORKDIR}/${PKG}"

pkg_nofetch() {
    einfo "Please download"
    einfo "  - cudnn-6.5-linux-x64-v2.tgz"
    einfo "from ${HOMEPAGE} and place them in ${DISTDIR}"
}

src_install() {
	dolib.so libcudnn*$(get_libname)*
	dolib.a libcudnn_static.a

	insinto /usr/include
	doins cudnn.h
}