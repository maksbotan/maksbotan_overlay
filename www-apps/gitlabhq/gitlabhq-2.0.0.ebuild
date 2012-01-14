# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="Project management and code hosting application"
HOMEPAGE="http://gitlabhq.com"
SRC_URI="https://github.com/${PN}/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-db/redis
	dev-vcs/git
	dev-vcs/gitolite
	dev-python/pygments
	virtual/mta"

ruby_add_rdepend "
	dev-ruby/rails
	dev-ruby/bundler
	dev-ruby/charlock_holmes
"

RUBY_S="${PN}-${PN}-*"
