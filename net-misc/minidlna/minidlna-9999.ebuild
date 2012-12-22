# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/minidlna/minidlna-1.0.25-r1.ebuild,v 1.5 2012/11/08 11:43:45 aballier Exp $

EAPI=4

EHG_REPO_URI="https://bitbucket.org/stativ/minidlna-transcode"

inherit autotools eutils toolchain-funcs mercurial

DESCRIPTION="DLNA/UPnP-AV compliant media server, transcode branch"
HOMEPAGE="http://minidlna.sourceforge.net/ http://bitbucket.org/stativ/minidlna-transcode"
SRC_URI=""

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="tivo netgear readynas"

RDEPEND="dev-db/sqlite:3
	media-libs/flac
	media-libs/libexif
	media-libs/libid3tag
	media-libs/libogg
	media-libs/libvorbis
	virtual/ffmpeg
	virtual/jpeg"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	local my_is_new="yes"
	[ -d "${EPREFIX}"/var/lib/${PN} ] && my_is_new="no"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
	if [ -d "${EPREFIX}"/var/lib/${PN} ] && [ "${my_is_new}" == "yes" ] ; then
		# created by above enewuser command w/ wrong group and permissions
		chown ${PN}:${PN} "${EPREFIX}"/var/lib/${PN} || die
		chmod 0750 "${EPREFIX}"/var/lib/${PN} || die
		# if user already exists, but /var/lib/minidlna is missing
		# rely on ${D}/var/lib/minidlna created in src_install
	fi
}

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	econf \
		$(use_enable tivo) \
		$(use_enable netgear) \
		$(use_enable readynas)
}

src_install() {
	emake DESTDIR="${D}" install

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	dodir /var/lib/${PN} /var/log /var/cache/${PN}
	echo -n > "${ED}"/var/log/${PN}.log
	fowners ${PN}:${PN} /var/lib/${PN} /var/log/${PN}.log /var/cache/${PN}
	fperms 0750 /var/lib/${PN}
	fperms 0640 /var/log/${PN}.log

	insinto /etc
	doins minidlna.conf

	exeinto /usr/libexec/${PN}/
	for script in transcodescripts/*; do
		doexe "${script}"
	done
	sed -i 's|transcode_audio_transcoder=.*|transcode_audio_transcoder=/usr/libexec/minidlna/minidlna-transcode_audio|' "${ED}"/etc/minidlna.conf
	sed -i 's|transcode_video_transcoder=.*|transcode_video_transcoder=/usr/libexec/minidlna/minidlna-transcode_video|' "${ED}"/etc/minidlna.conf
	sed -i 's|transcode_image_transcoder=.*|transcode_image_transcoder=/usr/libexec/minidlna/minidlna-transcode_image|' "${ED}"/etc/minidlna.conf
	dodoc NEWS README TODO
}

pkg_postinst() {
	elog "minidlna now runs as minidlna:minidlna (bug 426726),"
	elog "logfile is moved to /var/log/minidlna.log,"
	elog "cache is moved to /var/lib/minidlna."
	elog "Please edit /etc/conf.d/${PN} and file ownerships to suit your needs."

	ewarn "This is experimental minidlna-transcode branch. Report bugs to upstream"
}
