# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="The Simple Library for Python packages"
HOMEPAGE="https://fedorahosted.org/python-slip/"
SRC_URI="https://fedorahosted.org/released/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gtk selinux"
RDEPEND="selinux? ( sys-libs/libselinux )
	dev-python/dbus-python
	sys-auth/polkit
	dev-python/decorator
	gtk? ( dev-python/pygtk )"

src_prepare() {
	sed -e "s:@VERSION@:${PV}:g" setup.py.in > setup.py || die "sed failed"
}

src_install() {
	distutils_src_install

	if use examples; then
		dodoc -r doc/dbus
	fi
}
