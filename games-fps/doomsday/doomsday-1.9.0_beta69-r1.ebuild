# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doomsday/doomsday-1.9.0_beta69.ebuild,v 1.7 2011/10/15 14:08:01 xarthisius Exp $

EAPI=2

PYTHON_DEPEND="snowberry? 2"

inherit python confutils eutils cmake-utils games

MY_P=deng-1.9.0-beta6.9 # FIXME, this is stupid
DESCRIPTION="A modern gaming engine for Doom, Heretic, and Hexen"
HOMEPAGE="http://www.dengine.net/"
SRC_URI="mirror://sourceforge/deng/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64 ~x86"
IUSE="openal snowberry +doom demo freedoom heretic hexen resources"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl[video]
	media-libs/sdl-mixer
	media-libs/sdl-net
	media-libs/libpng
	net-misc/curl
	openal? ( media-libs/openal )
	snowberry? ( dev-python/wxpython )
	"
DEPEND="${RDEPEND}
	app-arch/zip"
PDEPEND="
	demo? ( games-fps/doom-data )
	freedoom? ( games-fps/freedoom )
	resources? ( games-fps/doomsday-resources )
	"

S=${WORKDIR}/${MY_P}/${PN}

PATCHES=( "${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-png15.patch
)

pkg_setup(){
	python_pkg_setup
	games_pkg_setup

	#Use confutils until games.eclass is ported to EAPI4
	confutils_require_any doom heretic hexen
	confutils_use_depend_all demo doom
	confutils_use_depend_all freedoom doom
	confutils_use_depend_all resources doom
}

src_configure() {
	mycmakeargs=(
		-Dbindir="${GAMES_BINDIR}"
		-Ddatadir="${GAMES_DATADIR}"/${PN}
		-Dlibdir="$(games_get_libdir)"/${PN}
		$(cmake-utils_use openal BUILDOPENAL)
		$(cmake-utils_use doom BUILDJDOOM)
		$(cmake-utils_use heretic BUILDJHERETIC)
		$(cmake-utils_use hexen BUILDJHEXEN)
	)
	cmake-utils_src_configure
}

#Usage: doom_make_wrapper <name> <game> <desktop entry title> [args]
doom_make_wrapper() {
	local name=$1 game=$2 de_title=$3
	shift 3
	games_make_wrapper $name \
		"doomsday -game ${game} $@"
	make_desktop_entry $name "${de_title}" orb-${game#j*}
}

src_install() {
	cmake-utils_src_install

	mv "${D}/${GAMES_DATADIR}"/{${PN}/data/jdoom,doom-data} || die
	dosym "${GAMES_DATADIR}"/doom-data "${GAMES_DATADIR}"/${PN}/data/jdoom || die

	doman engine/doc/${PN}.6
	dodoc engine/doc/*.txt build/README

	if use snowberry; then
		pushd .. > /dev/null
		insinto "${GAMES_DATADIR}"/${PN}
		doins -r snowberry/
		doicon snowberry/graphics/snowberry.png
		games_make_wrapper snowberry \
			"python2 \"${GAMES_DATADIR}\"/${PN}/snowberry/snowberry.py" \
			"${GAMES_DATADIR}"/${PN}/snowberry
		make_desktop_entry snowberry "Snowberry DoomsDay" snowberry
		popd > /dev/null
	fi

	if use doom; then
		local res_arg
		if use resources; then
			res_arg="-def \"${GAMES_DATADIR}\"/${PN}/defs/jdoom/jDRP.ded"
		fi

		doicon ../snowberry/graphics/orb-doom.png
		doom_make_wrapper jdoom jdoom "DoomsDay Engine: Doom 1" "${res_arg}"
		einfo "Created jdoom launcher. To play Doom place your doom.wad to"
		einfo "\"${GAMES_DATADIR}\"/doom-data"
		einfo

		if use demo; then
			doom_make_wrapper jdoom-demo jdoom "DoomsDay Engine: Doom 1 Demo" \
				"-file \"${GAMES_DATADIR}\"/doom-data/doom1.wad ${res_arg}"
		fi
		if use freedoom; then
			doom_make_wrapper jdoom-freedoom jdoom "DoomsDay Engine: FreeDoom" \
				"-file \"${GAMES_DATADIR}\"/doom-data/freedoom/doom1.wad"
		fi
	fi
	if use hexen; then
		doicon ../snowberry/graphics/orb-hexen.png
		doom_make_wrapper jhexen jhexen "DoomsDay Engine: Hexen"

		einfo "Created jhexen launcher. To play Hexen place your hexen.wad to"
		einfo "\"${GAMES_DATADIR}\"/${PN}/data/jhexen"
		einfo
	fi
	if use heretic; then
		doicon ../snowberry/graphics/orb-heretic.png
		doom_make_wrapper jheretic jheretic "DoomsDay Engine: Heretic"

		einfo "Created jheretic launcher. To play Heretic place your heretic.wad to"
		einfo "\"${GAMES_DATADIR}\"/${PN}/data/jheretic"
		einfo
	fi

	prepgamesdirs
}
